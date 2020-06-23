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
ld a, (rest1)
dec a ;on soustrait la frequence du timer
jp nz, pass1

;quand la note est terminee
ld hl, curs1
ld b, (hl)
inc hl
ld c, (hl)
inc bc ;(*curs1)++
ld (hl), c
dec hl
ld (hl), b

ld a, (curs1)

and $F0 ;recuperation des bits de poid fort
swap
ld scale1, a

and $0F ;recuperation des bits de poid faible
ld timing1

pass1:
