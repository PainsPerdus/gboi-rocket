	ld hl,$FE90
; TEST SPRITE:

ld a,$50
ld (hl), a ;PosY
inc l
ld (hl), a ;PosX
inc l
ld a,$01
ld (hl), a
inc l
