#!/bin/bash
set -eux

# Check if Spacelift CLI is installed
if ! command -v spacelift &>/dev/null; then
  echo "Spacelift CLI not found, installing..."
  
  # Download and install Spacelift CLI
  curl -Lo /usr/local/bin/spacelift-launcher https://downloads.spacelift.io/spacelift-launcher-x86_64
  chmod +x /usr/local/bin/spacelift-launcher
  
  echo "Spacelift CLI installed successfully!"
else
  echo "Spacelift CLI is already installed."
fi
