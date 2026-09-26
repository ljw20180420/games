#!/bin/bash

. src/metal_calculation.sh

main() {
    games=("metal")
    select game in "${games[@]}"
    do
        if [[ "${game}" ]]
        then
            break
        fi
    done
    "${game}"
}

main
