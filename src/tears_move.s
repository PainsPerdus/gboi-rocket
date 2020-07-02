isaac_tears_moves:
	ld de,global_.isaac_tears
	ld c,n_isaac_tears
@loop:


	ld hl,$0000
	add hl,de
	ld a,(hl)
	and a

	jr z,@@no_move

	ld hl,$0002
	add hl,de
	dec (hl)
	jp nz,@@no_move
	ld a,TEARS_SPEED_FREQ
	ld (hl),a

; //// Move the tears \\\\
	ld hl,$0003 ; B = V
	add hl,de
	ld b,(hl)

; /// y += dy \\\
	ld hl,$0000
	add hl,de

  ld a,b
  and %00001111
  bit $3,a
  jr z,@@posit_y
  or %11110000
@@posit_y:
  add (hl)
  ldi (hl),a
; \\\ y += dy ///

; /// x += dx \\\
	ld a,b
	swap a
	and %00001111
	bit $3,a
	jr z,@@posit_x
	or %11110000
@@posit_x:
	add (hl)
	ld (hl),a
; \\\ x += dx ///

; /// destroy the tear on collision with obstacle \\\
	ld h,d
	ld l,e
	ldi a, (hl)
	add TEARS_OFFSET_Y
	ld (collision_.p.1.y), a
	ld (collision_.p_RD.1.y), a
	ld a,(hl)
	add TEARS_OFFSET_X
	ld (collision_.p.1.x), a
	ld (collision_.p_RD.1.x), a
	call preloaded_collision_obstacles
	and a
	jr z,@@no_collision
	xor a
	ld h,d
	ld l,e
	ld (hl),a
@@no_collision:
; \\\ destroy the tear on collision with obstacle ///

; \\\\ Move the tears ////
@@no_move:
	ld hl,_sizeof_tear
	add hl,de
	ld d,h
	ld e,l
	dec c
	jp nz,@loop
