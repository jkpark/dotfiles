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

install_brew() {
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Installing..."
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        [[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
        [[ -d /home/linuxbrew/.linuxbrew ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    if command -v brew &> /dev/null; then
        echo "Homebrew is correctly configured in PATH."
        brew --version
    else
        echo "Homebrew installation failed or 'brew' is still not in PATH."
        exit 1
    fi
}

install_brew

ln -sfv "$BASE/gitconfig" ~/.gitconfig
ln -sfv "$BASE/gitignore_global" ~/.gitignore_global
ln -sfv $BASE/aliases ~/.aliases
ln -sfv $BASE/env.work ~/.env.work
appendStr ~/.bashrc "[ -f ~/.aliases ] && source ~/.aliases"
appendStr ~/.bashrc "[ -f ~/.env.work ] && source ~/.env.work"

BREW_PREFIX=$(brew --prefix)

# check default .zshrc file and manually link zshrc
#brew install zsh
ln -sfv $BASE/zshrc ~/.zshrc
ln -sfv $BASE/zprofile ~/.zprofile


# # nerd font
# if [[ $MACHINE == 'Linux' ]]; then
#   echo "Install DroidSansMono nerd font..."
#   brew install --cask font-droid-sans-mono-nerd-font
# fi

brew install fzf
brew install starship
brew install mise

# brew install fish 
# mkdir -p "$HOME/.config/fish"
# ln -sfv "$BASE/config.fish" "$HOME/.config/fish/config.fish"
# ln -sfv "$BASE/starship.toml" "$HOME/.config/starship.toml"
# fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"

# # Switch to using brew-installed fish as default shell
# if ! fgrep -q "$(which fish)" /etc/shells; then
#   echo "$(which fish)" | sudo tee -a /etc/shells;
#   chsh -s $(which fish)
# fi;

brew install vim;
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
ln -sfv $BASE/vimrc ~/.vimrc
# vim +PlugInstall +qall

brew install lsd
brew install bat
# brew install tmux;
# ln -sfv $BASE/tmux.conf ~/.tmux.conf
brew install lazygit
