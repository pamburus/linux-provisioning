#!/bin/bash
set -e

# source location
source=$(realpath $(dirname $0)/data)
target=/usr/local/sbin

# actions
mkdir -p ~/.vim ~/.config
cp ${source:?}/etc/vim/vimrc ~/.vim/vimrc
cp -r ${source:?}/etc/micro ~/.config/
tar -C ~ -x -f ${source:?}/share/tmux.tar.gz
sudo yum install -y -q epel-release
sudo yum install -y -q vim tmux micro htop git
sudo yum install -y -q ${source:?}/dist/*.rpm
sudo tar -C ${target:?} -x --strip-components 1 -f ${source:?}/dist/bat-*.tar.gz '*/bat'
sudo tar -C ${target:?} -x --strip-components 1 -f ${source:?}/dist/lsd-*.tar.gz '*/lsd'
sudo tar -C ${target:?} -x --strip-components 1 -f ${source:?}/dist/delta-*.tar.gz '*/delta'
sudo tar -C ${target:?} -x -f ${source:?}/dist/hl-*.tar.gz 'hl'
echo "source ${source:?}/scripts/profile.sh" | "${source:?}/scripts/append.sh" ~/.bash_profile
for key in $(find ${source:?}/keys -type f); do
	cat ${key:?} | ${source:?}/scripts/append.sh ~/.ssh/authorized_keys
done
