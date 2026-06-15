# Basic history configuration
HISTSIZE=1000000000
SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY
setopt autocd
autoload -U compinit; compinit

# # instead of zsh-autosuggestions
# source <(fzf --zsh)
# source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

function gituser() {
    local profile="$1"
    local file=""
    if [[ -n "$profile" ]]; then
        file=~/dotfiles/git_user.$profile
    else
        file=~/dotfiles/git_user
    fi

    if [[ -f "$file" ]]; then
        set -a && source "$file" && set +a
        git config user.name "$GIT_USER_NAME"
        git config user.email "$GIT_USER_EMAIL"
        echo "Git configed: name:$GIT_USER_NAME email:$GIT_USER_EMAIL"
    else
        echo "Error: Git user profile '$file' not found."
        return 1
    fi
}

# Enable Starship prompt
eval "$(starship init zsh)"
eval "$(mise activate zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.aliases ] && source ~/.aliases
[ -f ~/.env.work ] && source ~/.env.work

# automatically start tmux when ssh(only ssh)
#if [[ -n "$PS1" ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_CONNECTION" ]]; then
#  tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
#fi

export PATH="$HOME/.local/bin:$PATH"
