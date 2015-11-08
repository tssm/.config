#!/usr/bin/env bash

set -o errexit
set -o nounset

function deployTo {
	if [ -n "${1-}" ]; then
		machine="${1}"

		rsync -ave ssh --delete \
		--files-from=$HOME/.config/deploy/files.txt \
		--exclude=.git/ \
		--dry-run \
		~/.config/ "${machine}":/home/tae/.config/
	else
		echo $"ERROR: Missing destination machine."
	fi
}

deployTo $@
