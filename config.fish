if status is-interactive
# Commands to run in interactive sessions can go here
end


#
# functions
#

function envsource
  test -f "$argv" || return 1
  for line in (grep -v '^#\|^$' "$argv")
    set -l item (string split -m 1 '=' $line)
    set -gx $item[1] $item[2]
  end
end

function gituser
    set -l file ~/dotfiles/git_user(test -n "$argv[1]" && echo .$argv[1])
    test -f "$file" || { echo "Error: Git user profile '$file' not found."; return 1 }
    envsource "$file"
    git config user.name "$GIT_USER_NAME"
    git config user.email "$GIT_USER_EMAIL"
    echo "Git configed: name:$GIT_USER_NAME email:$GIT_USER_EMAIL"
end

test -f ~/.aliases && source ~/.aliases
test -f ~/.env && envsource ~/.env
test -f ~/.env.work && envsource ~/.env.work

test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv fish)"

starship init fish | source
mise activate fish | source

