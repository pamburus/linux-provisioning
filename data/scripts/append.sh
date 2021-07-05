#!/bin/bash
set -e
while read line
do
	(test -f "$1" && grep -qxF "$line" "$1") || (echo "$line" >> "$1")
done
