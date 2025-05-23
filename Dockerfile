FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

# 1. Essentials
RUN apt-get update && apt-get install -y \
    python3-pip git ffmpeg libgl1-mesa-glx && \
    apt-get clean

# 2. Set workdir
WORKDIR /workspace

# 3. Copy code (for serverless, RunPod will clone your repo)
# 4. Install requirements
COPY requirements.txt ./
RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt

# 5. Install optional acceleration
RUN pip3 install flash_attn huggingface_hub

# 6. Download models (optional: could be handled in entrypoint)
# -- Skipping auto-download to keep image light. Handle on first run or in entrypoint.

# 7. Default command (for RunPod serverless)
CMD ["python3", "infer.py", "--image_path", "./assets/images/woman.png", "--audio_path", "./assets/audios/woman.wav"]
