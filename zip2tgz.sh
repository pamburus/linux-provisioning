#!/bin/bash

set -e

if [[ $# < 2 ]]; then
    echo "usage: [src] [dst]"
    exit 1
fi

src="${1:?}"
dst="${2:?}"

echo "convert ${src:?} to ${dst:?}"

tmp="$(mktemp -d)"
function cleanup() {
    rm -rf ${tmp:?}
}
trap cleanup INT TERM EXIT

unzip -q ${src:?} -d ${tmp:?}
chmod -R +r ${tmp:?}
tar -c -z -f ${dst:?} -C ${tmp:?} .
rm -f ${src:?}
