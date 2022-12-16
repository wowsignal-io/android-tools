## BASIC DEFINITIONS ##

alias l='ls -lh'
alias la='ls -lha'
BASH_PROFILE=`readlink -f ${BASH_SOURCE}`
export HOME=`dirname "${BASH_PROFILE}"`
export EDITOR=`which vim`
export OUT_DIR="${HOME}/out"

HISTFILE="${HOME}/.bash_history"
HISTSIZE=100000
SAVEHIST=100000

## USEFUL FUNCTIONS ##

# Strip the control characters from stdin. Useful, e.g. to pipe colored output
# into a command not expecting color.
strip_control() {
    # The sed call strips escape characters from the string. The additional perl
    # one-liner deletes the literal ^(B which `tput sgr0` outputs on some
    # systems for unknown reasons. (It's not in the standard, so WTF?)
    sed "s,$(printf '\033')\\[[0-9;]*[a-zA-Z],,g" \
    | sed 's/\033(B//g'
}

# Prints one IPv4 address assigned to this device per line of output.
ip4() {
    ifconfig | grep inet | grep -v 127.0.0.1 | grep -oE '(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})'
}

# Find a file in the current tree that includes a string. (Shorthand for find.)
f() { 
    find . -iname "*${1}*" 2>/dev/null
}

# Usage: out SOURCE [NAME]
#
# Write the file from SOURCE to the output directory, which will be pulled to
# the host machine regularly.
#
# If SOURCE is "-" or not set, then 'out' will cat its stdin.
#
# If NAME is provided, then it will be the basename of the new file.
out() {
    if [[ "${1}" == "-h" || "${1}" == "--help" ]]; then
        echo "Usage: out SOURCE [NAME]"
        echo "Write the file from SOURCE to the output directory, which will be pulled to the host machine regularly."
        echo
        echo "If SOURCE is "-" or not set, then 'out' will cat its stdin."
        echo
        echo "If NAME is provided, then it will be the basename of the new file."
        return 1
    fi
    local dst
    local tmpdst
    tmpdst=`mktemp` || return 1
    mkdir -p "${OUT_DIR}"

    if [[ -z "${2}" ]]; then
        dst=$(mktemp -p "${OUT_DIR}") || return 1
    else
        dst="${OUT_DIR}/${2}"
    fi

    if [[ -z "${1}" || "${1}" == "-" ]]; then
        cat > "${tmpdst}"
    else
        cat "${1}" > "${tmpdst}"
    fi

    mv "${tmpdst}" "${dst}"
    >&2 echo "Written to ${dst}"
}

# Takes a screenshot which will be automatically downloaded to the host machine.
s() {
    screencap -p | out "-" "screenshot_$(date +%Y%m%dT%H%M%S).png"
}

# Computes the hash of a string. Run `h` with no arguments to display usage and
# examples.
h() {
    if [[ "${#}" -eq 0 ]]; then
        echo "Usage: h ALGO STRING"
        echo "Print hash digest of STRING using ALGO"
        echo
        echo "ALGO is one of (md5|NUMBER)"
        echo "NUMBER is understood to be variant of SHA, such as 256, 384 or 512."
        echo
        echo "Example: > h 256 <<< file.txt  # Print sha256 digest of the contents of file.txt"
        echo "Example: > h 256 file.txt  # Print sha256 digest of the string 'file.txt'"
        return 1
    fi
    case "$1" in 
        md5)
            which md5 2> /dev/null > /dev/null;
            if [[ $? -eq 0 ]]; then
                local cmd="md5";
            else
                local cmd="md5sum";
            fi;
            if [[ -z "$2" ]]; then
                "${cmd}";
            else
                "${cmd}" <<< "$2";
            fi
        ;;
        *)
            which shasum 2> /dev/null > /dev/null;
            if [[ $? -eq 0 ]]; then
                if [[ -z "$2" ]]; then
                    shasum -a "$1" | cut -d' ' -f1;
                else
                    shasum -a "$1" <<< "$2" | cut -d' ' -f1;
                fi;
            else
                if [[ -z "$2" ]]; then
                    "sha${1}sum" | cut -d' ' -f1;
                else
                    "sha${1}sum" <<< "$2" | cut -d' ' -f1;
                fi;
            fi
        ;;
    esac
}

## BASH PROMPT FOLLOWS ##

__clr() {
	echo -ne "\033[0m"
}

__host_color() {
	echo -ne "\033[92m"
}

__error_color() {
	echo -ne "\033[31m"
}

__addr_color() {
	echo -ne "\033[33m"
}

__error_info() {
    ret=$?
    case "$ret" in
        "0")
        ;;
        "126")
            echo -n "[EPERM (${ret})] "
        ;;
        "127")
            echo -n "[ENOENT (${ret})] "
        ;;
        "130")
            echo -n "[EINT (${ret})] "
        ;;
        *)
            echo -n "[E (${ret})] "
        ;;
    esac
}

__addr() {
    local ips
    local n
    local first
    local k
    ips="`ip4`" || return 1
    n=`wc -l <<< "$ips"`
    if [[ n -eq 1 ]]; then
        echo "${ips}"
    else
        first=`head -n1 <<< "$ips"`
        k=`bc -l <<< "$n - 1"`
        echo "${first} + $k"
    fi
}

__addr_info() {
    local a
    a=`__addr` || return 1
    echo "<${a}> "
}

PS1="\[$(__clr)\]\$(whoami)@$(__host_color)\h\[$(__clr)\] \$(pwd) "
PS1+="\[$(__error_color)\]\$(__error_info)"
PS1+="\[$(__addr_color)\]\$(__addr_info)"
PS1+="\[$(__clr)\]> "

ascii_art() {
    local x=$((RANDOM % 2))
    case "${x}" in
        0) bmo.sh ;;
        1) dachshund.sh ;;
    esac
}

ascii_art