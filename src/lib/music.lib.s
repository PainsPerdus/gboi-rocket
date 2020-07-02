timer_interrupt:
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
    ld a, b
    ld (music_state_.rest1), a
    ld a, c
    ld (music_state_.rest1+1), a
    or 0
    jp nz, @continueCurrentNote1
    ld a, b
    or 0
    jp nz, @continueCurrentNote1

    ;switch off channel 1
    ldh a,($25)
    and %00100000
    ldh ($25),a
    ld a,%11110000
  	ldh (SND_CHAN1_VOL_ENVEL_LOW),a


    ;get the next note to play
    ld hl, music_state_.curs1
    ld b, (hl)    ; take higher weight bits
    inc hl
    ld c, (hl)    ;take lower weight bits
    ld a,(bc)    ; save the note to play
    inc bc    ;take the address of the next note

    push af
    push de
    push hl

    ld hl, music_state_.max1 ; find out if we got to the end
    ld d, (hl)
    inc hl
    ld a, (hl)
    sub c
    ld e, a
    ld a, d
    sub b
    or e
    jp z, @endofpart

    pop hl
    pop de
    pop af

    ld (hl), c ; load the next note address in memory
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
    ld h, 0
    add hl, bc    ;find the real scale linked to the note
    push hl
    

    ;take the time of the note to play
    ld a, e    ;take the note to play previously saved
    and $0F    ;take lower weight bits which takes the time of the note
    ld hl, music_state_.timing1
    ld b, (hl)    ;take higher weight bits
    inc hl
    ld c, (hl)    ;take lower weight bits
    ld l, a
    sla l
    ld h, 0
    add hl, bc ; get adress of frequency
    ldi a, (hl) ; get frequency
    ld (music_state_.rest1),a ;set the time of the note to play in rest1, this line may not be useful
    ld a, (hl)
    ld (music_state_.rest1+1),a

    ;play the frequency of the note
    pop hl
    ldi a, (hl)
    bit 7, a
    jp nz, @silence
    and %00000111
    or %10000000
    ldh (SND_CHAN1_FREQ_HI_FLAGS_LOW), a
    ld a, (hl)
    ldh (SND_CHAN1_FREQ_LO_LOW), a

    ;switch on channel 1
    ldh a,($25)
    or %00000001
    ldh ($25),a

@silence:
    nop
@continueCurrentNote1:

;    \\\\ CHANNEL 1 ////

;    //// CHANNEL 2 \\\\

    ld a, (music_state_.rest2)
    ld b, a
    ld a, (music_state_.rest2+1)
    ld c, a
    dec bc
    ld a, b
    ld (music_state_.rest2), a
    ld a, c
    ld (music_state_.rest2+1), a
    or 0
    jp nz, @continueCurrentNote2
    ld a, b
    or 0
    jp nz, @continueCurrentNote2

    ;switch off channel 2
    ldh a,($25)
    and %00000001
    ldh ($25),a
    ld a,%11110000
  	ldh (SND_CHAN2_VOL_ENVEL_LOW),a


    ;get the next note to play
    ld hl, music_state_.curs2
    ld b, (hl)    ; take higher weight bits
    inc hl
    ld c, (hl)    ;take lower weight bits
    ld a,(bc)    ; save the note to play
    inc bc    ;take the address of the next note

    push af
    push de
    push hl

    ld hl, music_state_.max2 ; find out if we got to the end
    ld d, (hl)
    inc hl
    ld a, (hl)
    sub c
    ld e, a
    ld a, d
    sub b
    or e
    jp z, @endofpart

    pop hl
    pop de
    pop af

    ld (hl), c ; load the next note address in memory
    dec hl
    ld (hl), b
    
    ld e, a

    ;take the scale of the note to play
    and $F0 ;take higher weight bits which takes the scale of the note
    swap a
    ld hl, music_state_.scale2
    ld b, (hl)    ;take higher weight bits
    inc hl
    ld c, (hl)    ;take lower weight bits
    ld l, a
    sla l
    ld h, 0
    add hl, bc    ;find the real scale linked to the note
    push hl
    

    ;take the time of the note to play
    ld a, e    ;take the note to play previously saved
    and $0F    ;take lower weight bits which takes the time of the note
    ld hl, music_state_.timing2
    ld b, (hl)    ;take higher weight bits
    inc hl
    ld c, (hl)    ;take lower weight bits
    ld l, a
    sla l
    ld h, 0
    add hl, bc ; get adress of frequency
    ldi a, (hl) ; get frequency
    ld (music_state_.rest2),a ;set the time of the note to play in rest1, this line may not be useful
    ld a, (hl)
    ld (music_state_.rest2+1),a

    ;play the frequency of the note
    pop hl
    ldi a, (hl)
    bit 7, a
    jp nz, @silence2
    and %00000111
    or %10000000
    ldh (SND_CHAN2_FREQ_HI_FLAGS_LOW), a
    ld a, (hl)
    ldh (SND_CHAN2_FREQ_LO_LOW), a

    ;switch on channel 2
    ldh a,($25)
    or %00100000
    ldh ($25),a

