#!/bin/bash
set -e
while read line
do
	grep -qxF "$line" "$1" || (echo "$line" >> "$1")
done
