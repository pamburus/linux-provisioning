#!/bin/bash
set -e

sudo=true

function usage() {
	echo "$0 [--sudo|-s [-x|--install-extra-packages]]"
}

sudo_options=""
while [ "$1" != "" ]; do
	case $1 in
		-s | --sudo )
			sudo=sudo
			;;
		-x | --install-extra-packages )
			sudo_options="${sudo_options} -x"
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
			break
			;;
	esac
	shift
done


for addr in "$@"; do
	tar -cz . | ssh ${addr:?} \
		'mkdir -p ~/opt/provisioning' \
		' && tar -C ~/opt/provisioning -xz' \
		' && bash ~/opt/provisioning/apply.sh' \
		' && '${sudo}' bash ~/opt/provisioning/apply.sh '${sudo_options}
done
