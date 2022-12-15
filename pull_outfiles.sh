#!/bin/bash

set -e

export TARGET="$(pwd)/out"
export REMOTE_OUT="/data/local/tmp/out"

mkdir -p "${TARGET}"

__maybe_open() {
    [[ -z "${ANDROID_AUTOPEN_FILES}" ]] && return
    echo -e "\033[32mOPEN \033[34m${1}\n\033[0m"
    open "${TARGET}/${1}"
}

export -f __maybe_open
adb shell find $REMOTE_OUT -mtime -1d -type f 2>/dev/null \
    | xargs basename \
    | xargs -I{} bash -c \
        '[[ -f "${TARGET}/${1}" ]] || ( echo -ne "\n\r\033[42mPULLED\033[0m \033[34m${1}\n\033[0m" && adb pull "${REMOTE_OUT}/${1}" "${TARGET}/${1}" >/dev/null && __maybe_open "${1}" )' _ {}
