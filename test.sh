#!/bin/bash

. src/m_cards_n_points.sh

mapfile -t arr < <(select_cards 4)
enumerate_formula "${arr[@]}"
