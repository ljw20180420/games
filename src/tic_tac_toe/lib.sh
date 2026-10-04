ttt__initialize() {
    tput civis
    echo -e "\e[?1000h"
    trap '
        echo -e "\e[?1000l"
        tput cnorm
        exit
    ' INT TERM EXIT
}

ttt__choose_side() {
    local player_mark AI_mark
    echo "choose you marker" >&2
    select player_mark in "X" "O"
    do
        if [[ "${player_mark}" == "X" ]]
        then
            AI_mark="O"
            break
        elif [[ "${player_mark}" == "O" ]]
        then
            AI_mark="X"
            break
        fi
    done
    echo "who first?" >&2
    local first
    select first in "player" "AI"
    do
        if [[ "${first}" ]]
        then
            break
        fi
    done
    echo "${player_mark} ${AI_mark} ${first}"
}

ttt__draw_board() {
    clear
    printf "%s|%s|%s\n-+-+-\n%s|%s|%s\n-+-+-\n%s|%s|%s\n" "$@"
}

ttt__check_tic_tac_toe() {
    local board=("$@")
    local lines=("0 1 2" "3 4 5" "6 7 8" "0 3 6" "1 4 7" "2 5 8" "0 4 8" "2 4 6")
    local line
    for line in "${lines[@]}"
    do
        local p1 p2 p3
        read p1 p2 p3 <<<"${line}"
        if [[ "${board[${p1}]}" != " " ]] && [[ "${board[${p1}]}" == "${board[${p2}]}" ]] && [[ "${board[${p1}]}" == "${board[${p3}]}" ]]
        then
            echo "winner is ${board[${p1}]}"
            exit 0
        fi
    done
}

ttt__check_full() {
    for cell in "$@"; do
        if [ "${cell}" == " " ]
        then
            return 0
        fi
    done
    echo "tie"
    exit 0
}

ttt__check_tic_tac() {
    local mark=$1
    shift
    local board=("$@")
    local lines=("0 1 2" "3 4 5" "6 7 8" "0 3 6" "1 4 7" "2 5 8" "0 4 8" "2 4 6")
    local line p1 p2 p3
    for line in "${lines[@]}"
    do
        read p1 p2 p3 <<<"${line}"
        if [[ "${board[${p1}]}" == " " ]] && [[ "${board[${p2}]}" == "${mark}" ]] && [[ "${board[${p3}]}" == "${mark}" ]]
        then
            echo "${p1}"
            return 0
        fi
        if [[ "${board[${p2}]}" == " " ]] && [[ "${board[${p1}]}" == "${mark}" ]] && [[ "${board[${p3}]}" == "${mark}" ]]
        then
            echo "${p2}"
            return 0
        fi
        if [[ "${board[${p3}]}" == " " ]] && [[ "${board[${p1}]}" == "${mark}" ]] && [[ "${board[${p2}]}" == "${mark}" ]]
        then
            echo "${p3}"
            return 0
        fi
    done
    echo "N/A"
}

ttt__random_pos() {
    local board=("$@")

    for pos in {0..8}
    do
        if [[ "${board["${pos}"]}" == " " ]]
        then
            echo "${pos}"
        fi
    done |
    shuf -n 1
}

ttt__AI() {
    local AI_mark=$1
    local player_mark=$2
    local -n _ref_board=$3

    local pos
    pos="$(ttt__check_tic_tac "${AI_mark}" "${_ref_board[@]}")"
    if [[ "${pos}" == "N/A" ]]
    then
        pos="$(ttt__check_tic_tac "${player_mark}" "${_ref_board[@]}")"
    fi
    if [[ "${pos}" == "N/A" ]]
    then
        pos="$(ttt__random_pos "${_ref_board[@]}")"
    fi
    _ref_board["${pos}"]="${AI_mark}"
    ttt__draw_board "${_ref_board[@]}"
    ttt__check_tic_tac_toe "${_ref_board[@]}"
    ttt__check_full "${_ref_board[@]}"
}

ttt__player() {
    local player_mark=$1
    local -n _ref_board=$2

    local input x y row col pos
    while read -sn 1 input
    do
        if [[ "${input}" != $'\e' ]]
        then
            continue
        fi
        read -sn 5 input
        if [[ "$input" =~ "[M " ]]
        then
            x=$(printf '%d' "'${input:3:1}")
            y=$(printf '%d' "'${input:4:1}")
            x=$(( x - 32 ))
            y=$(( y - 32 ))            
            if (( y == 1 ))
            then
                row=0
            elif (( y == 3 ))
            then
                row=1
            elif (( y == 5 ))
            then
                row=2
            fi
            if (( x == 1 ))
            then
                col=0
            elif (( x == 3 ))
            then
                col=1
            elif (( x == 5 ))
            then
                col=2
            fi
            if [[ "${row}" && "${col}" ]]
            then
                pos=$(( row * 3 + col ))
            fi
            
            if [[ "${pos}" ]]
            then
                _ref_board["${pos}"]="${player_mark}"
                ttt__draw_board "${_ref_board[@]}"
                ttt__check_tic_tac_toe "${_ref_board[@]}"
                ttt__check_full "${_ref_board[@]}"
                return 0
            fi
        fi
    done
}

ttt__main() {
    ttt__initialize

    local player_mark AI_mark first
    read player_mark AI_mark first <<<"$(ttt__choose_side)"

    local board=(" " " " " " " " " " " " " " " " " ")
    if [[ "${first}" == "player" ]]
    then
        ttt__draw_board "${board[@]}"
        ttt__player "${player_mark}" "board"
    fi
    while true
    do
        ttt__AI "${AI_mark}" "${player_mark}" "board"
        ttt__player "${player_mark}" "board"
    done
}
