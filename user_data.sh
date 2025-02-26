#!/bin/bash
set -eux  # Enable debugging mode

# Update and install dependencies
sudo apt update && sudo apt install -y curl wget

# Define variables
SPACELIFT_WORKER_POOL_ID="${SPACELIFT_WORKER_POOL_ID}"
WORKER_CERT_PATH="/etc/spacelift/worker.crt"
WORKER_KEY_PATH="/etc/spacelift/worker.key"

# Ensure required values are set
if [[ -z "$SPACELIFT_WORKER_POOL_ID" ]]; then
  echo "Error: Worker Pool ID is missing!"
  exit 1
fi

# Ensure Spacelift Launcher is installed
if [ ! -f "/usr/local/bin/spacelift-launcher" ]; then
  echo "Installing Spacelift CLI..."
  wget -O "/usr/local/bin/spacelift-launcher" https://downloads.spacelift.io/spacelift-launcher-x86_64
  chmod +x "/usr/local/bin/spacelift-launcher"
fi

# Store the certificate and private key
mkdir -p /etc/spacelift
echo "${SPACELIFT_WORKER_POOL_CERT}" > "$WORKER_CERT_PATH"
echo "${SPACELIFT_WORKER_POOL_KEY}" > "$WORKER_KEY_PATH"
chmod 600 "$WORKER_CERT_PATH" "$WORKER_KEY_PATH"

# Register the Spacelift Worker using the CSR-based authentication
/usr/local/bin/spacelift-launcher register \
  --worker-pool "$SPACELIFT_WORKER_POOL_ID" \
  --certificate "$WORKER_CERT_PATH" \
  --private-key "$WORKER_KEY_PATH"
