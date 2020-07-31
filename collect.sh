#!/bin/bash
set -e

# target locations
target=$(dirname "$0")/data

# source files
bat=https://github.com/sharkdp/bat/releases/download/v0.15.4/bat-v0.15.4-x86_64-unknown-linux-musl.tar.gz
lsd=https://github.com/Peltoche/lsd/releases/download/0.17.0/lsd-0.17.0-x86_64-unknown-linux-musl.tar.gz
procs=https://github.com/dalance/procs/releases/download/v0.10.3/procs-0.10.3-1.x86_64.rpm
hl=~/bin/linux/hl
vimrc=~/.vim/vimrc
tmuxconf=~/.tmux.conf
key=~/.ssh/id_rsa.pub
microcfg=~/.config/micro
alacrittycfg=~/.config/alacritty
tmux=".tmux.conf .tmux .tmux-themepack"

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
! test -f "${vimrc:?}" || cp "${vimrc:?}" "${target:?}"/etc/vim/
! test -f "${tmuxconf:?}" || cp "${tmuxconf:?}" "${target:?}"/etc/tmux/
! test -d "${microcfg:?}" || cp "${microcfg:?}"/*.json "${target:?}"/etc/micro/
! test -f "${key:?}" || cp "${key:?}" "${target:?}"/keys/current.key
! test -f "${hl:?}" || cp "${hl:?}" "${target:?}"/bin/
! test -d "${alacrittycfg:?}" || cp "${alacrittycfg:?}"/* "${target:?}"/etc/alacritty/
git-clone https://github.com/tmux-plugins/tpm ${target:?}/etc/tmux/.tmux/plugins/tpm
git-clone https://github.com/jimeh/tmux-themepack.git ${target:?}/etc/tmux/.tmux-themepack
tar -C "${target:?}"/etc/tmux -cz -f "${target:?}"/share/tmux.tar.gz ${tmux:?}
wget -N -q -P "${target:?}"/dist/ ${bat:?} ${lsd:?} ${procs:?}
