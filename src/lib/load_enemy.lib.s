; /// add an enemy \\\
    ld a, (load_room_.next_to_load)
    ld l, a
    ld a, (load_room_.next_to_load + 1)
    ld h, a
    ldi a, (hl)
    ld e, a
    ld a, l
    ld (load_room_.next_to_load), a
    ld a, h
    ld (load_room_.next_to_load + 1), a

    ld a, (load_room_.next_enemy)
    ld l, a
    ld a, (load_room_.next_enemy + 1)
    ld h, a

    ; void enemy
    ld a, e
    cp 0
    jr nz, @@notVoid
    ld a, VOID_ENEMY_INFO
    ldi (hl), a
    ld a, b
    ldi (hl), a
    ld a, c
    ldi (hl), a
    ld a, VOID_ENEMY_HP
    ldi (hl), a
	xor a
	ldi (hl), a
    ld a, VOID_ENEMY_DMG
    ldi (hl), a
    ld a, VOID_ENEMY_SPEED_FREQ
    ldi (hl), a
    ldi (hl), a
    jp @@end_enemy
@@notVoid:

    ; hurting rock
    cp 1
    jr nz, @@notHurtingRock
    ld a, HURTING_ROCK_INFO
    ldi (hl), a
    ld a, b
    ldi (hl), a
    ld a, c
    ldi (hl), a
    ld a, HURTING_ROCK_HP
    ldi (hl), a
	xor a
	ldi (hl), a
    ld a, HURTING_ROCK_DMG
    ldi (hl), a
    ld a, HURTING_ROCK_SPEED_FREQ
    ldi (hl), a
    ldi (hl), a
    jp @@end_enemy
@@notHurtingRock:

    ; fly
    cp 2
    jr nz, @@notFly
    ld a, FLY_INFO
    ldi (hl), a
    ld a, b
    ldi (hl), a
    ld a, c
    ldi (hl), a
    ld a, FLY_HP
    ldi (hl), a
    xor a
    ldi (hl), a
    ld a, FLY_DMG
    ldi (hl), a
    ld a, FLY_SPEED_FREQ
    ldi (hl), a
    ldi (hl), a
    jp @@end_enemy
@@notFly:

@@end_enemy:
    ld a, l
    ld (load_room_.next_enemy), a
    ld a, h
    ld (load_room_.next_enemy + 1), a

    ld hl, load_room_.mob_number
    inc (hl)
; \\\ add an enemy ///
