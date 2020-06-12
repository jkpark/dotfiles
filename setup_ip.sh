#!/bin/bash

fstrpos() {
	[ -f "$2" ] && echo $(\grep -nF "$1" "$2" | sed 's/:.*//' | tr '\n' ' ')
}

setup_ip() {
	read -p "Setup IP Address? (y/n)" yn
	[[ $yn == "y" ]] || return

	while : ; do
		read -p "Enter IP Address : " IP_ADDR
		read -p "Enter Subnet Mask(0~32) [TIP: 255.255.255.0 is 24] : " IP_SUBNET
		read -p "Enter Gateway : " IP_GW
		read -p "Enter primary DNS : " IP_DNS1
		read -p "Enter secondary DNS : " IP_DNS2

		echo "--- Your Information -----"
		echo "IP Address   : $IP_ADDR/$IP_SUBNET"
		echo "Gateway      : $IP_GW"
		echo "Primary DNS  : $IP_DNS1"
		echo "Secondary DNS: $IP_DNS2"
		echo "--------------------------"
		read -p "Is that correct? (y/n) " yn

		[[ $yn != "y" ]] || break
	done

	IF_NAME="$(nmcli -t -f NAME con show --active)"
	echo "network will set to \"$IF_NAME\""

	eval "nmcli con mod \"$IF_NAME\" ipv4.addresses $IP_ADDR/$IP_SUBNET"
	eval "nmcli con mod \"$IF_NAME\" ipv4.gateway $IP_GW"
	eval "nmcli con mod \"$IF_NAME\" ipv4.ignore-auto-dns yes"
	eval "nmcli con mod \"$IF_NAME\" ipv4.dns \"$IP_DNS1,$IP_DNS2\""
	eval "nmcli con mod \"$IF_NAME\" ipv4.method manual"
	eval "nmcli con up \"$IF_NAME\""
}

setup_proxy() {
	PROXY_ADDR=""
	FILE_ETC_ENV="/etc/environment"
	FILE_APT_CONF="/etc/apt/apt.conf.d/80proxy"
	echo ""

	read -p "Enter Proxy (http://ip_addr:port) : " PROXY_ADDR
	read -p "Setup Proxy $PROXY_ADDR? (y/n)" yn
	[[ $yn == "y" ]] || return

	echo "check $FILE_ETC_ENV" >&2
	lno=$(fstrpos "$PROXY_ADDR" "$FILE_ETC_ENV")
	if [ -n "$lno" ]; then
		echo "    - Already exists: line #$lno"
	else
		echo "HTTP_PROXY=$PROXY_ADDR" >> $FILE_ETC_ENV
		echo "HTTPS_PROXY=$PROXY_ADDR" >> $FILE_ETC_ENV
		echo "http_proxy=$PROXY_ADDR" >> $FILE_ETC_ENV
		echo "https_proxy=$PROXY_ADDR" >> $FILE_ETC_ENV
		echo "no_proxy=localhost,127.0.0.1" >> $FILE_ETC_ENV
		echo "    + Added"
	fi

	SU_STR='Defaults env_keep="HTTP_PROXY HTTPS_PROXY http_proxy https_proxy"'
	echo "check $/etc/sudoers" >&2
	lno=$(fstrpos "$SU_STR" "/etc/sudoers")
	if [ -n "$lno" ]; then
		echo "    - Already exists: line #$lno"
	else
		echo "$SU_STR" >> /etc/sudoers
		echo "    + Added"
	fi

	echo "check $FILE_APT_CONF" >&2
	lno=$(fstrpos "$PROXY_ADDR" "$FILE_APT_CONF")
	if [ -n "$lno" ]; then
		echo "    - Already exists: line #$lno"
	else
		[ -e $FILE_APT_CONF ] || touch $FILE_APT_CONF
		echo "Acquire::http::Proxy \"$PROXY_ADDR\";" >> $FILE_APT_CONF
		echo "Acquire::https::Proxy \"$PROXY_ADDR\";" >> $FILE_APT_CONF
		echo "    + Added"
	fi

	FILE_PROXY_CERT_PATH="/usr/share/ca-certificates/extra"
	echo "Copy certification..."
	echo ""
	echo " Not Support yet."
	echo ""
	echo "Copy your certification to $FILE_PROXY_CERT_PATH manually "
	echo "And then,"
	echo "dpkg-reconfigure ca-certificates"
	echo ""
	read -n 1 -s -r -p "OK?"
}

change_apt_repo() {
	read -p "Change apt repo to Kakao's? (y/n)" yn
	[[ $yn == "y" ]] || return
	sed -i -e 's/us.archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
	sed -i -e 's/kr.archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
}

install_required_pkg() {
	echo ""
	echo "apt update and install recommand pkgs"
	echo "this is last job and it may takes a long time..."
	read -n 1 -s -r -p "Press any key to continue"
	apt-get update
	apt-get upgrade -y
	apt-get autoremove -y
	apt-get install -y git vim curl openssh-server exuberant-ctags 
	apt-get install -y snapd
	#snap install lsd --devmode
}


#check_root
[[ $EUID -ne 0 ]] && { echo "This script must be run as root"; exit 1; }

setup_ip
setup_proxy
change_apt_repo
install_required_pkg

echo "------------------------------------"
echo "Should REBOOT for apply environment."
echo "------------------------------------"
