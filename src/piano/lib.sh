piano__load_keymap() {
    local -n __ref_keymap=$1

    local key note
    while read key note
    do
        __ref_keymap["${key}"]="${note}"
    done < src/piano/keymap.txt
}

piano__play_note() {
    local note=$1

    play -n synth 3 pluck ${note} fade 0 1.5 1.2 2>/dev/null &
}

piano__main() {
    local -A keymap
    piano__load_keymap keymap

    local key note
    while true; do
        read -rsn 1 key
        note="${keymap["${key}"]}"
        piano__play_note ${note}
    done
}
