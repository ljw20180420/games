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

metal_summation() {
    local low=$1
    local up=$2

    local A=$(random_integer ${low} ${up})
    local B=$(random_integer ${low} ${up})
    local C=$((A + B))

    while true
    do
        read -p "${A} + ${B}:" D
        if [[ "${D}" == "c" || "${D}" -eq "${C}" ]]
        then
            return 0
        fi
    done
}
