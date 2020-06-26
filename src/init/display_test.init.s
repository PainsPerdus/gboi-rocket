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

// Add rocks
ld l,ROCKS_SPRITESHEET ;start tile id
ld a, 12*8 ;X position in pixels (must be a multiple of 8)
ld b, 12*8 ;Y position in pixels (must be a multiple of 8)
call displayBackgroundTile
ld l,ROCKS_SPRITESHEET+8 ;start tile id
ld a, 7*8 ;X position in pixels (must be a multiple of 8)
ld b, 4*8 ;Y position in pixels (must be a multiple of 8)
call displayBackgroundTile
ld l,ROCKS_SPRITESHEET+4 ;start tile id
ld a, 3*8 ;X position in pixels (must be a multiple of 8)
ld b, 8*8 ;Y position in pixels (must be a multiple of 8)
call displayBackgroundTile
