#!/bin/bash
set -eux  # Enable debugging mode

echo "Starting Spacelift Worker setup..."

# Install dependencies
sudo apt update && sudo apt install -y curl wget

# Download the Spacelift Launcher
echo "Downloading Spacelift Launcher..."
sudo wget -O /usr/local/bin/spacelift-launcher https://downloads.spacelift.io/spacelift-launcher-x86_64
sudo chmod +x /usr/local/bin/spacelift-launcher

# Export Spacelift credentials
export SPACELIFT_ACCESS_KEY="${SPACELIFT_ACCESS_KEY}"
export SPACELIFT_SECRET_KEY="${SPACELIFT_SECRET_KEY}"

# Persist the credentials
echo "export SPACELIFT_ACCESS_KEY=${SPACELIFT_ACCESS_KEY}" | sudo tee -a /etc/environment
echo "export SPACELIFT_SECRET_KEY=${SPACELIFT_SECRET_KEY}" | sudo tee -a /etc/environment

# Verify credentials
if [[ -z "$SPACELIFT_ACCESS_KEY" || -z "$SPACELIFT_SECRET_KEY" ]]; then
    echo "Error: Spacelift Access Key or Secret Key is empty! Exiting..."
    exit 1
fi

echo "Spacelift credentials successfully set."

# Register the Spacelift Worker using Access Key and Secret
echo "Registering worker to Spacelift Worker Pool: ${WORKER_POOL_ID}"
sudo -E /usr/local/bin/spacelift-launcher register --worker-pool "${WORKER_POOL_ID}"

echo "Worker registration complete!"
