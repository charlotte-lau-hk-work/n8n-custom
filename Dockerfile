# Stage 1: Install Python + python-docx from standard Alpine (which has apk).
# n8n's own Alpine image has apk stripped, so we use a clean Alpine image here.
FROM alpine:3.21 AS python-installer
RUN apk add --no-cache python3 py3-pip
RUN pip install --no-cache-dir python-docx && \
    # Bundle everything needed to copy into n8n
    mkdir -p /python-bundle/bin /python-bundle/lib && \
    cp -a /usr/bin/python3* /python-bundle/bin/ && \
    cp -a /usr/lib/python3.12 /python-bundle/lib/ && \
    cp -a /usr/lib/libpython3.12.so* /python-bundle/lib/ 2>/dev/null || true

# Stage 2: Final n8n image — copy Python in, no RUN needed
FROM docker.n8n.io/n8nio/n8n:latest
USER root
COPY --from=python-installer /python-bundle/bin/ /usr/bin/
COPY --from=python-installer /python-bundle/lib/ /usr/lib/
ENV PATH="/usr/bin:$PATH"
USER node
