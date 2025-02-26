#!/bin/bash
set -eux

# Check if Spacelift CLI is installed
if ! command -v spacelift &>/dev/null; then
  echo "Spacelift CLI not found, installing..."
  
  # Download Spacelift CLI
  curl -Lo spacelift https://downloads.spacelift.io/spacelift-cli/latest/linux-amd64
  
  # Move to /usr/local/bin with sudo
  sudo mv spacelift /usr/local/bin/spacelift
  sudo chmod +x /usr/local/bin/spacelift
  
  echo "Spacelift CLI installed successfully!"
else
  echo "Spacelift CLI is already installed."
fi
