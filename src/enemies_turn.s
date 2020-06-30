enemys_turn:
	ld de,global_.enemies
	ld c,n_enemies+1
@loop:
	ld h,d
	ld l,e
	call AI


	ld hl,$0004
	add hl,de
	ld b,(hl)
	ld a,b

	ld hl,$0001
	add hl,de


  ld a,b
  and %00001111
  bit $3,a
  jr z,@@posit_y
  or %11110000
@@posit_y:
  add (hl)
  ldi (hl),a

	ld a,b
	swap a
	and %00001111
	bit $3,a
	jr z,@@posit_x
	or %11110000
@@posit_x:
	add (hl)
	ld (hl),a

	ld hl,_sizeof_enemy
	add hl,de
	ld d,h
	ld e,l
	dec c
	jp nz,@loop
