select_cards() {
    local num=$1

    for i in {1..4}
    do
        for j in {1..13}
        do
            echo ${j}
        done
    done |
    shuf -n ${num}
}

N_choose_K() {
    local K=$1
    shift
    local -a arr=("$@")    
    local N=${#arr[@]}

    if (( 2 * K > N ))
    then
        echo "2K cannot exceed N"
        exit 1
    fi

    if (( K == 1 ))
    then
        if (( N > 2 ))
        then
            for (( i = 0; i < N; ++i ))
            do 
                printf "%d\n" "${arr[$i]}"
            done
        else
            printf "%d\n" "${arr[0]}"
        fi
        return 0
    fi

    if (( 2 * K == N ))
    then
        local line
        while read line
        do
            printf "%d %s\n" "${arr[0]}" "${line}"
        done < <(
            N_choose_K "$((K - 1))" "${arr[@]:1}"
        )
        return 0
    fi

    for (( i = 0; i < N; ++i ))
    do
        local line
        while read line
        do
            printf "%d %s\n" "${arr[$i]}" "${line}"
        done < <(N_choose_K $((K - 1)) "${arr[@]:$((i+1))}")
    done
}

set_diff() {
    local -n _ref_arr1=$1
    local -n _ref_arr2=$2

    comm -23 \
        <(
            printf '%s\n' "${_ref_arr1[@]}" | 
            sort
        ) \
        <(
            printf '%s\n' "${_ref_arr2[@]}" |
            sort
        )
}

enumerate_formula() {
    local -a arr=("$@")
    local N=${#arr[@]}

    if (( N == 1 ))
    then
        printf "%d\n" "${arr[0]}"
        return 0
    fi

    local K
    for ((K = 1; K <= N / 2; ++K))
    do
        local line
        while read line
        do
            local arr1=(${line})
            local arr2
            mapfile -t arr2 < <(
                set_diff arr arr1        
            )
            mapfile -t exps1 < <(
                enumerate_formula "${arr1[@]}"
            )
            mapfile -t exps2 < <(
                enumerate_formula "${arr2[@]}"
            )
            for exp1 in "${exps1[@]}"
            do
                if (( K > 1 ))
                then
                    exp1="(${exp1})"
                fi
                for exp2 in "${exps2[@]}"
                do
                    if (( N - K > 1 ))
                    then
                        exp2="(${exp2})"
                    fi
                    for op in "+" "-" "*" "/"
                    do
                        printf "%s %s %s\n" "${exp1}" "${op}" "${exp2}"
                    done
                done
            done
        done < <(
            N_choose_K ${K} "${arr[@]}"
        )
    done   
}
