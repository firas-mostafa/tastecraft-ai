import json
import os
import urllib.parse
from channels.generic.websocket import AsyncWebsocketConsumer
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_core.messages import HumanMessage, AIMessage, SystemMessage, ToolMessage
from langchain_core.tools import StructuredTool

from core.models import Message
from .conversation_service import create_conversation, get_conversation_with_messages, save_message, set_conversation_title
from .recipe_tool import RecipeToolInput, handle_recipe_saving

class ChatConsumer(AsyncWebsocketConsumer):
    async def connect(self):
        await self.accept()

        self.history = [
            SystemMessage(
                content="You are a helpful assistant in a recipe and cooking application. You have a tool to save recipes to the user's database. When a user asks for a recipe, present it elegantly using Markdown formatting (e.g. use bolding, bullet points). Always include a YouTube search link for the recipe like this: `[Watch on YouTube](https://www.youtube.com/results?search_query=recipe+name)`. After presenting the recipe, ask the user if they would like to save this recipe. ONLY use the `save_generated_recipe` tool IF the user explicitly confirms they want to save it. When using the tool, provide a highly detailed image prompt in English for the recipe."
            )
        ]

        self.conversation = None
        query_string = self.scope.get('query_string', b'').decode('utf-8')
        params = urllib.parse.parse_qs(query_string)
        conversation_id = params.get('conversation_id', [None])[0]

        if conversation_id:
            user = self.scope.get("user")
            if user and user.is_authenticated:
                self.conversation, messages = await get_conversation_with_messages(conversation_id, user)
                if self.conversation:
                    for msg in messages:
                        if msg.role == Message.ROLE_HUMAN:
                            self.history.append(HumanMessage(content=msg.content))
                        elif msg.role == Message.ROLE_AI:
                            self.history.append(AIMessage(content=msg.content))

        self.api_key = os.environ.get("GEMINI_API_KEY") or os.environ.get("GOOGLE_API_KEY")
        if not self.api_key:
            await self.send(text_data=json.dumps({
                "type": "error",
                "message": "Warning: GEMINI_API_KEY / GOOGLE_API_KEY is not configured in the backend environment."
            }))
        else:
            await self.send(text_data=json.dumps({
                "type": "status",
                "message": "Connected to Gemini WebSocket. Send your prompt!"
            }))

    async def disconnect(self, close_code):
        pass

    async def transcribe_audio(self, base64_audio):
        import base64
        import tempfile
        import requests
        import asyncio

        try:
            audio_bytes = base64.b64decode(base64_audio)
            with tempfile.NamedTemporaryFile(suffix='.m4a', delete=False) as temp_file:
                temp_file.write(audio_bytes)
                temp_file_path = temp_file.name

            whisper_url = os.environ.get("WHISPER_URL", "http://whisper:9000/asr")

            def call_whisper():
                with open(temp_file_path, 'rb') as f:
                    response = requests.post(
                        whisper_url,
                        files={'audio_file': (os.path.basename(temp_file_path), f, 'audio/m4a')}
                    )
                return response

            response = await asyncio.to_thread(call_whisper)

            try:
                os.remove(temp_file_path)
            except OSError:
                pass

            if response.status_code == 200:
                result = response.json()
                return result.get("text", "").strip()
            else:
                print(f"Whisper API error: {response.status_code} - {response.text}")
                return None
        except Exception as e:
            print(f"Exception in transcribe_audio: {e}")
            return None

    async def receive(self, text_data):
        try:
            data = json.loads(text_data)
            prompt = data.get("prompt", "")
            base64_image = data.get("image")
            base64_audio = data.get("audio")
        except json.JSONDecodeError:
            await self.send(text_data=json.dumps({"type": "error", "message": "Invalid JSON format received."}))
            return

        if not prompt and not base64_image and not base64_audio:
            await self.send(text_data=json.dumps({"type": "error", "message": "Please provide either a prompt, an image, or an audio message."}))
            return

        if base64_audio:
            transcribed_text = await self.transcribe_audio(base64_audio)
            print(f"[DEBUG] Audio transcription result: '{transcribed_text}'")
            if not transcribed_text:
                await self.send(text_data=json.dumps({"type": "error", "message": "حدث خطأ أثناء معالجة الصوت أو لم يتم اكتشاف أي كلام."}))
                return
            prompt = transcribed_text

        if not self.api_key:
            self.api_key = os.environ.get("GEMINI_API_KEY") or os.environ.get("GOOGLE_API_KEY")
            if not self.api_key:
                await self.send(text_data=json.dumps({"type": "error", "message": "API Key is missing."}))
                return

        user = self.scope.get("user")
        if self.conversation is None and user and user.is_authenticated:
            title = prompt[:100] if (prompt and prompt != "Audio Message") else "Voice Message Query"
            self.conversation = await create_conversation(user, title)

        if self.conversation:
            db_content = prompt
            if base64_image and not prompt:
                db_content = "[Sent an Image]"
            elif base64_image and prompt:
                db_content = f"[Sent an Image] {prompt}"
            elif base64_audio and (not prompt or prompt == "Audio Message"):
                db_content = "[Sent a Voice Note]"
            elif base64_audio and prompt:
                db_content = f"[Sent a Voice Note] {prompt}"
            await save_message(self.conversation, Message.ROLE_HUMAN, db_content)

        if base64_image:
            human_message = HumanMessage(content=[
                {"type": "text", "text": prompt or "Describe this image."},
                {"type": "image_url", "image_url": {"url": f"data:image/jpeg;base64,{base64_image}"}},
            ])
        elif base64_audio:
            human_message = HumanMessage(content=prompt)
        else:
            human_message = HumanMessage(content=prompt)

        self.history.append(human_message)
        await self.send(text_data=json.dumps({"type": "start", "message": "Streaming response..."}))

        try:
            llm = ChatGoogleGenerativeAI(model="gemini-2.5-flash", google_api_key=self.api_key)
            
            async def wrapped_tool(**kwargs):
                return await handle_recipe_saving(user, **kwargs)

            save_recipe_tool = StructuredTool.from_function(
                coroutine=wrapped_tool,
                name="save_generated_recipe",
                description="Generates an image and saves the recipe to the database for the user.",
                args_schema=RecipeToolInput
            )
            llm_with_tools = llm.bind_tools([save_recipe_tool])

            def extract_text(content):
                if isinstance(content, str):
                    return content
                elif isinstance(content, list):
                    parts = []
                    for part in content:
                        if isinstance(part, str):
                            parts.append(part)
                        elif isinstance(part, dict) and "text" in part:
                            parts.append(part["text"])
                    return "".join(parts)
                return str(content) if content is not None else ""

            response_chunks = []
            text_response = ""
            async for chunk in llm_with_tools.astream(self.history):
                response_chunks.append(chunk)
                chunk_text = extract_text(chunk.content)
                if chunk_text:
                    text_response += chunk_text
                    await self.send(text_data=json.dumps({"type": "chunk", "text": chunk_text}))
            
            full_response = response_chunks[0]
            for chunk in response_chunks[1:]:
                full_response += chunk

            self.history.append(full_response)

            if getattr(full_response, "tool_calls", None):
                for tool_call in full_response.tool_calls:
                    await self.send(text_data=json.dumps({"type": "chunk", "text": f"\n\n[System: Saving recipe '{tool_call['args'].get('title')}']\n"}))
                    result = await wrapped_tool(**tool_call["args"])
                    self.history.append(ToolMessage(content=result, tool_call_id=tool_call["id"]))

                async for chunk in llm_with_tools.astream(self.history):
                    chunk_text = extract_text(chunk.content)
                    if chunk_text:
                        text_response += chunk_text
                        await self.send(text_data=json.dumps({"type": "chunk", "text": chunk_text}))
                
                self.history.append(AIMessage(content=text_response))

            if self.conversation:
                await save_message(self.conversation, Message.ROLE_AI, text_response)
                if not self.conversation.title:
                    title_to_set = prompt[:100] if (prompt and prompt != "Audio Message") else "Voice Message Query"
                    await set_conversation_title(self.conversation, title_to_set)

            await self.send(text_data=json.dumps({
                "type": "done",
                "full_text": text_response,
                "conversation_id": self.conversation.id if self.conversation else None
            }))

        except Exception as e:
            error_msg = str(e)
            if "503" in error_msg or "UNAVAILABLE" in error_msg or "high demand" in error_msg.lower():
                friendly_msg = "مساعد الطاهي الذكي مشغول حالياً بسبب كثرة الطلبات على خوادم جوجل. يرجى المحاولة مرة أخرى بعد ثوانٍ قليلة."
            elif "429" in error_msg or "quota" in error_msg.lower():
                friendly_msg = "لقد تجاوزت الحد الأقصى المسموح به للاستخدام اليومي للذكاء الاصطناعي. يرجى المحاولة غداً."
            else:
                friendly_msg = f"حدث خطأ أثناء الاتصال بالذكاء الاصطناعي. يرجى المحاولة لاحقاً."
            await self.send(text_data=json.dumps({"type": "error", "message": friendly_msg}))
