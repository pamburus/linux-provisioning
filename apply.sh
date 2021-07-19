#!/bin/bash
set -ex

# source location
source=$(realpath $(dirname $0)/data)
target=~/bin

# copy configs
mkdir -p "${target:?}" ~/.vim ~/.config
cp "${source:?}"/etc/vim/vimrc ~/.vim/vimrc
cp -R "${source:?}"/etc/micro ~/.config/
cp -R "${source:?}"/etc/hl ~/.config/
tar -C ~ -x -f "${source:?}"/share/tmuxcfg.tar.gz

# install needed and useful packages from official repositories
if [ -f /etc/redhat-release ]; then
	sudo yum install -y -q vim htop git unzip
fi
if [ -f /etc/lsb-release ]; then
	sudo apt install -y htop git unzip
fi

# unpack binaries from tarballs
tar -C ~ -x --strip-components 1 -f "${source:?}"/dist/tmux.tar.gz
tar -C "${target:?}" -x --strip-components 1 -f "${source:?}"/dist/bat.tar.gz --wildcards '*/bat'
tar -C "${target:?}" -x --strip-components 1 -f "${source:?}"/dist/lsd.tar.gz --wildcards '*/lsd'
tar -C "${target:?}" -x --strip-components 1 -f "${source:?}"/dist/delta.tar.gz --wildcards '*/delta'
tar -C "${target:?}" -x --strip-components 1 -f "${source:?}"/dist/micro.tar.gz --wildcards '*/micro'
unzip -f -d "${target:?}" "${source:?}"/dist/procs.zip
tar -C "${target:?}" -x -f "${source:?}"/dist/hl.tar.gz --wildcards 'hl'

# configure bash profile
if [ -f ~/.bash_profile ]; then
	profile=~/.bash_profile
elif [ -f ~/.profile ]; then
	profile=~/.profile
fi
echo "source ${source:?}/scripts/profile.sh" | "${source:?}/scripts/append.sh" "${profile:?}"

# configure ssh
mkdir -p ~/.ssh && chmod 0700 ~/.ssh
for key in $(find "${source:?}"/keys -name '*.key'); do
	cat ${key:?} | "${source:?}"/scripts/append.sh ~/.ssh/authorized_keys
done
chmod 0600 ~/.ssh/authorized_keys
