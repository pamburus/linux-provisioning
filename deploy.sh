#!/bin/bash
set -e

for addr in "$@"; do
	tar -C ~ -cz opt/provisioning | ssh ${addr:?} 'tar -C ~ -xz'
	ssh ${addr:?} '~/opt/provisioning/apply.sh && ~/opt/provisioning/apply.sh'
done
