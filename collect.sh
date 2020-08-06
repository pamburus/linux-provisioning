#!/bin/bash
set -e

# target locations
target=$(dirname "$0")/data

include_configs=false

function usage() {
	echo "$0 [--include-configs]"
}

while [ "$1" != "" ]; do
	case $1 in
		-c | --include-configs )
			include_configs=true
			;;
		-h | --help )
			usage
			exit
			;;
        * )
			usage
			exit 1
	esac
	shift
done

# source files
bat=https://github.com/sharkdp/bat/releases/download/v0.15.4/bat-v0.15.4-x86_64-unknown-linux-musl.tar.gz
lsd=https://github.com/Peltoche/lsd/releases/download/0.17.0/lsd-0.17.0-x86_64-unknown-linux-musl.tar.gz
procs=https://github.com/dalance/procs/releases/download/v0.10.3/procs-0.10.3-1.x86_64.rpm
delta=https://github.com/dandavison/delta/releases/download/0.3.0/delta-0.3.0-x86_64-unknown-linux-musl.tar.gz
hl=https://github.com/pamburus/hl/releases/download/v0.4.0/hl-linux.tar.gz
vimrc=~/.vim/vimrc
tmuxconf=~/.tmux.conf
key=~/.ssh/id_rsa.pub
microcfg=~/.config/micro
alacrittycfg=~/.config/alacritty
tmux=".tmux.conf .tmux"

function git-clone() {
	local src="$1"
	local dst="$2"
	if [ -d "${dst}" ]; then
		git -C "${dst}" pull -q
	else
		git clone "${src}" "${dst}"
	fi
}

# actions
mkdir -p "${target:?}"/{etc/micro,share,keys,bin,dist,src}
if [ "${include_configs:?}" == true ]; then
	! test -f "${vimrc:?}" || cp "${vimrc:?}" "${target:?}"/etc/vim/
	! test -f "${tmuxconf:?}" || cp "${tmuxconf:?}" "${target:?}"/etc/tmux/
	! test -d "${microcfg:?}" || cp "${microcfg:?}"/*.json "${target:?}"/etc/micro/
	! test -f "${key:?}" || cp "${key:?}" "${target:?}"/keys/current.key
	! test -f "${hl:?}" || cp "${hl:?}" "${target:?}"/bin/
	! test -d "${alacrittycfg:?}" || cp "${alacrittycfg:?}"/* "${target:?}"/etc/alacritty/
fi
git-clone https://git::@github.com/nhdaly/tmux-better-mouse-mode ${target:?}/etc/tmux/.tmux/plugins/tmux-better-mouse-mode
git-clone https://git::@github.com/tmux-plugins/tmux-resurrect ${target:?}/etc/tmux/.tmux/plugins/tmux-resurrect
git-clone https://git::@github.com/tmux-plugins/tmux-sensible ${target:?}/etc/tmux/.tmux/plugins/tmux-sensible
git-clone https://git::@github.com/jimeh/tmux-themepack.git ${target:?}/etc/tmux/.tmux/plugins/tmux-themepack
git-clone https://git::@github.com/tmux-plugins/tpm ${target:?}/etc/tmux/.tmux/plugins/tpm
tar -C "${target:?}"/etc/tmux -cz -f "${target:?}"/share/tmux.tar.gz ${tmux:?}
wget -N -q -P "${target:?}"/dist/ ${bat:?} ${lsd:?} ${procs:?} ${delta:?} ${hl:?}
