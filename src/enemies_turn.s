enemys_turn:
	ld de,global_.enemies
	ld c,n_enemies+1
@loop:
	ld h,d
	ld l,e
	call AI
	ld hl,_sizeof_enemy
	add hl,de
	ld d,h
	ld e,l
	dec c
	jp nz,@loop
