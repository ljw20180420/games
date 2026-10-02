#!/bin/bash

. src/metal_calculation.sh
. src/m_cards_n_points.sh
. src/piano.sh

main() {
    local -a games=("metal" "MCNP" "piano")
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
