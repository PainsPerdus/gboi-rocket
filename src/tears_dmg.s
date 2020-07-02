
isaac_tears_dmg:
	ld de,global_.isaac_tears

	ld c,n_isaac_tears
@loop_tears:
	ld h,d
	ld l,e
	ld a,(hl)
	and a
	jp z,@ending_loop_tears

	ldi a, (hl)
	add TEARS_OFFSET_Y
	ld (collision_.p.1.y), a
	ld (collision_.p_RD.1.y), a
	ld a,(hl)
	add TEARS_OFFSET_X
	ld (collision_.p.1.x), a
	ld (collision_.p_RD.1.x), a

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
	call preloaded_collision
	and a
	jp z,@ending_loop_ennemies

; //// DEAL DMG \\\\
	; kill tear
	ld h, d
	ld l, e
	pop de ; the hitting tear
	push hl
	ld h,d
	ld l,e
	xor a
	ld (hl),a ; kill the tear

	; hurt
	call tear_hit_sfx
	pop hl
	ld d, h
	ld e, l
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
	res 7, a
	ld (de), a

	; unlock room
	ld a, (load_map_.mobs)
	dec a
	ld (load_map_.mobs), a
	and a
	jr nz, @@notDead
	ld a, (current_floor_.current_room)
	ld h, a
	ld a, (current_floor_.current_room + 1)
	ld l, a
	inc hl
	inc hl
	ld a, (hl)
	res 3, a
	ld (hl), a
	ld (load_map_.doors), a
	ld a, GAMESTATE_CHANGINGROOM
	jp setGameState
; \\\\ DEAL DMG ////
@@notDead:
	jr @ending_loop_tears

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
	jp nz,@loop_tears
