#!/bin/bash
set -e

# target locations
source=$(dirname "$0")
target=$(dirname "$0")/data

include_configs=false
key=~/.ssh/id_rsa

function usage() {
	echo "$0 [-c|--include-configs] [-k {ssh-key-file}]"
}

while [ "$1" != "" ]; do
	case $1 in
		-c | --include-configs )
			include_configs=true
			;;
		-k | --key )
			key="$1"
			shift
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
bat=https://github.com/sharkdp/bat/releases/download/v0.24.0/bat-v0.24.0-x86_64-unknown-linux-musl.tar.gz
fd=https://github.com/sharkdp/fd/releases/download/v8.7.1/fd-v8.7.1-x86_64-unknown-linux-musl.tar.gz
lsd=https://github.com/Peltoche/lsd/releases/download/v1.0.0/lsd-v1.0.0-x86_64-unknown-linux-musl.tar.gz
procs=https://github.com/dalance/procs/releases/download/v0.14.3/procs-v0.14.3-x86_64-linux.zip
delta=https://github.com/dandavison/delta/releases/download/0.16.5/delta-0.16.5-x86_64-unknown-linux-musl.tar.gz
hl=https://github.com/pamburus/hl/releases/download/v0.23.0/hl-linux-x86_64-musl.tar.gz
micro=https://github.com/zyedidia/micro/releases/download/v2.0.13/micro-2.0.13-linux64-static.tar.gz
tmux=https://github.com/owent-contrib/tmux-build-musl/releases/download/3.2a/tmux-3.2a.musl-bin.tar.gz
gojq=https://github.com/itchyny/gojq/releases/download/v0.12.13/gojq_v0.12.13_linux_amd64.tar.gz
rg=https://github.com/BurntSushi/ripgrep/releases/download/14.0.3/ripgrep-14.0.3-x86_64-unknown-linux-musl.tar.gz
vimrc=~/.vim/vimrc
tmuxconf=~/.tmux.conf
key=~/.ssh/id_rsa
microcfg=~/.config/micro
hlcfg=~/.config/hl
alacrittycfg=~/.config/alacritty
tmuxcfg=".tmux.conf .tmux"

function git-clone() {
	local src="$1"
	local dst="$2"
	echo git clone "${src:?}"
	if [ -d "${dst}" ]; then
		git -C "${dst}" pull -q
	else
		git clone "${src}" "${dst}"
	fi
}

function download() {
	local src="$1"
	local dst="$2"
	echo download "${src:?}"
	curl -sSfLR -o "${dst:?}" "${src:?}"
}

# actions
mkdir -p "${target:?}"/{etc/{micro,hl},share,keys,bin,dist,src}
if [ "${include_configs:?}" == true ]; then
	! test -f "${vimrc:?}" || cp -L "${vimrc:?}" "${target:?}"/etc/vim/
	! test -f "${tmuxconf:?}" || cp -L "${tmuxconf:?}" "${target:?}"/etc/tmux/
	! test -d "${microcfg:?}" || cp -L "${microcfg:?}"/*.json "${target:?}"/etc/micro/
	! test -d "${hlcfg:?}" || cp -RL "${hlcfg:?}"/* "${target:?}"/etc/hl/
	! test -d "${alacrittycfg:?}" || cp -L "${alacrittycfg:?}"/* "${target:?}"/etc/alacritty/
fi
! test -f "${key:?}" || ssh-keygen -y -f "${key:?}" > "${target:?}"/keys/current.key
git-clone https://git::@github.com/nhdaly/tmux-better-mouse-mode ${target:?}/etc/tmux/.tmux/plugins/tmux-better-mouse-mode
git-clone https://git::@github.com/tmux-plugins/tmux-resurrect ${target:?}/etc/tmux/.tmux/plugins/tmux-resurrect
git-clone https://git::@github.com/tmux-plugins/tmux-sensible ${target:?}/etc/tmux/.tmux/plugins/tmux-sensible
git-clone https://git::@github.com/jimeh/tmux-themepack.git ${target:?}/etc/tmux/.tmux/plugins/tmux-themepack
git-clone https://git::@github.com/tmux-plugins/tpm ${target:?}/etc/tmux/.tmux/plugins/tpm
tar -C "${target:?}"/etc/tmux -cz -f "${target:?}"/share/tmuxcfg.tar.gz ${tmuxcfg:?}
download "${tmux:?}" "${target:?}"/dist/tmux.tar.gz
download "${bat:?}" "${target:?}"/dist/bat.tar.gz
download "${fd:?}" "${target:?}"/dist/fd.tar.gz
download "${lsd:?}" "${target:?}"/dist/lsd.tar.gz
download "${procs:?}" "${target:?}"/dist/procs.zip
download "${delta:?}" "${target:?}"/dist/delta.tar.gz
download "${micro:?}" "${target:?}"/dist/micro.tar.gz
download "${hl:?}" "${target:?}"/dist/hl.tar.gz
download "${gojq:?}" "${target:?}"/dist/gojq.tar.gz
download "${rg:?}" "${target:?}"/dist/rg.tar.gz
${SHELL} ${source:?}/zip2tgz.sh "${target:?}"/dist/procs.zip "${target:?}"/dist/procs.tar.gz
