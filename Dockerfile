# Stage 1: Install Python + python-docx from standard Alpine (which has apk).
# n8n's own Alpine image has apk stripped, so we use a clean Alpine image here.
FROM alpine:3.21 AS python-installer
RUN apk add --no-cache python3 py3-pip
# PEP 668: use --break-system-packages on Alpine 3.21+
RUN pip install --no-cache-dir --break-system-packages python-docx

# Stage 2: Final n8n image — copy Python in, no RUN needed
FROM docker.n8n.io/n8nio/n8n:latest
USER root
# Copy Python binaries and standard library from the installer stage
COPY --from=python-installer /usr/bin/python3 /usr/bin/python3
COPY --from=python-installer /usr/bin/python3.12 /usr/bin/python3.12
COPY --from=python-installer /usr/lib/python3.12 /usr/lib/python3.12
COPY --from=python-installer /usr/lib/libpython3.12.so.1.0 /usr/lib/libpython3.12.so.1.0
USER node
