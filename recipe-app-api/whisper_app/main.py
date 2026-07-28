import os
import shutil
import tempfile
import urllib3
import httpx
from fastapi import FastAPI, UploadFile, File, HTTPException
from faster_whisper import WhisperModel
from huggingface_hub import set_client_factory

# Disable SSL verification warnings
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

# Programmatic SSL override for modern Hugging Face Hub downloads (using httpx)
def my_client_factory():
    return httpx.Client(verify=False)

set_client_factory(my_client_factory)

app = FastAPI(title="Whisper ASR Service")

# Load model configuration from environment
model_size = os.environ.get("ASR_MODEL", "base")

print(f"Loading Whisper model '{model_size}' on CPU with int8 quantization...")
# Load model from the cached directory
model = WhisperModel(
    model_size,
    device="cpu",
    compute_type="int8",
    download_root="/root/.cache/whisper"
)
print("Model loaded successfully!")

@app.post("/asr")
async def transcribe(audio_file: UploadFile = File(...)):
    # Validate file upload
    if not audio_file:
        raise HTTPException(status_code=400, detail="No audio file uploaded.")

    # Create a temporary file with the same extension
    suffix = os.path.splitext(audio_file.filename)[1] or ".m4a"
    with tempfile.NamedTemporaryFile(delete=False, suffix=suffix) as temp_file:
        shutil.copyfileobj(audio_file.file, temp_file)
        temp_path = temp_file.name

    try:
        # Transcribe audio file
        # beam_size=5 is standard for good accuracy
        print(f"[DEBUG] Starting transcription of {temp_path}")
        segments, info = model.transcribe(temp_path, beam_size=5)
        
        # Combine all transcribed segments (evaluate generator first)
        segments_list = list(segments)
        transcribed_text = "".join(segment.text for segment in segments_list)
        
        print(f"[DEBUG] Detected language: '{info.language}' with probability {info.language_probability:.2f}")
        print(f"[DEBUG] Transcribed text: '{transcribed_text.strip()}'")
        
        return {
            "text": transcribed_text.strip(),
            "language": info.language,
            "language_probability": info.language_probability
        }
    except Exception as e:
        print(f"Transcription error: {e}")
        raise HTTPException(status_code=500, detail=f"Transcription failed: {str(e)}")
    finally:
        # Always clean up the temp file
        try:
            os.remove(temp_path)
        except OSError:
            pass

@app.get("/health")
def health():
    return {"status": "ok", "model": model_size}
