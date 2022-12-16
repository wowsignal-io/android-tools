#!/bin/bash

set -e
shopt -s expand_aliases

THIS=`readlink -f ${BASH_SOURCE}`
CWD=`dirname "${THIS}"`
cd "${CWD}"

which -s wget || alias wget='curl -O --retry 999 --retry-max-time 0 -C -'
[[ `uname -a` == *Darwin* ]] && alias nproc='sysctl -n hw.logicalcpu'

if [[ ! -z "${1}" ]]; then
    export ANDROID_SERIAL="${1}"
    shift
fi

export BASE_URL="http://newandroidbook.com/tools"
JONATHAN_LEVINE_TOOLS="jtrace\0bdsm\0imjtool\0memento\0procexp\0dextra"
export BUILD="$(pwd)/build"
TARGET="/data/local/tmp"

mkdir -p "${BUILD}"
cd "${BUILD}"

__dl_tool() {
    find "${BUILD}" -iname "*${1}*" 2>/dev/null | grep -q . && echo "CACHED ${1}" && return
    echo "DOWNLOAD ${1}"

    ( wget ${BASE_URL}/${1}.tgz || wget ${BASE_URL}/${1}.tar ) || return 1
    tar -xzf ${1}.tgz 2>/dev/null || tar -xf ${1}.tar
}

export -f __dl_tool
printf "${JONATHAN_LEVINE_TOOLS}" | \
    xargs -0 -J{} -P$(nproc) -n 1 bash -c '__dl_tool "${1}"' _ {}

cd ..

if [[ ! -f "${BUILD}/bash-static" || ! -f "${BUILD}/less-static" ]]; then
    docker build -t android_bash_local --platform=aarch64 .
    docker run --rm --platform linux/aarch64 -v "${BUILD}":/target android_bash_local
fi

adb shell "mkdir -p ${TARGET}/bin/"
adb push "${BUILD}/jtrace64" "${TARGET}/bin/"
adb push "${BUILD}/data/local/tmp/bdsm" "${TARGET}/bin/bdsm"
adb push "${BUILD}/imjtool.android.arm64" "${TARGET}/bin/imjtool"
adb push "${BUILD}/memento.arm64.android" "${TARGET}/bin/memento"
adb push "${BUILD}/procexp.armv7" "${TARGET}/bin/procexp"
adb push "${BUILD}/dextra.arm64" "${TARGET}/bin/dextra"
adb push "${BUILD}/bash-static" "${TARGET}/bin/bash"
adb push "${BUILD}/less-static" "${TARGET}/bin/less"
adb push "$(pwd)/bmo.sh" "${TARGET}/bin/bmo.sh"
adb push "$(pwd)/dachshund.sh" "${TARGET}/bin/dachshund.sh"
adb push "$(pwd)/bashrc" "${TARGET}/.bashrc"

while true; do
    sleep 1
    ./pull_outfiles.sh
done &

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

adb shell -t 'export PATH=${PATH}:/data/local/tmp/bin:/system/bin:/system/xbin:/vendor/bin:; '"${TARGET}/bin/bash --rcfile ${TARGET}/.bashrc"

kill %1
