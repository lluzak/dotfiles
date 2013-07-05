function fnd() {
  grep --exclude-dir ".svn,.git" -nr "$1" *
}

function dus() {
  du -h | grep -e "\.\/[a-zA-Z0-9_-]*$"
}

HLCOLOR="\x1b[30;43m"
NOCOLOR="\x1b[0m"

function findm {
    local it cl sp;
    [ -d "$1" ] && cl="'$1'" && shift;
    for it in "$@"; do
        cl="${cl} -iname '*${it}*' -or";
        sp="${sp}${it}\\|";
    done;
    cl="${cl%-or}";
    sp="s/\\(${sp%\\|}\\)/${HLCOLOR}\\0${NOCOLOR}/ig";
    eval find ${cl} | sed -e "${sp}";
}
