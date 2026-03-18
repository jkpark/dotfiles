if status is-interactive
# Commands to run in interactive sessions can go here
end

test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv fish)"

[ -f ~/.aliases ] && source ~/.aliases

function exportf
    cat $argv[1] | string replace -r 'export ' 'set ' | string replace -r '=' ' ' 
end

function sourcef
    cat $argv[1] | string replace -r 'export ' '' | string replace -r '=' ' ' | string replace -r '^' 'set -gx ' $argv[1] | source
end
sourcef ~/.env.sec

starship init fish | source
mise activate fish | source