display_test_init:

; // Add rocks
	ld de, global_.blockings
	ld c, n_blockings
@looptodisplayrocks:

	ld a,(de)
	cp ROCK_INFO		; test if the element is a living rock
	jp nz, @ending_of_looptodisplayrocks

	ld h,d
	ld l,e
	inc hl
	ldi b, (hl) ;y position in pixels (must be a multiple of 8)
	ld a, (hl) ;x position in pixels (must be a multiple of 8)
	ld l,ROCKS_SPRITESHEET ;start tile id
	call displayBackgroundTile
@ending_of_looptodisplayrocks:
	inc de
	inc de
	inc de
	dec c
	jr nz, @looptodisplayrocks

; // Add hurting rock
	ld de, global_.enemies
	ld c, n_enemies
@looptodisplayhurtingrocks:

	ld a,(de)
	cp HURTING_ROCK_INFO		; test if the element is a living hurting rock
	jp nz, @ending_of_looptodisplayhurtingrocks

	ld h,d
	ld l,e
	inc hl
	ldi b, (hl) ;y position in pixels (must be a multiple of 8)
	ld a, (hl) ;x position in pixels (must be a multiple of 8)
	ld l,ROCKS_SPRITESHEET ;start tile id
	call displayBackgroundTile
@ending_of_looptodisplayhurtingrocks:
	ld hl, 6
	add hl, de
	ld d, h
	ld e, l
	dec c
	jr nz, @looptodisplayhurtingrocks

; ld l,ROCKS_SPRITESHEET+8 ;start tile id
; ld a, 7*8 ;X position in pixels (must be a multiple of 8)
; ld b, 4*8 ;Y position in pixels (must be a multiple of 8)
; call displayBackgroundTile
; ld l,ROCKS_SPRITESHEET+4 ;start tile id
; ld a, 3*8 ;X position in pixels (must be a multiple of 8)
; ld b, 8*8 ;Y position in pixels (must be a multiple of 8)
; call displayBackgroundTile
