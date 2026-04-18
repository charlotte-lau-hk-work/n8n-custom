FROM docker.n8n.io/n8nio/n8n:latest

USER root

# Install Python and dependencies (n8n uses Debian-based image)
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip python3-venv && \
    python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir python-docx && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Ensure the virtual environment is in the PATH
ENV PATH="/opt/venv/bin:$PATH"

USER node
