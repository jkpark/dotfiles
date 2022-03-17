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
    [ -f "$file" ] && echo >> "$file"
    echo "$str" >> "$file"
  fi
  set +e
}


sudo apt -q update
sudo apt install -q -y git vim curl openssh-server exuberant-ctags python



# zsh
print_status "Install zsh..."

sudo apt install -q -y zsh
curl -ksL https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
ln -sfv $BASE/zshrc ~/.zshrc


if [ `echo $SHELL` != $(which zsh) ]; then
  echo "changing login shell to zsh..."
  chsh -s $(which zsh)
fi

ln -sfv $BASE/shrc ~/.shrc
appendStr ~/.bashrc "[ -f ~/.shrc ] && source ~/.shrc"
appendStr ~/.zshrc "[ -f ~/.shrc ] && source ~/.shrc"

ln -sfv $BASE/aliases ~/.aliases
appendStr ~/.bashrc "[ -f ~/.aliases ] && source ~/.aliases"
appendStr ~/.zshrc "[ -f ~/.aliases ] && source ~/.aliases"



# install nodejs for coc.vim
print_status "Install nodejs ..."
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt install -q -y nodejs

# vim
print_status "Install vim ..."
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ln -sfv $BASE/vimrc ~/.vimrc
vim +PlugInstall +qall


# tmux
print_status "Install tmux ..."
sudo apt-get install -y tmux
ln -sfv $BASE/tmux.conf ~/.tmux.conf


# dotfiles
for dotfile in gitconfig; do
  if [ -e ~/."$dotfile" ] && [ ! -L ~/."$dotfile" ]; then
    mv -v ~/."$dotfile" bak/"$dotfile"
    echo "backup : ~/.$dotfile"
  fi
  ln -sfv "$BASE/$dotfile" ~/."$dotfile"
done
