#!/bin/bash
set -e

sudo=''

function usage() {
	echo "$0 [--su|-s]"
}

while [ "$1" != "" ]; do
	case $1 in
		-s | --sudo )
			sudo=sudo
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
	ssh ${addr:?} mkdir -p '~/opt/provisioning'
	tar -cz . | ssh ${addr:?} tar -C '~/opt/provisioning' -xz
	ssh ${addr:?} ${sudo} bash '~/opt/provisioning/apply.sh'
done
