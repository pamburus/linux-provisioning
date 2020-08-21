#!/bin/bash
set -ex

# source location
source=$(realpath $(dirname $0)/data)
target=~/bin

# actions
mkdir -p "${target:?}" ~/.vim ~/.config
cp "${source:?}"/etc/vim/vimrc ~/.vim/vimrc
cp -r "${source:?}"/etc/micro ~/.config/
tar -C ~ -x -f "${source:?}"/share/tmuxcfg.tar.gz
sudo yum install -y -q vim htop git || true
tar -C "${target:?}" -x --strip-components 1 -f "${source:?}"/dist/tmux.tar.gz
tar -C "${target:?}" -x --strip-components 1 -f "${source:?}"/dist/bat.tar.gz '*/bat'
tar -C "${target:?}" -x --strip-components 1 -f "${source:?}"/dist/lsd.tar.gz '*/lsd'
tar -C "${target:?}" -x --strip-components 1 -f "${source:?}"/dist/delta.tar.gz '*/delta'
tar -C "${target:?}" -x --strip-components 1 -f "${source:?}"/dist/micro.tar.gz '*/micro'
unzip -f -d "${target:?}" "${source:?}"/dist/procs.zip
tar -C "${target:?}" -x -f "${source:?}"/dist/hl.tar.gz 'hl'
echo "source ${source:?}/scripts/profile.sh" | "${source:?}/scripts/append.sh" ~/.bash_profile
for key in $(ls "${source:?}"/keys/*.key); do
	cat ${key:?} | "${source:?}"/scripts/append.sh ~/.ssh/authorized_keys
done
