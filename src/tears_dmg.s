
isaac_tears_dmg:
	ld a,TEARS_HITBOX
	ld (collision_.hitbox1),a

	ld de,global_.isaac_tears

	ld c,n_isaac_tears
@loop_tears:
	ld h,d
	ld l,e
	ld a,(hl)
	and a
	jr z,@ending_loop_tears

	ldi a,(hl)
	ld (collision_.p.1.y),a
	ldi a,(hl)
	ld (collision_.p.1.x),a

	push de
	ld de,global_.enemies
	ld b,n_enemies
@loop_ennemies:
	ld h,d
	ld l,e
	ldi a,(hl)
	bit ALIVE_FLAG, a
	jr z,@ending_loop_ennemies
	and ENEMY_SIZE_MASK
	ld (collision_.hitbox2),a
	ldi a,(hl)
	ld (collision_.p.2.y),a
	ldi a,(hl)
	ld (collision_.p.2.x),a
	call collision
	and a
	jp z,@ending_loop_ennemies

; //// DEAL DMG \\\\
	ld hl,3
	add hl,de
	ld a, (hl)
	ld hl, global_.isaac.dmg
	sub (hl)
	ld hl,3
	add hl, de
	ld (hl), a
	cp 1
	jp nc, @@notDead
	ld a, (de)
	and %01111111
	ld (de), a
; \\\\ DEAL DMG ////
@@notDead

@ending_loop_ennemies:
	ld hl,_sizeof_enemy
	add hl,de
	ld d,h
	ld e,l

	dec b
	jr nz,@loop_ennemies
	pop de
@ending_loop_tears:
	ld hl,_sizeof_tear
	add hl,de
	ld d,h
	ld e,l

	dec c
	jr nz,@loop_tears
