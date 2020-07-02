fly_hit_sfx:
    ldh a,($25)
    or %11001100
    ldh ($25),a//met les channels 3 et 4 sur les deux hauts parlerus

    //Set channel 3 sound
    ld a,%10000000
    ldh ($1A), a //switch on channel 3 sound
    ld a,%11001111
    ldh ($1B),a //sound length
    ld a,%01000000
    ldh ($1C),a//output level
    ld a,%11011111
    ldh ($1D),a //load 8 lower weight bits of frequency
    ld a,%11000111
    ldh ($1E),a//3 higher weight bits

    ld a,%10000001
    ldh ($30),a //Wave Pattern

    //Set channel 4 sound
    ld a,%00010111
    ldh ($20),a
    ld a,%11110011
    ldh ($21),a
    ld a,%00000000
    ldh ($22),a
    ld a,%11000000
    ldh ($23),a
    ret

start_sfx:
    ldh a,($25)
    or %11001100
    ldh ($25),a//met les channels 3 et 4 sur les deux hauts parlerus

    //Set channel 3 sound
    ld a,%10000000
    ldh ($1A), a //switch on channel 3 sound
    ld a,%11001111
    ldh ($1B),a //sound length
    ld a,%00100000
    ldh ($1C),a //output level
    ld a,%11011111
    ldh ($1D),a //load 8 lower weight bits of frequency
    ld a,%11000111
    ldh ($1E),a //3 higher weight bits
    
    ld a,%00000001
    ldh ($30),a //Wave Pattern
    ld a,%00100011
    ldh ($31),a //Wave Pattern
    ld a,%01000101
    ldh ($32),a //Wave Pattern
    ld a,%01100111
    ldh ($33),a //Wave Pattern
    ld a,%10001001
    ldh ($34),a //Wave Pattern
    ld a,%10101011
    ldh ($35),a //Wave Pattern
    ld a,%11001101
    ldh ($36),a //Wave Pattern
    ld a,%11101111
    ldh ($37),a //Wave Pattern

    ld a,%11111110
    ldh ($38),a //Wave Pattern
    ld a,%11011100
    ldh ($39),a //Wave Pattern
    ld a,%10111010
    ldh ($3A),a //Wave Pattern
    ld a,%10011000
    ldh ($3B),a //Wave Pattern
    ld a,%01110110
    ldh ($3C),a //Wave Pattern
    ld a,%01010100
    ldh ($3D),a //Wave Pattern
    ld a,%00110010
    ldh ($3E),a //Wave Pattern
    ld a,%00010000
    ldh ($3F),a //Wave Pattern

    //Set channel 4 sound
    ld a,%00010111
    ldh ($20),a
    ld a,%11110011
    ldh ($21),a
    ld a,%00000000
    ldh ($22),a
    ld a,%11000000
    ldh ($23),a
    ret