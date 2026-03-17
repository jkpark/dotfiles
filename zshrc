# Basic history configuration
HISTSIZE=1000000000
SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY
setopt autocd
autoload -U compinit; compinit

# brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# instead of zsh-autosuggestions
source <(fzf --zsh)

source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Source aliases
if [ -f "$HOME/.aliases" ]; then
    source "$HOME/.aliases"
fi

# Enable Starship prompt
eval "$(starship init zsh)"

# automatically start tmux when ssh(only ssh)
#if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
#  tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
#fi

# /usr/bin/time -f "%e seconds" zsh -i -c exit
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
