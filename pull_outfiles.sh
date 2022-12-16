#!/bin/bash

set -e

sleep "${1}"

export TARGET="$(pwd)/out"
export REMOTE_OUT="/data/local/tmp/out"

mkdir -p "${TARGET}"

__maybe_open() {
    [[ -z "${ANDROID_AUTOPEN_FILES}" ]] && return
    echo -e "\n\r\033[42mOPEN\033[0m \033[34m${1}\n\033[0m"
    open "${TARGET}/${1}" || true
}

__maybe_pull() {
    [[ -f "${TARGET}/${1}" ]] \
    || ( \
        echo -ne "\n\r\033[46mPULLED\033[0m \033[32m${1}\033[0m -> \033[33m${TARGET}/${1}\033[0m\n" \
        && adb pull "${REMOTE_OUT}/${1}" "${TARGET}/${1}" >/dev/null \
        && __maybe_open "${1}" \
    )
}

export -f __maybe_open __maybe_pull
adb shell find $REMOTE_OUT -mtime -1d -type f 2>/dev/null \
    | xargs basename \
    | xargs -I{} bash -c \
        '__maybe_pull "${1}"' _ {}
