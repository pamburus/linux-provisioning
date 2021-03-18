#!/bin/bash
set -e

# target locations
target=$(dirname "$0")/data

include_configs=false

function usage() {
	echo "$0 [-c|--include-configs]"
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
bat=https://github.com/sharkdp/bat/releases/download/v0.17.1/bat-v0.17.1-x86_64-unknown-linux-musl.tar.gz
lsd=https://github.com/Peltoche/lsd/releases/download/0.19.0/lsd-0.19.0-x86_64-unknown-linux-musl.tar.gz
procs=https://github.com/dalance/procs/releases/download/v0.10.10/procs-v0.10.10-x86_64-lnx.zip
delta=https://github.com/dandavison/delta/releases/download/0.4.5/delta-0.4.5-x86_64-unknown-linux-musl.tar.gz
hl=https://github.com/pamburus/hl/releases/download/v0.8.10/hl-linux.tar.gz
micro=https://github.com/zyedidia/micro/releases/download/v2.0.8/micro-2.0.8-linux64-static.tar.gz
tmux=https://github.com/owent-contrib/tmux-build-musl/releases/download/3.1b/tmux-3.1b.musl-bin.tar.gz
vimrc=~/.vim/vimrc
tmuxconf=~/.tmux.conf
key=~/.ssh/id_rsa.pub
microcfg=~/.config/micro
alacrittycfg=~/.config/alacritty
tmuxcfg=".tmux.conf .tmux"

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
	! test -d "${alacrittycfg:?}" || cp "${alacrittycfg:?}"/* "${target:?}"/etc/alacritty/
fi
git-clone https://git::@github.com/nhdaly/tmux-better-mouse-mode ${target:?}/etc/tmux/.tmux/plugins/tmux-better-mouse-mode
git-clone https://git::@github.com/tmux-plugins/tmux-resurrect ${target:?}/etc/tmux/.tmux/plugins/tmux-resurrect
git-clone https://git::@github.com/tmux-plugins/tmux-sensible ${target:?}/etc/tmux/.tmux/plugins/tmux-sensible
git-clone https://git::@github.com/jimeh/tmux-themepack.git ${target:?}/etc/tmux/.tmux/plugins/tmux-themepack
git-clone https://git::@github.com/tmux-plugins/tpm ${target:?}/etc/tmux/.tmux/plugins/tpm
tar -C "${target:?}"/etc/tmux -cz -f "${target:?}"/share/tmuxcfg.tar.gz ${tmuxcfg:?}
wget -N -q -O "${target:?}"/dist/tmux.tar.gz ${tmux:?}
wget -N -q -O "${target:?}"/dist/bat.tar.gz ${bat:?} 
wget -N -q -O "${target:?}"/dist/lsd.tar.gz ${lsd:?}
wget -N -q -O "${target:?}"/dist/procs.zip ${procs:?}
wget -N -q -O "${target:?}"/dist/delta.tar.gz ${delta:?}
wget -N -q -O "${target:?}"/dist/micro.tar.gz ${micro:?}
wget -N -q -O "${target:?}"/dist/hl.tar.gz ${hl:?}
