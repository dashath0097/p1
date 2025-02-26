#!/bin/bash
set -eux

# Check if Spacelift CLI is installed
if ! command -v spacelift &>/dev/null; then
  echo "Spacelift CLI not found, installing..."
  
  # Download Spacelift CLI
  curl -Lo spacelift https://downloads.spacelift.io/spacelift-cli/latest/linux-amd64
  
  # Move it to /usr/local/bin (Assumes script runs as a user with write permissions)
  mv spacelift /usr/local/bin/spacelift
  chmod +x /usr/local/bin/spacelift
  
  echo "Spacelift CLI installed successfully!"
else
  echo "Spacelift CLI is already installed."
fi
