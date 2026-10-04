metal__random_integer() {
    local low=$1
    local up=$2

    if [[ "${low}" -gt "${up}" ]]
    then
        echo "low is greater than up"
        exit 1
    fi

    shuf -i "${low}-${up}" -n 1
}

metal__handle_answer() {
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

metal__summation() {
    local low=$1
    local up=$2

    while true
    do
        local A=$(metal__random_integer ${low} ${up})
        local B=$(metal__random_integer ${low} ${up})
        local C=$((A + B))

        while true
        do
            read -ep "${A} + ${B} (c to show answer): " D
            if ! metal__handle_answer ${C} ${D}
            then
                break
            fi
        done
    done
}

metal__substraction() {
    local low=$1
    local up=$2

    while true
    do
        local A=$(metal__random_integer ${low} ${up})
        local B=$(metal__random_integer ${low} ${up})
        if [[ "${A}" -lt "${B}" ]]
        then
            local temp="${A}"
            local A="${B}"
            local B="${temp}"
        fi
        local C=$((A - B))

        while true
        do
            read -ep "${A} - ${B} (c to show answer): " D
            if ! metal__handle_answer ${C} ${D}
            then
                break
            fi
        done
    done
}

metal__multiplication() {
    local low=$1
    local up=$2

    while true
    do
        local A=$(metal__random_integer ${low} ${up})
        local B=$(metal__random_integer ${low} ${up})
        local C=$((A * B))

        while true
        do
            read -ep "${A} * ${B} (c to show answer): " D
            if ! metal__handle_answer ${C} ${D}
            then
                break
            fi
        done
    done    
}

metal__division() {
    local low=$1
    local up=$2

    while true
    do
        local B=$(metal__random_integer ${low} ${up})
        local C=$(metal__random_integer ${low} ${up})
        local A=$((B * C))

        while true
        do
            read -ep "${A} / ${B} (c to show answer): " D
            if ! metal__handle_answer ${C} ${D}
            then
                break
            fi
        done
    done    
}

metal__read_number() {
    local var=$1
    local temp
    while true
    do
        read -ep "${var}: " temp
        if [[ "${temp}" =~ ^[0-9]+$ ]]; then
            break
        fi
    done
    echo "${temp}"
}

metal__main() {
    local operation
    select operation in "+" "-" "*" "/"
    do
        if [[ "${operation}" ]]
        then
            break
        fi
    done

    while true
    do
        local low=$(metal__read_number low)
        local up=$(metal__read_number up)
        if [[ "${low}" -le "${up}" ]]
        then
            break
        fi
        printf "low must be less than or equal to up\n"
    done

    case "${operation}" in
        "+")
            metal__summation "${low}" "${up}"
            ;;
        "-")
            metal__substraction "${low}" "${up}"
            ;;
        "*")
            metal__multiplication "${low}" "${up}"
            ;;
        "/")
            metal__division "${low}" "${up}"
            ;;
    esac
}
