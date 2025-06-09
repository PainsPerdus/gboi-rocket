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
    jr nz, @@not_void
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
@@not_void:

    ; spikes
    cp SPIKES_ID
    jr nz, @@not_spikes
    ld a, SPIKES_INFO
    ldi (hl), a
    ld a, b
    ldi (hl), a
    ld a, c
    ldi (hl), a
    ld a, SPIKES_HP
    ldi (hl), a
	xor a
	ldi (hl), a
    ld a, SPIKES_DMG
    ldi (hl), a
    ld a, SPIKES_SPEED_FREQ
    ldi (hl), a
    ldi (hl), a
    jp @@end_enemy
@@not_spikes:

    ; fly
    cp FLY_ID
    jr nz, @@not_fly
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
@@not_fly:

@@end_enemy:
    ld a, l
    ld (load_room_.next_enemy), a
    ld a, h
    ld (load_room_.next_enemy + 1), a

    ld hl, load_room_.mob_number
    inc (hl)
; \\\ add an enemy ///
