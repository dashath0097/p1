#!/bin/bash
set -eux

# Install dependencies
apt update -y && apt install -y docker.io
systemctl enable --now docker

# Create Spacelift worker cert & key files
echo "${SPACELIFT_WORKER_POOL_CERT}" > /root/worker.crt
echo "${SPACELIFT_WORKER_POOL_KEY}" > /root/worker.key

# Download Spacelift Worker Launcher
curl -Lo /usr/local/bin/spacelift-launcher https://downloads.spacelift.io/spacelift-launcher-x86_64
chmod +x /usr/local/bin/spacelift-launcher

# Register worker with Spacelift
/usr/local/bin/spacelift-launcher register --worker-pool ${SPACELIFT_WORKER_POOL_ID} \
  --cert /root/worker.crt \
  --key /root/worker.key
