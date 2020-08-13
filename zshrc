
############################################################################
source ~/.zplug/init.zsh

# theme
zplug "denysdovhan/spaceship-prompt", use:spaceship.zsh, from:github, as:theme

#
zplug "zsh-users/zsh-syntax-highlighting"

#
zplug "zsh-users/zsh-autosuggestions"


# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
zplug load --verbose

############################################################################

export PATH=$HOME/.local/bin:$PATH

[[ "$TERM" == "xterm" ]] && export TERM=xterm-256color

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/.aliases ] && source ~/.aliases

# Insert and Home key
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line

#setopt MENU_COMPLETE

### Fix slowness of pastes with zsh-syntax-highlighting.zsh
# https://gist.github.com/magicdude4eva/2d4748f8ef3e6bf7b1591964c201c1ab
pasteinit() {
    OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
    zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
    zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
### Fix slowness of pastes

