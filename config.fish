if status is-interactive
# Commands to run in interactive sessions can go here
end


#
# functions
#

function envsource
  set -f envfile "$argv"
  if not test -f "$envfile"
    echo "Unable to load $envfile"
    return 1
  end
  while read line
    if not string match -qr '^#|^$' "$line"
      set item (string split -m 1 '=' $line)
      set -gx $item[1] $item[2]
      if test -n "\$$item[2]"
        set -gx $item[1] $item[2]
      end
    end
  end < "$envfile"
end

function gituser
    set -l profile $argv[1]
    set -l file ""
    if test -n "$profile"
        set file ~/dotfiles/git_user.$profile
    else
        set file ~/dotfiles/git_user
    end

    if test -f "$file"
        envsource "$file"
        git config user.name "$GIT_USER_NAME"
        git config user.email "$GIT_USER_EMAIL"
        echo "Git configed: name:$GIT_USER_NAME email:$GIT_USER_EMAIL"
    else
        echo "Error: Git user profile '$file' not found."
        return 1
    end
end

test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv fish)"

[ -f ~/.aliases ] && source ~/.aliases

# test -f ~/.env && envsource ~/.env
test -f ~/.env.work && envsource ~/.env.work

starship init fish | source
mise activate fish | source
