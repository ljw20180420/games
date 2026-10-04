MCNP__select_cards() {
    local num=$1

    local i
    for i in {1..4}
    do
        local j
        for j in {1..13}
        do
            echo ${j}
        done
    done |
    shuf -n ${num}
}

MCNP__N_choose_K() {
    local K=$1
    shift    
    local N=$#

    if (( K == 1 ))
    then
        local num
        for num in "$@"
        do 
            echo ${num}
        done
        return 0
    fi

    local i
    for (( i = 0; i <= N - K; ++i ))
    do
        local num=$1
        shift
        local line
        while read line
        do
            printf "%d %s\n" "${num}" "${line}"
        done < <(MCNP__N_choose_K $(( K - 1 )) "$@")
    done
}

MCNP__set_diff() {
    local -n _ref_arr1=$1
    local -n _ref_arr2=$2
    local -A seen

    local item
    for item in "${_ref_arr2[@]}"
    do
        (( seen["${item}"]++ ))
    done

    local -a difference
    for item in "${_ref_arr1[@]}"; do
        if [[ "${seen["${item}"]}" -gt 0 ]]; then
            (( seen["${item}"]-- ))
            continue
        fi
        difference+=("${item}")
    done

    echo "${difference[@]}"
}

MCNP__enumerate_half() {
    local N=$#
    if (( N < 2 ))
    then
        echo ${N} >&2
        echo "$@" >&2
        echo "input parameter must be more than 2" >&2
        exit 1
    elif (( N == 2 ))
    then
        echo $1
        return 0
    fi
    local K
    for (( K = 1; K <= (N - 1) / 2; ++K ))
    do
        MCNP__N_choose_K "${K}" "$@"
    done
    (( K = N / 2 ))
    if (( 2 * K == N ))
    then
        local num=$1
        shift
        local line
        while read line
        do
            printf "%d %s\n" "${num}" "${line}"
        done < <(
            MCNP__N_choose_K $(( K - 1 )) "$@"
        )
    fi
}

MCNP__enumerate_formula() {
    local N="$#"
    local arr=("$@")

    if (( N == 1 ))
    then
        echo $1
        return 0
    fi

    local line
    while read line
    do
        local arr1=($line)
        local arr2=($(MCNP__set_diff arr arr1))

        if [[ "${#arr1[@]}" -gt 1 ]]
        then
            local left_pat="(%s)"
        else
            local left_pat="%s"
        fi
        if [[ "${#arr2[@]}" -gt 1 ]]
        then
            local right_pat="(%s)"
        else
            local right_pat="%s"
        fi

        local line1
        while read line1
        do
            local line2
            while read line2
            do
                local op
                for op in "+" "-" "*" "/"
                do
                    printf "${left_pat} %s ${right_pat}\n" "${line1}" "${op}" "${line2}"
                done
            done < <(
                MCNP__enumerate_formula "${arr2[@]}"    
            )
        done < <(
            MCNP__enumerate_formula "${arr1[@]}"
        )
    done < <(
        MCNP__enumerate_half "$@"
    )
}

MCNP__evaluate_answer() {
    local answer=$1

    printf "scale = 4\n%s\n" "${answer}" |
    bc 2> /dev/null
}

MCNP__approximate_equal() {
    local v1=$1
    local v2=$2

    if [[ -z "${v1}" || -z "${v2}" ]]
    then
        echo 0
        return 0
    fi

    printf "%s - %s < 0.01 && %s - %s > -0.01\n" ${v1} ${v2} ${v1} ${v2} | bc -l
}

MCNP__main() {
    local point
    select point in "24" "60"
    do
        if [[ "${point}" ]]
        then
            break
        fi
    done
    case "${point}" in
        "24")
            local card_num=4
            ;;
        "60")
            local card_num=5
            ;;
    esac

    local -a arr
    while true
    do
        mapfile -t arr < <(MCNP__select_cards "${card_num}")
        local answer
        local answer_point
        while read answer
        do
            answer_point="$(MCNP__evaluate_answer "${answer}")"
            if (( "$(MCNP__approximate_equal "${answer_point}" "${point}")" ))
            then
                break
            fi 
        done < <(
            MCNP__enumerate_formula "${arr[@]}" | shuf
        )
        if (( ! "$(MCNP__approximate_equal "${answer_point}" "${point}")" ))
        then
            continue
        fi

        local input
        local input_point
        while true
        do
            read -ep "${arr[*]} (c to show answer): " input
            if [[ "${input}" == "c" ]]
            then
                printf "%s = %d\n" "${answer}" "${point}"
                break
            fi
            input_point="$(MCNP__evaluate_answer "${input}")"
            if (( input_point == point ))
            then
                printf "%s = %d\n" "${input}" "${point}"
                break
            fi
        done
    done
}
