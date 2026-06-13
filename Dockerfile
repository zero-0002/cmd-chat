# syntax=docker/dockerfile:1
FROM python:3.13-slim

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    HOST=0.0.0.0 \
    PORT=8000

WORKDIR /app

# Install dependencies first so this layer is cached unless requirements change.
# All pinned deps ship manylinux wheels, so no compiler toolchain is needed.
COPY requirements.txt ./
RUN python -m pip install --upgrade pip \
    && pip install -r requirements.txt

# Copy application source.
COPY cmd_chat ./cmd_chat
COPY cmd_chat.py ./
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Run as an unprivileged user.
RUN useradd --create-home --uid 10001 appuser
USER appuser

# Server listens on $PORT (default 8000).
EXPOSE 8000

# No password is baked into the image. PASSWORD must be supplied at run time:
#   docker run -e PASSWORD=secret -p 8000:8000 ghcr.io/diorwave/cmd-chat:latest
ENTRYPOINT ["docker-entrypoint.sh"]
