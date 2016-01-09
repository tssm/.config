#!/usr/bin/env bash

set -o errexit
set -o nounset

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
readonly OWN_DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"

function deployTo {
	if [ -n "${1-}" ]; then
		machine="${1}"

		rsync --archive --verbose --delete --rsh "ssh -p 2222" \
		--files-from="${OWN_DIR}"/files.txt \
		--exclude=.git/ \
		~/.config/ "${machine}":.config/
	else
		echo $"ERROR: Missing destination machine."
	fi
}

deployTo $@
