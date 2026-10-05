# ▀ █ ▄

tileup__color() {
    local color=$1
    local ground=$2

    if [[ "${color}" == "reset" ]]
    then
        tput sgr0
        return 0
    fi

    if [[ "${ground}" == "fg" ]]
    then
        local setax="setaf"
    else
        local setax="setab"
    fi

    case ${color} in
        "black") tput "${setax}" 0 ;;
        "red") tput "${setax}" 1 ;; 
        "green") tput "${setax}" 2 ;;
        "yellow") tput "${setax}" 3 ;;
        "blue") tput "${setax}" 4 ;;
        "magenta") tput "${setax}" 5 ;;
        "cyan") tput "${setax}" 6 ;;
        "white") tput "${setax}" 7 ;;
    esac
}

tileup__block() {
    local up=$1
    local down=$2

    printf "%s%s%s%s" \
        "$(tileup__color "${up}" "fg")" \
        "$(tileup__color "${down}" "bg")" \
        "▀" \
        "$(tileup__color "reset")"
}

tileup__3Didx_to_1Didx() {
    local x=$1
    local y=$2
    local z=$3
    local X=$4
    local Y=$5

    echo $(( x + y * X + z * X * Y ))
}

tileup__main() {
    local X=6
    local Y=6
    local Z=5
    
    local card_arr=(
        $(
            for (( i = 0; i < X * Y * Z; ++i ))
            do
                printf "N/A "
            done
        )
    )
}
