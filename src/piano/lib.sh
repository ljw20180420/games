piano__initial_fluidsynth() {
    fluidsynth -a pulseaudio -i -s /usr/share/sounds/sf2/FluidR3_GM.sf2 &> /dev/null &
    FLUID_PID=$!
    sleep 1 
    trap 'kill $FLUID_PID &> /dev/null; exit' INT TERM EXIT
}

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

    echo "noteon 0 ${note} 127" | nc -w 0 127.0.0.1 9800 &> /dev/null &
}

piano__main() {
    local -A keymap
    piano__load_keymap keymap
    piano__initial_fluidsynth

    local key note
    while true; do
        read -rsn 1 key &> /dev/null
        note="${keymap["${key}"]}"
        piano__play_note ${note}
    done
}
