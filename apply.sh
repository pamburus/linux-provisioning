#!/bin/bash
set -ex

# source location
source=$(realpath $(dirname $0)/data)
target=/usr/local/sbin

function install {
	sudo yum -q list installed "$@" || sudo yum -q -y install "$@"  
}

# actions
mkdir -p ~/.vim ~/.config
cp "${source:?}"/etc/vim/vimrc ~/.vim/vimrc
cp -r "${source:?}"/etc/micro ~/.config/
tar -C ~ -x -f ${source:?}/share/tmux.tar.gz
install epel-release
install vim tmux htop git
sudo yum install -q -y "${source:?}"/dist/*.rpm || true
sudo tar -C "${target:?}" -x --strip-components 1 -f "${source:?}"/dist/bat.tar.gz '*/bat'
sudo tar -C "${target:?}" -x --strip-components 1 -f "${source:?}"/dist/lsd.tar.gz '*/lsd'
sudo tar -C "${target:?}" -x --strip-components 1 -f "${source:?}"/dist/delta.tar.gz '*/delta'
sudo tar -C "${target:?}" -x --strip-components 1 -f "${source:?}"/dist/micro.tar.gz '*/micro'
sudo tar -C "${target:?}" -x -f "${source:?}"/dist/hl.tar.gz 'hl'
echo "source ${source:?}/scripts/profile.sh" | "${source:?}/scripts/append.sh" ~/.bash_profile
for key in $(ls "${source:?}"/keys/*.key); do
	cat ${key:?} | "${source:?}"/scripts/append.sh ~/.ssh/authorized_keys
done
