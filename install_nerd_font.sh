#!/bin/bash

# OS Detection
OS="$(uname -s)"

# Define font name and download URL
FONT_NAME="JetBrainsMono"--cask
URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${FONT_NAME}.zip"

if [[ "$OS" == "Darwin" ]]; then
    FONT_DIR="$HOME/Library/Fonts"
else
    FONT_DIR="$HOME/.local/share/fonts"
fi

# Install unzip if not present
if ! command -v unzip &> /dev/null; then
    if command -v apt-get &> /dev/null; then
        echo "Installing unzip..."
        sudo apt-get update
        sudo apt-get install -y unzip
    elif command -v brew &> /dev/null; then
        echo "Installing unzip via Homebrew..."
        brew install unzip
    else
        echo "unzip not found. Please install unzip manually."
        exit 1
    fi
fi

# Create font directory
mkdir -p "$FONT_DIR"

# Download and extract font
echo "Downloading ${FONT_NAME} Nerd Font..."
curl -fLo "/tmp/${FONT_NAME}.zip" "$URL"

echo "Extracting to ${FONT_DIR}..."
unzip -o "/tmp/${FONT_NAME}.zip" -d "$FONT_DIR"

# Clean up
rm "/tmp/${FONT_NAME}.zip"

# Refresh font cache
if [[ "$OS" == "Linux" ]]; then
    if command -v fc-cache &> /dev/null; then
        echo "Updating font cache..."
        fc-cache -fv
    else
        echo "fc-cache not found. You may need to restart your terminal or system to see the new fonts."
    fi
elif [[ "$OS" == "Darwin" ]]; then
    echo "Font installed to ${FONT_DIR}. macOS handles font caching automatically."
fi

echo "${FONT_NAME} Nerd Font installed successfully!"
