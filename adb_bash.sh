set -e
shopt -s expand_aliases

which -s wget || alias wget='curl -O --retry 999 --retry-max-time 0 -C -'
[[ `uname -a` == *Darwin* ]] && alias nproc='sysctl -n hw.logicalcpu'

if [[ ! -z "${1}" ]]; then
    export ANDROID_SERIAL="${1}"
    shift
fi

export BASE_URL="http://newandroidbook.com/tools"
JONATHAN_LEVINE_TOOLS="jtrace\0bdsm\0imjtool\0memento\0procexp"
BUILD="$(pwd)/build"
TARGET="/data/local/tmp"

mkdir -p "${BUILD}"
cd "${BUILD}"

printf "${JONATHAN_LEVINE_TOOLS}" | xargs -0 -J{} -P$(nproc) -n 1 bash -c \
    'find build -iname "*jtrace*" 2>/dev/null 1>&2 && exit' \
    '( wget ${BASE_URL}/${1}.tgz || wget ${BASE_URL}/${1}.tar ) ' \
    '&& ( tar -xzf ${1}.tgz 2>/dev/null || tar -xf ${1}.tar )' _ {}

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
adb push "${BUILD}/bash-static" "${TARGET}/bash"
adb push "$(pwd)/bmo.sh" "${TARGET}/bmo.sh"
adb push "$(pwd)/bashrc" "${TARGET}/bashrc"

adb shell -t 'export PATH=${PATH}:/data/local/tmp:/system/bin:/system/xbin:/vendor/bin:; '"${TARGET}/bash --rcfile ${TARGET}/bashrc"
