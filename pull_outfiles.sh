#!/bin/bash

set -e

export TARGET="$(pwd)/out"
export REMOTE_OUT="/data/local/tmp/out"

mkdir -p "${TARGET}"

adb shell find $REMOTE_OUT -mtime -1d -type f 2>/dev/null \
    | xargs basename \
    | xargs -I{} bash -c \
        '[[ -f "${TARGET}/${1}" ]] || ( echo -ne "\n\033[32mPULL \033[34m${1}\n\033[0m" && adb pull "${REMOTE_OUT}/${1}" "${TARGET}/${1}" >/dev/null )' _ {}
