alias l='ls -lh'
alias la='ls -lha'

HISTFILE=/data/local/tmp/.bash_history
HISTSIZE=100000
SAVEHIST=100000

bash /data/local/tmp/bmo.sh


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

ip4() {
    ifconfig | grep inet | grep -v 127.0.0.1 | grep -oE '(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})'
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

h() {
    if [[ "${#}" == 0 ]]; then
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

PS1="\[$(__clr)\]$(whoami)@$(__host_color)\h\[$(__clr)\] \w "
PS1+="\[$(__error_color)\]\$(__error_info)"
PS1+="\[$(__addr_color)\]\$(__addr_info)"
PS1+="\[$(__clr)\]> "
