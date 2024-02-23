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

unameOut="$(uname -s)"
case "${unameOut}" in
Darwin*)
  machine=Mac
  PKGMGR=brew
  ;;
*)
  machine=Linux
  PKGMGR=snap
  ;;
esac
echo "Your system is ${machine}, Selected package manager is ${PKGMGR}"

if [[ $machine == 'Linux' ]]; then
  sudo apt update
  sudo apt install -q -y vim openssh-server exuberant-ctags curl git
fi

# git
ln -sfv "$BASE/gitconfig" ~/.gitconfig
ln -sfv "$BASE/gitignore_global" ~/.gitignore_global

print_status "Copy aliases..."
ln -sfv $BASE/aliases ~/.aliases

print_status "Copy shrc..."
ln -sfv $BASE/shrc ~/.shrc
appendStr ~/.bashrc "[ -f ~/.shrc ] && source ~/.shrc"
appendStr ~/.zshrc "[ -f ~/.shrc ] && source ~/.shrc"

# zsh
print_status "Copy zshrc..."
ln -sfv $BASE/zshrc ~/.zshrc

if [[ $machine == 'Linux' ]]; then
  print_status "Install zsh..."
  sudo apt install -q -y zsh
fi
curl -ksL https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

if [ $(echo $SHELL) != $(which zsh) ]; then
  echo "changing login shell to zsh..."
  chsh -s $(which zsh)
fi

# vim
print_status "vimrc and vim plugins..."
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ln -sfv $BASE/vimrc ~/.vimrc
vim +PlugInstall +qall

# tmux
print_status "Install tmux ..."
if [[ $machine == 'Linux' ]]; then
  sudo apt install tmux
elif [[ $machine == 'Mac' ]]; then
  brew install tmux
fi
ln -sfv $BASE/tmux.conf ~/.tmux.conf


# nerd font
if [[ $machine == 'Linux' ]]; then
  echo "Install DroidSansMono nerd font..."
  wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/DroidSansMono.zip
  unzip DroidSansMono.zip -d ~/.local/share/fonts
  rm DroidSansMono.zip
  fc-cache -f
fi

# bat
if [[ $machine == 'Linux' ]]; then
  sudo apt install bat
  mkdir -p ~/.local/bin
  ln -s /usr/bin/batcat ~/.local/bin/bat
elif [[ $machine == 'Mac' ]]; then
  brew install bat
fi

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
