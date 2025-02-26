#!/bin/bash
set -eux

# Define install directory (user-writable)
INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"

# Check if Spacelift CLI is installed
if ! command -v spacelift &>/dev/null; then
  echo "Spacelift CLI not found, installing..."
  
  # Download Spacelift CLI
  curl -Lo "$INSTALL_DIR/spacelift" https://downloads.spacelift.io/spacelift-cli/latest/linux-amd64
  chmod +x "$INSTALL_DIR/spacelift"
  
  echo "Spacelift CLI installed successfully!"
else
  echo "Spacelift CLI is already installed."
fi

# Ensure $INSTALL_DIR is in PATH
export PATH="$INSTALL_DIR:$PATH"
echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$HOME/.bashrc"
echo "Spacelift CLI installation completed."
