timer_interupt :
    push AF
    push BC
    push DE
    push HL
;    //// CHANNEL 1 \\\\
    ;check if the note is finished on channel 1
    ld a, (music_state_.rest1)
    ld b, a
    ld a, (music_state_.rest1+1)
    ld c, a
    dec bc
    jp nz, @continueCurrentNote1

    ;switch off channel 1
    ld a,($25)
    and %00100000
    ldh ($25),a
    ld a,%11110000
  	ldh ($12),a

    ;get the next note to play
    ld hl, music_state_.curs1
    ld b, (hl)    ; take higher weight bits
    inc hl
    ld c, (hl)    ;take lower weight bits
    ld a,(bc)    ; save the note to play
    inc bc    ;take the address of the next note
    ld (hl), c
    dec hl
    ld (hl), b
    
    ld e, a

    ;take the scale of the note to play
    and $F0 ;take higher weight bits which takes the scale of the note
    swap a
    ld hl, music_state_.scale1
    ld b, (hl)    ;take higher weight bits
    inc hl
    ld c, (hl)    ;take lower weight bits
    ld l, a
    sla l
    xor h
    add hl, bc    ;find the real scale linked to the note
    ld a, (hl)
    ld d, a     ;save the frequency of the note to play in d

    ;take the time of the note to play
    ld a, e    ;take the note to play previously saved
    and $0F    ;take lower weight bits which takes the time of the note
    ld hl, music_state_.timing1
    ld b, (hl)    ;take higher weight bits
    inc hl
    ld c, (hl)    ;take lower weight bits
    ld l, a
    sla l
    xor h
    add hl, bc
    ld a, h
    ld (music_state_.rest1),a ;set the time of the note to play in rest1, this line may not be useful
    ld a, l
    ld (music_state_.rest1+1),a

    ;play the frequency of the note
  	ld a, d
    bit 7, a
    jp z, @silence
    and %00000111
    or %11000000
    ldh ($14),a    ;set the 3 higher weight bits of the frequency
    inc d
    ld a, d
    ldh ($13), a     ;set the 5 lower weight bits

    ;switch on channel 1
    ld a,($25)
    or %00000001
    ldh ($25),a

@silence:

@continueCurrentNote1:

;    \\\\ CHANNEL 1 ////

;    //// CHANNEL 2 \\\\
;    \\\\ CHANNEL 2 ////

;\\\\ TIMER INTERUPT LOOP ////
;\\\\ MUSIC PLAYER ///
    pop HL
    pop DE
    pop BC
    pop AF
  reti

music_start: ; HL -> pointer to music
    push BC
    push DE
    ld b, (hl)
    inc hl
    ld c, (hl) ; load scale pointer in bc
    ld d, h
    ld e, l

    ld hl, (music_state_.scale1) ; write pointer in state struct
    ld (hl), b
    inc hl
    ld (hl), c

    ld h, d
    ld l, e
    inc hl

    ld b, (hl)
    inc hl
    ld c, (hl) ; load timings pointer in bc
    ld d, h
    ld e, l

    ld hl, (music_state_.timing1) ; write pointer in state struct
    ld (hl), b
    inc hl
    ld (hl), c

    ld h, d
    ld l, e
    inc hl

    ld b, (hl)
    inc hl
    ld c, (hl) ; load melody pointer in bc
    ld d, h
    ld e, l

    ld hl, (music_state_.curs1) ; write pointer in state struct
    ld (hl), b
    inc hl
    ld (hl), c

    xor a
    ld hl, (music_state_.rest1)
    ld (hl), a
    inc hl
    ld (hl), a
    
    pop DE
    pop BC

    ret





.INCLUDE "music/sacrificial.gbscore"
