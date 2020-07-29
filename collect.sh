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
key=~/.ssh/id_rsa.pub
tmux=".tmux.conf .tmux .tmux-themepack"

# actions
mkdir -p "${target:?}"/{etc,share,keys,bin,dist}
tar -C ~ -cz -f "${target:?}"/share/tmux.tar.gz ${tmux:?}
! test -f "${key:?}" || cp "${key:?}" "${target:?}"/keys/current.key
! test -f "${hl:?}" || cp "${hl:?}" "${target:?}"/bin/
wget -N -q -P "${target:?}"/dist/ ${bat:?} ${lsd:?} ${procs:?}
! test -f "${vimrc:?}" || cp "${vimrc:?}" "${target:?}"/etc/
! test -f ~/.tmux.conf || cp ~/.tmux.conf "${target:?}"/etc/
