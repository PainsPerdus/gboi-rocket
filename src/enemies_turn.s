enemys_turn:
	ld de,global_.enemies
	ld c,n_enemies+1
@loop:
	ld h,d
	ld l,e
	call AI
	ld hl,$06
	add hl,de
	ld d,h
	ld e,l
	dec c
	jp nz,@loop
