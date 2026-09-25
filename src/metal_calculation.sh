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
}
