music_init:
    ld a,%10000000
    ldh ($26),a    ;open sound circuits
    ld a,%01110111
    ldh ($24),a    ;set channels' volume to the maximum

    ldh a, ($FF) ; enable timer
    or %00000100
    ldh ($FF), a

    ld hl, sacrificial_music
    call music_start