play_note() {
    local note=$1

    play -n synth 3 pluck ${note} fade 0 1.5 1.2 2>/dev/null &
}

piano() {
    local key
    while true; do
        read -rsn 1 key
        case "$key" in
            "q") play_note A2 ;;
            "w") play_note A#2 ;;
            "e") play_note B2 ;;
            "r") play_note C3 ;;
            "t") play_note C#3 ;;
            "a") play_note D3 ;;
            "s") play_note D#3 ;;
            "d") play_note E3 ;;
            "f") play_note F3 ;;
            "g") play_note F#3 ;;
            "z") play_note G3 ;;
            "x") play_note G#3 ;;
            "c") play_note A3 ;;
            "v") play_note A#3 ;;
            "b") play_note B3 ;;
            "y") play_note C4 ;;
            "u") play_note C#4 ;;
            "i") play_note D4 ;;
            "o") play_note D#4 ;;
            "p") play_note E4 ;;
            "h") play_note F4 ;;
            "j") play_note F#4 ;;
            "k") play_note G4 ;;
            "l") play_note G#4 ;;
            ";") play_note A4 ;;
            "n") play_note A#4 ;;
            "m") play_note B4 ;;
            ",") play_note C5 ;;
            ".") play_note C#5 ;;
            "/") play_note D5 ;;
        esac
    done
}
