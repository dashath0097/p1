resource "null_resource" "install_spacelift_cli" {
  provisioner "local-exec" {
    command = <<EOT
      # Define install directory
      INSTALL_DIR="/usr/local/bin"
      if [ ! -w "$INSTALL_DIR" ]; then
        echo "Warning: No write access to /usr/local/bin. Using ~/.local/bin instead."
        INSTALL_DIR="$HOME/.local/bin"
        mkdir -p "$INSTALL_DIR"
        export PATH="$INSTALL_DIR:$PATH"
      fi

      # Ensure Spacelift launcher is installed
      if [ ! -f "$INSTALL_DIR/spacelift-launcher" ]; then
        echo "Downloading Spacelift Launcher..."
        sudo wget -O "$INSTALL_DIR/spacelift-launcher" https://downloads.spacelift.io/spacelift-launcher-x86_64
        sudo chmod +x "$INSTALL_DIR/spacelift-launcher"
      else
        echo "Spacelift Launcher already installed."
      fi
    EOT
  }
}
