music_init:
    ld a,%10000000
    ldh ($26),a    ;open sound circuits
    ld a,%01110111
    ldh ($24),a    ;set channels' volume to the maximum