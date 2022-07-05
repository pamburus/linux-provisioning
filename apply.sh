#!/bin/bash
set -ex

function usage() {
	echo "$0 [-x | --install-extra-packages]"
}

install_extra_packages=false
while [ "$1" != "" ]; do
	case $1 in
		-x | --install-extra-packages )
			install_extra_packages=true
			;;
		-h | --help )
			usage
			exit
			;;
		-* )
			usage
			exit 1
			;;
        * )
			usage
			exit 1
	esac
	shift
done

# source location
source=$(readlink -f -- $(dirname $0)/data)
target=~/bin

# copy configs
mkdir -p "${target:?}" ~/.vim ~/.config
cp "${source:?}"/etc/vim/vimrc ~/.vim/vimrc
cp -R "${source:?}"/etc/micro ~/.config/
cp -R "${source:?}"/etc/hl ~/.config/
tar -C ~ -x -f "${source:?}"/share/tmuxcfg.tar.gz

# install needed and useful packages from official repositories
if [ ${install_extra_packages:?} == true ] && [ "$(id -u)" == 0 ]; then
	if [ -f /etc/redhat-release ]; then
		yum -y install epel-release
		yum -y install -q vim htop git
	elif [ -f /etc/lsb-release ]; then
		apt -y install htop git
	fi
fi

# unpack binaries from tarballs
tar -C ~ -x --strip-components 1 -f "${source:?}"/dist/tmux.tar.gz
tar -C "${target:?}" -x --strip-components 1 -f "${source:?}"/dist/bat.tar.gz --wildcards '*/bat'
tar -C "${target:?}" -x --strip-components 1 -f "${source:?}"/dist/fd.tar.gz --wildcards '*/fd'
tar -C "${target:?}" -x --strip-components 1 -f "${source:?}"/dist/lsd.tar.gz --wildcards '*/lsd'
tar -C "${target:?}" -x --strip-components 1 -f "${source:?}"/dist/delta.tar.gz --wildcards '*/delta'
tar -C "${target:?}" -x --strip-components 1 -f "${source:?}"/dist/micro.tar.gz --wildcards '*/micro'
tar -C "${target:?}" -x --strip-components 1 -f "${source:?}"/dist/procs.tar.gz --wildcards '*/procs'
tar -C "${target:?}" -x -f "${source:?}"/dist/hl.tar.gz --wildcards 'hl'

# configure bash profile
if [ -f ~/.bash_profile ]; then
	profile=~/.bash_profile
elif [ -f ~/.profile ]; then
	profile=~/.profile
fi
echo "source ${source:?}/scripts/profile.sh" | "${source:?}/scripts/append.sh" "${profile:?}"
echo "export PATH=${target:?}:\${PATH}" | "${source:?}/scripts/append.sh" "${profile:?}"

# configure ssh
mkdir -p ~/.ssh && chmod 0700 ~/.ssh
for key in $(find "${source:?}"/keys -name '*.key'); do
	cat ${key:?} | "${source:?}"/scripts/append.sh ~/.ssh/authorized_keys
done
chmod 0600 ~/.ssh/authorized_keys
