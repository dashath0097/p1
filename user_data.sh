#!/bin/bash
set -eux  # Enable debugging mode

# Install dependencies
sudo apt update && sudo apt install -y curl wget

# Download the Spacelift Launcher
sudo wget -O /usr/local/bin/spacelift-launcher https://downloads.spacelift.io/spacelift-launcher-x86_64
sudo chmod +x /usr/local/bin/spacelift-launcher

# Retrieve worker certificate and set it as SPACELIFT_TOKEN
SPACELIFT_TOKEN=$(cat /root/worker.crt)
export SPACELIFT_TOKEN

# Save the token persistently
echo "export SPACELIFT_TOKEN=${SPACELIFT_TOKEN}" | sudo tee -a /etc/environment

# Register the Spacelift Worker using the token
sudo -E /usr/local/bin/spacelift-launcher register --worker-pool "${WORKER_POOL_ID}"
