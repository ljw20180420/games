#!/bin/bash

declare -A keymap

piano__load_keymap() {
    local -n __ref_keymap=$1

    __ref_keymap["a"]="b"
}

piano__load_keymap keymap
