############################################################################
source ~/.zplug/init.zsh

# theme
zplug "denysdovhan/spaceship-prompt", use:spaceship.zsh, from:github, as:theme

#
zplug "zsh-users/zsh-syntax-highlighting"

#
zplug "zsh-users/zsh-autosuggestions"

# directory listing more readable
zplug "supercrabtree/k"

zplug "agkozak/zsh-z"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo
        zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load

############################################################################

setopt AUTOCD
HISTFILE="${HOME}/.zsh_history"
SAVEHIST=5000
HISTSIZE=5000
setopt append_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt inc_append_history
setopt share_history

[ -f ~/.shrc ] && source ~/.shrc
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# automatically start tmux when ssh(only ssh)
#if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
#  tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
#fi

# for use GPG sign
export GPG_TTY=$(tty)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
