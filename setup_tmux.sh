#!/bin/bash

# Set the TPM directory
TPM_DIR="$HOME/.tmux/plugins/tpm"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install TPM if it's not already installed
if [ ! -d "$TPM_DIR" ]; then
    echo "Installing Tmux Plugin Manager (TPM)..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
    echo "TPM is already installed."
fi

# Install tmux plugins using TPM
if command_exists tmux; then
    echo "Installing Tmux plugins..."
    tmux start-server # Start tmux server if not running
    tmux new-session -d # Create a detached session
    "$TPM_DIR/bin/install_plugins" # Install plugins
    tmux kill-server # Stop the tmux server
    echo "Tmux plugins installed successfully."
else
    echo "Tmux is not installed. Please install tmux first."
fi

