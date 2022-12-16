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
    ( wget ${BASE_URL}/${1}.tgz || wget ${BASE_URL}/${1}.tar ) || return 1
    tar -xzf ${1}.tgz 2>/dev/null || tar -xf ${1}.tar
}

export -f __dl_tool
printf "${JONATHAN_LEVINE_TOOLS}" | \
    xargs -0 -J{} -P$(nproc) -n 1 bash -c '__dl_tool "${1}"' _ {}

cd ..

if [[ ! -f "${BUILD}/bash-static" ]]; then
    docker build -t android_bash_local --platform=aarch64 .
    docker run --rm --platform linux/aarch64 -v "${BUILD}":/target android_bash_local
fi

adb push "${BUILD}/jtrace64" "${TARGET}/"
adb push "${BUILD}/data/local/tmp/bdsm" "${TARGET}/bdsm"
adb push "${BUILD}/imjtool.android.arm64" "${TARGET}/imjtool"
adb push "${BUILD}/memento.arm64.android" "${TARGET}/memento"
adb push "${BUILD}/procexp.armv7" "${TARGET}/procexp"
adb push "${BUILD}/dextra.arm64" "${TARGET}/dextra"
adb push "${BUILD}/bash-static" "${TARGET}/bash"
adb push "$(pwd)/bmo.sh" "${TARGET}/bmo.sh"
adb push "$(pwd)/dachshund.sh" "${TARGET}/dachshund.sh"
adb push "$(pwd)/bashrc" "${TARGET}/bashrc"

while true; do
    sleep 1
    ./pull_outfiles.sh
done &

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

adb shell -t 'export PATH=${PATH}:/data/local/tmp:/system/bin:/system/xbin:/vendor/bin:; '"${TARGET}/bash --rcfile ${TARGET}/bashrc"

kill %1
