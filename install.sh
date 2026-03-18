#!/usr/bin/env bash
cd "$(dirname "${BASH_SOURCE[0]}")" || exit 1
BASE=$(pwd)

print_status() {
  echo "--------------------"
  echo " $1"
  echo "--------------------"
}

appendStr() {
  local file="$1" str="$2" check="${3:-$2}"
  grep -qF "$check" "$file" 2>/dev/null || {
    [ -f "$file" ] && echo >> "$file"
    echo "$str" >> "$file"
  }
}

source "$BASE/setup_brew.sh"

if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Cannot continue."
    exit 1
fi

# nerd font
if [[ $MACHINE == 'Linux' ]]; then
  echo "Install DroidSansMono nerd font..."
  brew install --cask font-droid-sans-mono-nerd-font
fi

# git
ln -sfv "$BASE/gitconfig" ~/.gitconfig
ln -sfv "$BASE/gitignore_global" ~/.gitignore_global
ln -sfv $BASE/aliases ~/.aliases
ln -sfv $BASE/env.work ~/.env.work
appendStr ~/.bashrc "[ -f ~/.aliases ] && source ~/.aliases"
appendStr ~/.bashrc "[ -f ~/.env.work ] && source ~/.env.work"

BREW_PREFIX=$(brew --prefix)

# check default .zshrc file and manually link zshrc
#brew install zsh
#ln -sfv $BASE/zshrc ~/.zshrc

brew install fish 
brew install fzf
brew install starship
mkdir -p "$HOME/.config/fish"
ln -sfv "$BASE/config.fish" "$HOME/.config/fish/config.fish"
ln -sfv "$BASE/starship.toml" "$HOME/.config/starship.toml"
fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"

# Switch to using brew-installed fish as default shell
if ! fgrep -q "$(which fish)" /etc/shells; then
  echo "$(which fish)" | sudo tee -a /etc/shells;
  chsh -s $(which fish)
fi;


brew install vim;
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ln -sfv $BASE/vimrc ~/.vimrc
vim +PlugInstall +qall

brew install bat
brew install mise
appendStr ~/.bashrc 'eval "$(mise activate bashrc)'
brew install tmux;
ln -sfv $BASE/tmux.conf ~/.tmux.conf
