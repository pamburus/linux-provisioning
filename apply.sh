#!/bin/bash
set -e

# source location
source=~/opt/provisioning/data

# actions
sudo yum install -y -q vim tmux
tar -C ~ -x -f ${source:?}/share/tmux.tar.gz
sudo yum install -y -q ${source:?}/dist/*.rpm
sudo tar -C /usr/bin/ -x --strip-components 1 -f ${source:?}/dist/bat-*.tar.gz '*/bat'
sudo tar -C /usr/bin/ -x --strip-components 1 -f ${source:?}/dist/lsd-*.tar.gz '*/lsd'
sudo cp ${source:?}/bin/hl /usr/bin/
echo 'source ~/opt/provisioning/data/scripts/profile.sh' | ${source:?}/scripts/append.sh ~/.bash_profile
for key in $(find ${source:?}/keys -type f); do
	cat ${key:?} | ${source:?}/scripts/append.sh ~/.ssh/authorized_keys
done
mkdir -p ~/.vim && cp ${source:?}/etc/vimrc ~/.vim/vimrc
