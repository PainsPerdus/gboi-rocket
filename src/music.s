; Variables
dw fileAddress
dw rest1
dw rest2
dw curs1
dw curs2
dw scale1
dw scale2
dw timing1
dw timing2

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
    ld a, (bc)
    ld e, a ;save the time of the note to play in e

    ;play the note
    ;Lower 8 bits of 11 bit frequency (FF13). Next 3 bit are in NR14 ($FF14)



pass1:
