# syntax=docker/dockerfile:1

FROM python:3.12-alpine

# Install necessary build tools and dependencies for ML libraries
RUN apk update && apk add --no-cache \
    build-base \
    libffi-dev \
    openssl-dev \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install `uv` (fast Python package/dependency manager)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# Create app directory
WORKDIR /app

# Copy project files
COPY . .

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    UV_SYSTEM_PYTHON=true \
    UV_VENV_NAME=.venv

# Create virtual environment and sync dependencies
RUN uv venv .venv --python 3.12 && \
    source .venv/bin/activate && \
    uv sync

# Create default env file if not mounted
RUN [ -f .env ] || cp .env_template .env

# Expose app port
EXPOSE 5000

# Run app
CMD [".venv/bin/python", "app.py"]
