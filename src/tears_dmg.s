
isaac_tears_dmg:
	ld de,global_.isaac_tears

	ld c,n_isaac_tears
@loop_tears:
	ld h,d  ; tear ptr to hl
	ld l,e
	ld a,(hl)  ; tear to a
	and a  ; tear is not none ?
	jp z,@ending_loop_tears  ; if none continue

	ldi a, (hl)  ; load y tear
	add TEARS_OFFSET_Y
	ld (collision_.p.1.y), a
	ld (collision_.p_RD.1.y), a
	ld a,(hl)  ; load x tear
	add TEARS_OFFSET_X
	ld (collision_.p.1.x), a
	ld (collision_.p_RD.1.x), a

	push de  ; push tear ptr
	ld de,global_.enemies
	ld b,n_enemies
@loop_ennemies:
	ld h,d  ; ennemy ptr to hl
	ld l,e
	ldi a,(hl) ; ennemy info to a
	bit ALIVE_FLAG, a  ; is alive ?
	jr z,@ending_loop_ennemies  ; if not continue
	and ENEMY_SIZE_MASK  ; ennemy size to a
	ld (collision_.hitbox2),a
	ldi a,(hl)  ; load ennemy y
	ld (collision_.p.2.y),a
	ldi a,(hl)  ; load ennemy x
	ld (collision_.p.2.x),a
	call preloaded_collision
	and a  ; collison ?
	jp z,@ending_loop_ennemies  ; if not continue

; //// DEAL DMG \\\\
	; kill tear
    ; TODO: this is needlessly complicated ?
	ld h, d  ; ennemy ptr to hl
	ld l, e
	pop de  ; pop tear ptr TODO: make sure of that
	push hl  ; push ennemy ptr
	ld h,d  ; tear ptr to hl
	ld l,e
	xor a
	ld (hl),a  ; tear becomes none

	; hurt
	call tear_hit_sfx
	pop hl  ; pop ennemy ptr
	ld d, h  ; ennemy ptr to de
	ld e, l
	ld hl,3  ; TODO: remove hardcoded value
	add hl,de  ; ennemy hp ptr to hl
	ld a, (hl)  ; ennemy hp to a
	ld hl, global_.isaac.dmg  ; load dmg
	sub (hl)  ; inflict dmg
	ld hl,3  ; TODO: remove hardcoded value
	add hl, de  ; ennemy hp ptr to hl
	ld (hl), a  ; new hp to hp ptr
	cp 1  ; TODO: check if that works
	jp nc, @@notDead
	ld a, (de)  ; ennemy info to a
	res 7, a  ; reset isAlive bit TODO: remove hardcoded
	ld (de), a  ; write new ennemy info

	; unlock room
	ld a, (load_map_.mobs)  ; reduce mob number
	dec a
	ld (load_map_.mobs), a
	and a  ; check of mob number is 0
	jr nz, @@notDead
	ld a, (current_floor_.current_room)  ; room ptr to hl
	ld h, a
	ld a, (current_floor_.current_room + 1)
	ld l, a
	inc hl  ; room info ptr to hl
	inc hl
	ld a, (hl)  ; room info to a
	res 3, a  ; open room ? TODO: remove hardcoded
	ld (hl), a  ; write new room info
	ld (load_map_.doors), a  ; also update in loaded representation
	ld a, GAMESTATE_CHANGINGROOM  ; update room
	jp setGameState
; \\\\ DEAL DMG ////
@@notDead:
	jr @ending_loop_tears

@ending_loop_ennemies:
	ld hl,_sizeof_enemy
	add hl,de  ; next ennemy ptr to hl
	ld d,h  ; new ennemy ptr to de
	ld e,l

	dec b  ; check if some ennemies are left
	jr nz,@loop_ennemies
	pop de  ; leaving loop ennemies, restore tear ptr
@ending_loop_tears:
	ld hl,_sizeof_tear
	add hl,de  ; next tear ptr to hl
	ld d,h  ; new tear ptr to de
	ld e,l

	dec c  ; check if some tears are left
	jp nz,@loop_tears
