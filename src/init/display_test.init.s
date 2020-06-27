display_test_init:

// Add rocks
	ld de, global_.elements
	ld c, n_elements
@looptodisplayrocks:

	ld a,(de)
	and a					; test if the element has hp
	jp z, @ending_of_looptodisplayrocks
	ld h,d
	ld l,e
	inc hl
	ldi a, (hl) ;Y position in pixels (must be a multiple of 8)
	ld b, (hl) ;X position in pixels (must be a multiple of 8)
	ld l,ROCKS_SPRITESHEET ;start tile id
	call displayBackgroundTile
@ending_of_looptodisplayrocks:
	ld hl, $0007
	add hl, de
	ld d, h
	ld e, l
	dec c
	jr nz, @looptodisplayrocks


; ld l,ROCKS_SPRITESHEET+8 ;start tile id
; ld a, 7*8 ;X position in pixels (must be a multiple of 8)
; ld b, 4*8 ;Y position in pixels (must be a multiple of 8)
; call displayBackgroundTile
; ld l,ROCKS_SPRITESHEET+4 ;start tile id
; ld a, 3*8 ;X position in pixels (must be a multiple of 8)
; ld b, 8*8 ;Y position in pixels (must be a multiple of 8)
; call displayBackgroundTile
