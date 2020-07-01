; /// load the arrays with void elements \\\
    ld b, n_blockings - 4
    ld a, (global_.blockings)
    ld h, a
    ld a, (global_.blockings + 1)
    ld l, a
@resetBlockingLoop:
    ld (hl), VOID_INFO
    ld de, _sizeof_blocking
    add hl, de
    dec b
    jr nz, @resetBlockingLoop

    ld b, n_enemies
    ld a, (global_.enemies)
    ld h, a
    ld a, (global_.enemies + 1)
    ld l, a
@resetEnemyLoop:
    ld (hl), VOID_ENEMY_INFO
    ld de, _sizeof_enemy
    add hl, de
    dec b
    jr nz, @resetEnemyLoop

    ld b, n_objects
    ld a, (global_.objects)
    ld h, a
    ld a, (global_.objects + 1)
    ld l, a
@resetObjectLoop:
    ld (hl), VOID_OBJECT_INFO
    ld de, _sizeof_object
    add hl, de
    dec b
    jr nz, @resetObjectLoop
; \\\ load the arrays with void elements ///