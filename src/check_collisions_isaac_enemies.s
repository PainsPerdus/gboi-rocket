enemies_collide:
	; /// load Isaac true position and hitbox \\\
	ld a, (global_.isaac.x)
	ld (collision_.p.1.x), a
	ld a, (global_.isaac.y)
	ld (collision_.p.1.y), a
	ld a, ISAAC_HITBOX
	ld (collision_.hitbox1), a
	; \\\ load Isaac true position and hitbox ///

	ld a, (global_.isaac.recover)
	and a
	jp nz, @noEnemyCollisions
; /////// implement enemy damage \\\\\\\
;   //// collision with enemies loop \\\\
	ld de, global_.enemies
	ld c, n_enemies
	@loop:
; /// loop start \\\
	ld h,d
	ld l,e

; / set hitbox and position as parameter \
	ldi a, (hl)
	bit ALIVE_FLAG, a
	jr z,@noCollision ; check if element is alive
	and ENEMY_SIZE_MASK
	ld (collision_.hitbox2), a
	ldi a, (hl)
	ld (collision_.p.2.y), a
	ldi a, (hl)
	ld (collision_.p.2.x), a
; \ set hitbox and position as parameter /

; / test collision \
	push hl
	call collision
	pop hl
	and a
	jr z, @noCollision

; / Knockback \
	ld a,(collision_.p.2.y)
	ld (vectorisation_.p.1.y),a
	ld a,(collision_.p.2.x)
	ld (vectorisation_.p.1.x),a
	ld a,(global_.isaac.y)
	add ISAAC_Y_CENTER-2
	ld (vectorisation_.p.2.y),a
	ld a,(global_.isaac.x)
	add ISAAC_X_CENTER-2
	ld (vectorisation_.p.2.x),a

	call vectorisation
	ld b,a
	push hl
	call knockback
	pop hl
; \ Knockback /

	; revcovery
	ld a, RECOVERY_TIME
	ld (global_.isaac.recover), a
	; damage
	inc hl
	inc hl
	ld a, (hl)
	and DMG_MASK
	ld b, a
	ld a, (global_.isaac.hp)
	sub b
	ld (global_.isaac.hp), a
	bit 7, a
	jr z, @noDeath
	xor a
	ld (global_.isaac.x), a
	ld (global_.isaac.y), a 	; //// TODO implement death
@noDeath:
	jr @damageDone

@noCollision:
; \ test collision /

@ending_loop:
	ld hl, _sizeof_enemy
	add hl, de
	ld d,h
	ld e,l
	dec c
	jr nz, @loop
	jr @damageDone
;   \\\\ collision with enemies loop ////
@noEnemyCollisions:
	dec a
	ld (global_.isaac.recover), a
@damageDone:
; \\\\\\\ implement enemy damage ///////
