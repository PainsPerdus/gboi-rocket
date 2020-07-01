music_init:
    ld a,%10000000
    ldh ($26),a    ;open sound circuits
    ld a,%01110111
    ldh ($24),a    ;set channels' volume to the maximum

    ld a, %00000111 ; enable timer
    ldh ($07), a

    ld a, %11111100 ; 
    ldh ($06), a ; set TIMA for 4096 hz

    ld hl, sacrificial_music
    call music_start