#!/bin/bash

git_clone_or_pull () {
    REPOSRC=$1
    LOCALREPO=$2
    [[ $# -eq 1 ]] && echo "git clone or pull failed : No dest dir" >&2 && return
    git clone "$REPOSRC" "$LOCALREPO" >&2  || git -C "$LOCALREPO" pull >&2
}
is_root () {
	return $(id -u)
}

has_sudo() {
	local prompt

	prompt=$(sudo -nv 2>&1)
	if [ $? -eq 0 ]; then
		#echo "has_sudo__pass_set"
		echo 1
	elif echo $prompt | grep -q '^sudo:'; then
		#echo "has_sudo__needs_pass"
		echo 1
	else
		#echo "no_sudo"
		echo 0
	fi
}

is_pkg_installed() {
    while [ -n "$1" ]; do
        if [ $(dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
            echo 0
            return
        fi
        shift
    done
    echo 1
}

is_pkg_installed_old() {
	if [ $(dpkg-query -W -f='${Status}' $1 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
		echo 0
		return
	fi
	echo 1
}

chk_and_ins_pkgs() {
	__need_ins=0
	for _pkg in $@; do
		#echo "Check PKG : $_pkg" >&2
		if [ $(is_pkg_installed $_pkg) -eq 0 ]; then
			__need_ins=1
		fi
	done
	if [ $__need_ins -eq 1 ]; then
		if [ has_sudo ]; then
			echo "Install PKG : $@" >&2
			echo "Need root privilege." >&2
			sudo apt-get install -y $@ >&2
		fi
	fi

	for _pkg in $@; do
		if [ $(is_pkg_installed $_pkg) -eq 0 ]; then
			echo 0
			return
		fi
	done

	echo 1
}


ask() {
  while true; do
    read -p "$1 ([y]/n) " -r
    REPLY=${REPLY:-"y"}
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      return 1
    elif [[ $REPLY =~ ^[Nn]$ ]]; then
      return 0
    fi
  done
}

append_line() {
  set -e

  local update line file pat lno
  update="$1"
  line="$2"
  file="$3"
  pat="${4:-}"
  lno=""

  echo "Update $file:"
  echo "  - $line"
  if [ -f "$file" ]; then
    if [ $# -lt 4 ]; then
      lno=$(\grep -nF "$line" "$file" | sed 's/:.*//' | tr '\n' ' ')
    else
      lno=$(\grep -nF "$pat" "$file" | sed 's/:.*//' | tr '\n' ' ')
    fi
  fi
  if [ -n "$lno" ]; then
    echo "    - Already exists: line #$lno"
  else
    if [ $update -eq 1 ]; then
      [ -f "$file" ] && echo >> "$file"
      echo "$line" >> "$file"
      echo "    + Added"
    else
      echo "    ~ Skipped"
    fi
  fi
  echo
  set +e
}
