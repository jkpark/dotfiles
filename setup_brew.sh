#!/bin/bash

# Homebrew Installation Script
# https://brew.sh/

# Get the directory of this script
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# determin OS. if it's MacOS or Linux.
OS="$(uname -s)"
case "$OS" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    *)          MACHINE="UNKNOWN:${OS}"
esac
echo "Detected OS: $MACHINE"

if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing..."
    # Official installation command from brew.sh
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    if [[ $MACHINE == 'Linux' ]]; then
        # Add Homebrew to your PATH and to your bash shell rcfile, either ~/.bashrc for bash.
        test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
        test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc
    elif [[ "$MACHINE" == "Mac" ]]; then
        echo ""
    fi
fi

# Verification
if command -v brew &> /dev/null; then
    echo "Homebrew is correctly configured in PATH."
    brew --version
else
    echo "Homebrew installation failed or 'brew' is still not in PATH."
fi