@silence2:
    nop
@continueCurrentNote2:

;    \\\\ CHANNEL 2 ////

;\\\\ TIMER INTERUPT LOOP ////
;\\\\ MUSIC PLAYER ///
    pop HL
    pop DE
    pop BC
    pop AF
  ret

@endofpart:
    pop hl
    pop de
    pop af
    ld hl, sacrificial_music
    ;jr @gothrough
    ld a, (music_state_.part)
    ld e, a
    inc a
    ld (music_state_.part), a
    ld a, e
    sla a
    sla a
    sla a
    sla a
    ld e,a
    ld d,0
    add hl, de
    ld a, (hl)
    xor $FF
    jp nz, @gothrough ; check if end of music and loop
    inc hl
    ldd a, (hl)
    xor $FF
    jp nz, @gothrough
    ld hl, sacrificial_music
    xor a
    ld (music_state_.part), a
@gothrough
    call music_start
    pop HL
    pop DE
    pop BC
    pop AF
    ret

music_start: ; HL -> pointer to music
    push BC
    push DE

    ld c, (hl)
    inc hl
    ld b, (hl) ; load max pointer in bc
    ld d, h
    ld e, l

    ld hl, music_state_.max1 ; write pointer in state struct
    ld (hl), b
    inc hl
    ld (hl), c

    ld h, d
    ld l, e
    inc hl

    ld c, (hl)
    inc hl
    ld b, (hl) ; load scale pointer in bc
    ld d, h ; save hl
    ld e, l

    ld hl, music_state_.scale1 ; write pointer in state struct
    ld (hl), b
    inc hl
    ld (hl), c

    ld h, d ; load back hl
    ld l, e
    inc hl

    ld c, (hl)
    inc hl
    ld b, (hl) ; load timings pointer in bc
    ld d, h
    ld e, l ; save hl

    ld hl, music_state_.timing1 ; write pointer in state struct
    ld (hl), b
    inc hl
    ld (hl), c

    ld h, d ; load back hl
    ld l, e
    inc hl

    ld c, (hl)
    inc hl
    ld b, (hl) ; load melody pointer in bc
    ld d, h
    ld e, l

    ld hl, music_state_.curs1 ; write pointer in state struct
    ld (hl), b
    inc hl
    ld (hl), c

    xor a
    ld hl, music_state_.rest1
    ld (hl), a
    inc a
    inc hl
    ld (hl), a

    ld h, d ; load back hl
    ld l, e
    inc hl

    ld c, (hl)
    inc hl
    ld b, (hl) ; load max pointer in bc
    ld d, h
    ld e, l

    ld hl, music_state_.max2 ; write pointer in state struct
    ld (hl), b
    inc hl
    ld (hl), c

    ld h, d
    ld l, e
    inc hl

    ld c, (hl)
    inc hl
    ld b, (hl) ; load scale pointer in bc
    ld d, h ; save hl
    ld e, l

    ld hl, music_state_.scale2 ; write pointer in state struct
    ld (hl), b
    inc hl
    ld (hl), c

    ld h, d ; load back hl
    ld l, e
    inc hl

    ld c, (hl)
    inc hl
    ld b, (hl) ; load timings pointer in bc
    ld d, h
    ld e, l ; save hl

    ld hl, music_state_.timing2 ; write pointer in state struct
    ld (hl), b
    inc hl
    ld (hl), c

    ld h, d ; load back hl
    ld l, e
    inc hl

    ld c, (hl)
    inc hl
    ld b, (hl) ; load melody pointer in bc
    ld d, h
    ld e, l

    ld hl, music_state_.curs2 ; write pointer in state struct
    ld (hl), b
    inc hl
    ld (hl), c

    xor a
    ld hl, music_state_.rest2
    ld (hl), a
    inc a
    inc hl
    ld (hl), a

    
    
    pop DE
    pop BC

    ret





.INCLUDE "music/sacrificial.gbscore"
