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
fd=https://github.com/sharkdp/fd/releases/download/v9.0.0/fd-v9.0.0-x86_64-unknown-linux-musl.tar.gz
lsd=https://github.com/Peltoche/lsd/releases/download/v1.0.0/lsd-v1.0.0-x86_64-unknown-linux-musl.tar.gz
procs=https://github.com/dalance/procs/releases/download/v0.14.3/procs-v0.14.3-x86_64-linux.zip
delta=https://github.com/dandavison/delta/releases/download/0.17.0/delta-0.17.0-x86_64-unknown-linux-musl.tar.gz
hl=https://github.com/pamburus/hl/releases/download/v0.29.4/hl-linux-x86_64-musl.tar.gz
micro=https://github.com/zyedidia/micro/releases/download/v2.0.13/micro-2.0.13-linux64-static.tar.gz
tmux=https://github.com/owent-contrib/tmux-build-musl/releases/download/3.1b/tmux-3.1b.musl-bin.tar.gz
gojq=https://github.com/itchyny/gojq/releases/download/v0.12.13/gojq_v0.12.13_linux_amd64.tar.gz
rg=https://github.com/BurntSushi/ripgrep/releases/download/14.1.0/ripgrep-14.1.0-x86_64-unknown-linux-musl.tar.gz
atuin=https://github.com/atuinsh/atuin/releases/download/v18.2.0/atuin-v18.2.0-x86_64-unknown-linux-musl.tar.gz
vimrc=~/.vim/vimrc
tmuxconf=~/.tmux.conf
key=~/.ssh/id_rsa
microcfg=~/.config/micro
hlcfg=~/.config/hl
atuincfg=~/.config/atuin
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
	! test -d "${atuincfg:?}" || cp -RL "${atuincfg:?}"/* "${target:?}"/etc/atuin/
fi
! test -f "${key:?}" || ssh-keygen -y -f "${key:?}" > "${target:?}"/keys/current.key
git-clone https://git::@github.com/nhdaly/tmux-better-mouse-mode ${target:?}/etc/tmux/.tmux/plugins/tmux-better-mouse-mode
git-clone https://git::@github.com/tmux-plugins/tmux-resurrect ${target:?}/etc/tmux/.tmux/plugins/tmux-resurrect
git-clone https://git::@github.com/tmux-plugins/tmux-sensible ${target:?}/etc/tmux/.tmux/plugins/tmux-sensible
git-clone https://git::@github.com/jimeh/tmux-themepack.git ${target:?}/etc/tmux/.tmux/plugins/tmux-themepack
git-clone https://git::@github.com/tmux-plugins/tpm ${target:?}/etc/tmux/.tmux/plugins/tpm
curl -sSfL https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o ${target:?}/etc/.bash-preexec.sh
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
download "${atuin:?}" "${target:?}"/dist/atuin.tar.gz
${SHELL} ${source:?}/zip2tgz.sh "${target:?}"/dist/procs.zip "${target:?}"/dist/procs.tar.gz
