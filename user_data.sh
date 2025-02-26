#!/bin/bash
set -eux  # Enable debugging mode

# Install dependencies
sudo apt update && sudo apt install -y curl wget

# Download the Spacelift Launcher
sudo wget -O /usr/local/bin/spacelift-launcher https://downloads.spacelift.io/spacelift-launcher-x86_64
sudo chmod +x /usr/local/bin/spacelift-launcher

# Export Spacelift credentials
export SPACELIFT_ACCESS_KEY="${SPACELIFT_ACCESS_KEY}"
export SPACELIFT_SECRET_KEY="${SPACELIFT_SECRET_KEY}"
export WORKER_POOL_ID="${WORKER_POOL_ID}"  # This should match ec2.tf

# Persist credentials
echo "export SPACELIFT_ACCESS_KEY=${SPACELIFT_ACCESS_KEY}" | sudo tee -a /etc/environment
echo "export SPACELIFT_SECRET_KEY=${SPACELIFT_SECRET_KEY}" | sudo tee -a /etc/environment
echo "export WORKER_POOL_ID=${WORKER_POOL_ID}" | sudo tee -a /etc/environment

# Verify credentials
if [[ -z "$SPACELIFT_ACCESS_KEY" || -z "$SPACELIFT_SECRET_KEY" || -z "$WORKER_POOL_ID" ]]; then
    echo "Error: Missing Spacelift credentials or Worker Pool ID!"
    exit 1
fi

# Register worker to Spacelift
sudo -E /usr/local/bin/spacelift-launcher register --worker-pool "${WORKER_POOL_ID}"
