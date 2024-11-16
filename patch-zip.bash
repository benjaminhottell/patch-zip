#!/usr/bin/env bash

set -e

_usage() {
	printf 'Usage: patch-zip RESULT PATCHES...\n' >&2
	printf 'Creates a combined zip archive (RESULT) from two or more zip archives (PATCHES).\n' >&2
	printf 'Archives specified later will take precedence over archives specified earlier.\n' >&2
	printf '\n' >&2
	printf 'Examples:\n' >&2
	printf '  patch-zip modded-game.jar game.jar mod1.zip mod2.zip\n' >&2
	printf '  patch-zip game.jar game.jar mod.zip\n' >&2
}

_check_installed() {
	if ! which "$1" > /dev/null 2> /dev/null; then
		printf 'Prerequisite binary not found: %s\n' "$1" >&2
		return 1
	fi
}

_check_file() {
	if [ -f "$1" ]; then return 0; fi
	printf 'Not a file: %s\n' "$1" >&2
	return 1
}


if [ "$#" -lt 2 ]; then
	_usage
	exit 1
fi


_check_installed 'zip'
_check_installed 'unzip'


tempdir="$(mktemp -d)"
tempresult="$(mktemp --suffix=".zip")"
trap 'rm -rf -- "$tempdir" "$tempresult"' EXIT


# We must remember the absolute path to the result as we will cd later
arg_result="$(realpath "$1")"
shift


while [ "$#" -ge 1 ]; do

	arg_patch="$1"
	shift

	printf 'Opening %s ...\n' "$arg_patch" >&2

	unzip -oq -d "$tempdir" "$arg_patch"

done


# Create a minimal, empty zip archive at tempresult
# To get this binary code, do the following:
#   zip dummy.zip <any_file>
#   zip -d dummy.zip <any_file>
#   base64 dummy.zip
printf 'UEsFBgAAAAAAAAAAAAAAAAAAAAAAAA==' | base64 -d > "$tempresult"

printf 'Combining result ...\n' >&2
cd "$tempdir" && zip -rq "$tempresult" .

printf 'Moving result to %s ...\n' "$arg_result" >&2
mv "$tempresult" "$arg_result"

