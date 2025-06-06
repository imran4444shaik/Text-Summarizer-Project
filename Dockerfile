FROM python:3.8-slim-buster

# 1) Install awscli, compiler, and zstd headers in one shot
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
      awscli \
      build-essential \
      libzstd-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 2) Copy only requirements.txt first (leverages layer caching)
COPY requirements.txt /app/

# 3) Upgrade pip and install all Python deps (including pyzstd)
RUN pip install --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt \
 && pip install --no-cache-dir accelerate \
 && pip uninstall -y transformers accelerate \
 && pip install --no-cache-dir transformers accelerate

# 4) Copy the rest of your application code
COPY . /app

# 5) Default command
CMD ["python3", "app.py"]
