#!/bin/bash

. src/metal_calculation/lib.sh
. src/m_cards_n_points/lib.sh
. src/piano/lib.sh
. src/tic_tac_toe/lib.sh

main() {
    local -a games=("metal" "MCNP" "piano" "ttt")
    select game in "${games[@]}"
    do
        if [[ "${game}" ]]
        then
            break
        fi
    done
    "${game}__main"
}

main
