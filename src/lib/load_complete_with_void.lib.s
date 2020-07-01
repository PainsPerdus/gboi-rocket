; /// load the arrays with void elements \\\
    ld b, n_blockings - 4
	ld hl, global_.blockings
@resetBlockingLoop:
    ld (hl), VOID_INFO
    ld de, _sizeof_blocking
    add hl, de
    dec b
    jr nz, @resetBlockingLoop

    ld b, n_enemies
	ld hl, global_.enemies
@resetEnemyLoop:
    ld (hl), VOID_ENEMY_INFO
    ld de, _sizeof_enemy
    add hl, de
    dec b
    jr nz, @resetEnemyLoop

    ld b, n_objects
	/* OMG THIS WAS A HUGE BUG THX GOD ITS FIXED
    ld a, (global_.objects)
    ld h, a
    ld a, (global_.objects + 1)
    ld l, a
	*/
	ld hl, global_.objects
@resetObjectLoop:
    ld (hl), VOID_OBJECT_INFO
    ld de, _sizeof_object
    add hl, de
    dec b
    jr nz, @resetObjectLoop
; \\\ load the arrays with void elements ///
