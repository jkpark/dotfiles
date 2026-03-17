#!/bin/bash
cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1
BASE=$(pwd)

print_status() {
  echo "--------------------"
  echo " $1"
  echo "--------------------"
}

appendStr() {
  set -e
  local str file check lno
  file="$1"
  str="$2"
  check="$3"

  if [ -f "$file" ]; then
    if [ -n $check ]; then
      check="$str"
    fi
    lno=$(\grep -nF "$check" "$file" | sed 's/:.*//' | tr '\n' ' ')
  fi

  if [ ! -n "$lno" ]; then
    [ -f "$file" ] && echo >>"$file"
    echo "$str" >>"$file"
  fi
  set +e
}

# determin OS. if it's MacOS or Linux.
OS="$(uname -s)"
case "$OS" in
    Linux*)     MACHINE=Linux;;
    Darwin*)    MACHINE=Mac;;
    *)          MACHINE="UNKNOWN:${OS}"
esac
echo "Detected OS: $MACHINE"

if [[ $MACHINE == 'Linux' ]]; then
  sudo apt update
  sudo apt-get install -y unzip build-essential procps curl file git

  # Install Homebrew on Linux
  bash "$BASE/setup_brew.sh"
elif [[ "$MACHINE" == "Mac" ]]; then
    brew install curl git
fi

if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Cannot continue."
    exit 1
fi

# git
ln -sfv "$BASE/gitconfig" ~/.gitconfig
ln -sfv "$BASE/gitignore_global" ~/.gitignore_global
ln -sfv $BASE/aliases ~/.aliases
appendStr ~/.bashrc "[ -f ~/.aliases ] && source ~/.aliases"


print_status "zsh, fzf, starship..."
brew install zsh fzf starship
ln -sfv $BASE/zshrc ~/.zshrc
mkdir -p "$HOME/.config"
ln -sfv "$BASE/starship.toml" "$HOME/.config/starship.toml"

# change shell
# On some systems, chsh needs the path to be in /etc/shells
if ! grep -q "$ZSH_PATH" /etc/shells; then
    echo "Adding $ZSH_PATH to /etc/shells..."
    echo "$ZSH_PATH" | sudo tee -a /etc/shells
fi
if [ $(echo $SHELL) != $(which zsh) ]; then
    echo "changing login shell to zsh..."
    sudo chsh -s "$ZSH_PATH" "$USER"
fi

# vim
print_status "vim..."
brew install vim;
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ln -sfv $BASE/vimrc ~/.vimrc
vim +PlugInstall +qall

# tmux
print_status "tmux ..."
brew install tmux;
ln -sfv $BASE/tmux.conf ~/.tmux.conf


# nerd font
if [[ $MACHINE == 'Linux' ]]; then
  echo "Install DroidSansMono nerd font..."
  brew install --cask font-droid-sans-mono-nerd-font
fi

# bat
brew install bat

