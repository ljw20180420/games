random_integer() {
    local low=$1
    local up=$2

    if [[ "${low}" -gt "${up}" ]]
    then
        echo "low is greater than up"
        exit 1
    fi

    shuf -i "${low}-${up}" -n 1
}

handle_answer() {
    local answer=$1
    local input=$2

    if [[ "${input}" == "c" || "${input}" -eq "${answer}" ]]
    then
        printf "answer: %d\n" ${answer}
        return 1
    fi

    printf "wrong\n"
    return 0
}

metal_summation() {
    local low=$1
    local up=$2

    while true
    do
        local A=$(random_integer ${low} ${up})
        local B=$(random_integer ${low} ${up})
        local C=$((A + B))

        while true
        do
            read -p "${A} + ${B}:" D
            if ! handle_answer ${C} ${D}
            then
                break
            fi
        done
    done
}

metal_substraction() {
    local low=$1
    local up=$2

    while true
    do
        local A=$(random_integer ${low} ${up})
        local B=$(random_integer ${low} ${up})
        if [[ "${A}" -lt "${B}" ]]
        then
            local temp="${A}"
            local A="${B}"
            local B="${temp}"
        fi
        local C=$((A - B))

        while true
        do
            read -p "${A} - ${B}:" D
            if ! handle_answer ${C} ${D}
            then
                break
            fi
        done
    done
}

metal_multiplication() {
    local low=$1
    local up=$2

    while true
    do
        local A=$(random_integer ${low} ${up})
        local B=$(random_integer ${low} ${up})
        local C=$((A * B))

        while true
        do
            read -p "${A} * ${B}:" D
            if ! handle_answer ${C} ${D}
            then
                break
            fi
        done
    done    
}

metal_division() {
    local low=$1
    local up=$2

    while true
    do
        local B=$(random_integer ${low} ${up})
        local C=$(random_integer ${low} ${up})
        local A=$((B * C))

        while true
        do
            read -p "${A} / ${B}:" D
            if ! handle_answer ${C} ${D}
            then
                break
            fi
        done
    done    
}

read_number() {
    local var=$1
    local temp
    while true
    do
        read -p "${var}: " temp
        if [[ "${temp}" =~ ^[0-9]+$ ]]; then
            break
        fi
    done
    echo "${temp}"
}

metal() {
    local -a operations=("+" "-" "*" "/")
    local operation
    select operation in "${operations[@]}"
    do
        if [[ "${operation}" ]]
        then
            break
        fi
    done

    while true
    do
        local low=$(read_number low)
        local up=$(read_number up)
        if [[ "${low}" -le "${up}" ]]
        then
            break
        fi
        printf "low must be less than or equal to up\n"
    done

    case "${operation}" in
        "+")
            metal_summation "${low}" "${up}"
            ;;
        "-")
            metal_substraction "${low}" "${up}"
            ;;
        "*")
            metal_multiplication "${low}" "${up}"
            ;;
        "/")
            metal_division "${low}" "${up}"
            ;;
    esac
}
