import os
from langchain_google_genai import ChatGoogleGenerativeAI

api_key = os.environ.get("GEMINI_API_KEY") or os.environ.get("GOOGLE_API_KEY")
print("API Key exists:", bool(api_key))

models = ["gemini-2.5-flash", "gemini-2.0-flash", "gemini-1.5-flash"]
for model in models:
    try:
        print(f"Testing {model}...")
        llm = ChatGoogleGenerativeAI(model=model, google_api_key=api_key)
        res = llm.invoke("Hello, say 'OK' if you can read this.")
        print(f"Success with {model}: {res.content}")
    except Exception as e:
        print(f"Failed with {model}: {e}")
