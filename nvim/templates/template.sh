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

%HERE%
