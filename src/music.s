
;open sound circuits and sound set up
ld a,%10000000
ldh ($26),a
ld a,%01110111
ldh ($24),a
ld a,%00110011
ldh ($25),a

timer_interupt :

    ;check if the note is finished
    ld a, (rest1)
    ld b, a
    ld a, (rest1+1)
    ld c, a
    dec bc
    jp nz, pass1

    ;switch off channel 1


    ;if the note is finished, let's get the next one
    ld hl, curs1
    ld b, (hl); take higher weight bits
    inc hl
    ld c, (hl) ;take lower weight bits
    inc bc ;take the address of the next note
    ld (hl), b

    ld a,(bc) ;take and the note to play
    ld e, a

    ;take the scale of the note to play
    and $F0 ;take higher weight bits which takes the scale of the note
    swap
    ld hl, scale1
    ld b, (hl) ;take higher weight bits
    inc hl
    ld c, (hl) ;take lower weight bits
    ld d, a
    sla d
    add bc, d ;find the the scale linked to a
    ld a, (bc)
    ld d, a ;save the frequency of the note to play in d

    ld a, e :take the note to play

    ;take the time of the note to play
    and $0F ;take lower weight bits which takes the time of the note
    ld hl, timing1
    ld b, (hl) ;take higher weight bits
    inc hl
    ld c, (hl) ;take lower weight bits
    ld e, a
    sla e
    add bc, e
    ld hl, bc
    //ld rest1, hl ;set the time of the note to play in rest1, this line may not be useful

    ;play the frequency of the note
  	ld a,%11110000
  	ldh ($12),a

    ld a, d
    bit 7, a
    jp z, @silence
    and 00000111
    or 11000000
    ldh ($14),a ;set the 3 higher weight bits

    inc d
    ld a, d
    ldh ($13), a     ;set 5 lower weight bits

    jp @endSilence

@endSilence:

@pass1:
