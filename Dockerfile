FROM docker.n8n.io/n8nio/n8n:latest

USER root

# Install Python and dependencies for Alpine
RUN apk add --no-cache python3 py3-pip && \
    python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --no-cache-dir python-docx

# Ensure the virtual environment is in the PATH
ENV PATH="/opt/venv/bin:$PATH"

USER node
