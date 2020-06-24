//// MUSIC PLAYER\\\\
//// To put in the main\\\\
ld a,%10000000
ldh ($26),a    ;open sound circuits
ld a,%01110111
ldh ($24),a    ;set channels' volume to the maximum
\\\\ To put in the main ////

//// TIMER INTERUPT LOOP \\\\
timer_interupt :

    //// CHANNEL 1 \\\\
    ;check if the note is finished on channel 1
    ld a, (rest1)
    ld b, a
    ld a, (rest1+1)
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
    ld hl, curs1
    ld b, (hl)    ; take higher weight bits
    inc hl
    ld c, (hl)    ;take lower weight bits
    inc bc    ;take the address of the next note
    ld (hl), b
    ld a,(bc)    ; save the note to play
    ld e, a

    ;take the scale of the note to play
    and $F0 ;take higher weight bits which takes the scale of the note
    swap
    ld hl, scale1
    ld b, (hl)    ;take higher weight bits
    inc hl
    ld c, (hl)    ;take lower weight bits
    ld d, a
    sla d
    add bc, d    ;find the real scale linked to the note
    ld a, (bc)
    ld d, a     ;save the frequency of the note to play in d

    ;take the time of the note to play
    ld a, e    ;take the note to play previously saved
    and $0F    ;take lower weight bits which takes the time of the note
    ld hl, timing1
    ld b, (hl)    ;take higher weight bits
    inc hl
    ld c, (hl)    ;take lower weight bits
    ld e, a
    sla e
    add bc, e
    ld hl, bc
    //ld rest1, hl ;set the time of the note to play in rest1, this line may not be useful

    ;play the frequency of the note
  	ld a, d
    bit 7, a
    jp z, @silence
    and 00000111
    or 11000000
    ldh ($14),a    ;set the 3 higher weight bits of the frequency
    inc d
    ld a, d
    ldh ($13), a     ;set the 5 lower weight bits

    ;switch on channel 1
    ld a,($25)
    or %00000001
    ldh ($25),a

@Silence:

@continueCurrentNote1:

    \\\\ CHANNEL 1 ////

    //// CHANNEL 2 \\\\
    \\\\ CHANNEL 2 ////

\\\\ TIMER INTERUPT LOOP ////
\\\\ MUSIC PLAYER ///
