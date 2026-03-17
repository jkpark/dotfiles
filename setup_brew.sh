#!/bin/bash

# Homebrew Installation Script
# https://brew.sh/

# Get the directory of this script
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Check if brew is already installed
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing..."
    
    # Official installation command from brew.sh
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to your PATH and to your bash shell rcfile, either ~/.bashrc for bash or ~/.zshrc for zsh.
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc
else
    echo "Homebrew is already installed."
fi

# Verification
if command -v brew &> /dev/null; then
    echo "Homebrew is correctly configured in PATH."
    brew --version
else
    # Try one more time to find it if it was just installed
    if [[ "$(uname -s)" == "Linux" ]] && [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        echo "Homebrew found and configured for current session."
        brew --version
    else
        echo "Homebrew installation failed or 'brew' is still not in PATH."
    fi
fi
