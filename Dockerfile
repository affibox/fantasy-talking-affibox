FROM nvidia/cuda:12.1.1-cudnn8-runtime-ubuntu22.04

# 1. Essentials
RUN apt-get update && apt-get install -y \
    python3-pip git ffmpeg libgl1-mesa-glx && \
    apt-get clean

# 2. Set workdir
WORKDIR /workspace

# 3. Copy requirements and install
COPY requirements.txt ./
RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt

# 4. Install huggingface_hub cli
RUN pip3 install huggingface_hub

# 5. Download models from HuggingFace
RUN huggingface-cli download Wan-AI/Wan2.1-I2V-14B-720P --local-dir ./models/Wan2.1-I2V-14B-720P && \
    huggingface-cli download facebook/wav2vec2-base-960h --local-dir ./models/wav2vec2-base-960h && \
    huggingface-cli download acvlab/FantasyTalking fantasytalking_model.ckpt --local-dir ./models

# 6. Default command
CMD ["python3", "infer.py", "--image_path", "./assets/images/woman.png", "--audio_path", "./assets/audios/woman.wav"]
