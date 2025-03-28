FROM python:3.9.2-slim-buster
RUN apt-get update && apt-get install -y wget \
    && apt-get install -y --no-install-recommends gcc libffi-dev musl-dev ffmpeg aria2 python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# COPY requirements.txt /app/  # Adjust the path as needed
# WORKDIR /app
# RUN pip3 install --no-cache-dir --upgrade pip \
 #   && pip3 install --no-cache-dir --upgrade -r requirements.txt \
    # && python3 -m pip install -U yt-dlp
    # Copy requirements first to leverage Docker layer caching
COPY requirements.txt /app/
WORKDIR /app

# Install dependencies
RUN python3 -m pip install --no-cache-dir --upgrade pip \
    && python3 -m pip install --no-cache-dir --upgrade -r requirements.txt \
    && python3 -m pip install --no-cache-dir --upgrade yt-dlp
CMD gunicorn app:app & python3 main.py
