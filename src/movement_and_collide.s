.DEFINE ISAAC_HITBOX 3
.DEFINE ISAAC_FEET_HITBOX 4
.DEFINE RECOVERY_TIME 30

test_vectorisation:
	ld a,(global_.isaac.speed)
	and a
	jp nz,move_and_collide

	ld a,(global_.isaac.x)
	ld (vectorisation_.p.1.x),a
	ld a,(global_.isaac.y)
	ld (vectorisation_.p.1.y),a
	ld a,$50
	ld (vectorisation_.p.2.x),a
	ld a,$50
	ld (vectorisation_.p.2.y),a

	call vectorisation
	ld (global_.isaac.speed),a

move_and_collide:

@y:
; //////// MOVE ISAAC  Y \\\\\\\
	ld a,(global_.isaac.speed)
	and %00001111
	bit $3,a
	jr z,@@posit
	or %11110000
@@posit:
	ld b,a									; B = SPEED Y
	ld hl,global_.isaac.y
	add (hl)
	ld (hl),a								; y += speed y


;   //// collision Y  init \\\\
	ld a, (global_.isaac.x)
	ld (collision_.p.1.x), a
	ld a, (global_.isaac.y)
	add $08
	ld (collision_.p.1.y), a
	ld a, ISAAC_FEET_HITBOX
	ld (collision_.hitbox1), a
;   \\\\ collision Y  init ////

;   //// collision Y  loop \\\\
	ld de, global_.blockings
	ld c, n_blockings
	@@loop:
; /// loop start \\\
	ld h,d
	ld l,e

; / set hitbox and position as parameter \
	ldi a, (hl)
	bit ALIVE_FLAG, a
	jr z,@@noCollision ; check if element is alive
	and BLOCKING_SIZE_MASK
	ld (collision_.hitbox2), a
	ldi a, (hl)
	ld (collision_.p.2.x), a
	ld a, (hl)
	ld (collision_.p.2.y), a
; \ set hitbox and position as parameter /

; / test collision \
	call collision
	and a
	jr z, @@noCollision
	ld a,(global_.isaac.y)
	sub b
	ld (global_.isaac.y),a ; isaac.y -= speed y
	add $08
	ld (collision_.p.1.y),a
	ld a,(global_.isaac.speed)
	and %11110000
	ld b,0
	ld (global_.isaac.speed),a ; speed y = 0
@@noCollision:
; \ test collision /

@@ending_loop:
	inc de
	inc de
	inc de
	dec c
	jr nz, @@loop
;   \\\\ collision Y  loop ////
; \\\\\\\ MOVE ISAAC  Y ////////



@x:
; //////// MOVE ISAAC  X \\\\\\\
	ld a,(global_.isaac.speed)
	and %11110000
	swap a
	bit $3,a
	jp z,@@posit
	or %11110000
@@posit:
	ld b,a									; B = SPEED X
	ld hl,global_.isaac.x
	add (hl)
	ld (hl),a								; x += speed x

;   //// collision X  init \\\\
	ld a, (global_.isaac.x)
	ld (collision_.p.1.x), a
;   \\\\ collision X  init ////

;   //// collision X  loop \\\\
	ld de, global_.blockings
	ld c, n_blockings
	@@loop:
; /// loop start \\\
	ld h,d
	ld l,e

; / set hitbox and position as parameter \
	ldi a, (hl)
	bit ALIVE_FLAG, a
	jr z,@@noCollision ; check if element is alive
	and BLOCKING_SIZE_MASK
	ld (collision_.hitbox2), a
	ldi a, (hl)
	ld (collision_.p.2.x), a
	ld a, (hl)
	ld (collision_.p.2.y), a
; \ set hitbox and position as parameter /

; / test collision \
	call collision
	and a
	jr z, @@noCollision
	ld a,(global_.isaac.x)
	sub b
	ld (global_.isaac.x),a ; isaac.x -= speed x
	ld (collision_.p.1.x),a
	ld a,(global_.isaac.speed)
	and %00001111
	ld b,0
	ld (global_.isaac.speed),a ; speed x = 0
@@noCollision:
; \ test collision /

@@ending_loop:
	inc de
	inc de
	inc de
	dec c
	jr nz, @@loop
;   \\\\ collision X  loop ////
; \\\\\\\ MOVE ISAAC  X ////////


@enemies_collide:
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
	jp nz, @@noEnemyCollisions
; /////// implement enemy damage \\\\\\\
;   //// collision with enemies loop \\\\
	ld de, global_.enemies
	ld c, n_enemies
	@@loop:
; /// loop start \\\
	ld h,d
	ld l,e

; / set hitbox and position as parameter \
	ldi a, (hl)
	bit ALIVE_FLAG, a
	jr z,@@noCollision ; check if element is alive
	and ENEMY_SIZE_MASK
	ld (collision_.hitbox2), a
	ldi a, (hl)
	ld (collision_.p.2.x), a
	ldi a, (hl)
	ld (collision_.p.2.y), a
; \ set hitbox and position as parameter /

; / test collision \
	push hl
	call collision
	pop hl
	and a
	jr z, @@noCollision

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
	jr z, @@noDeath
	xor a
	ld (global_.isaac.x), a
	ld (global_.isaac.y), a 	; //// TODO implement death
@@noDeath:
	jr @@damageDone

@@noCollision:
; \ test collision /

@@ending_loop:
	ld hl, 6
	add hl, de
	ld d,h
	ld e,l
	dec c
	jr nz, @@loop
	jr @@damageDone
;   \\\\ collision with enemies loop ////
@@noEnemyCollisions:
	dec a
	ld (global_.isaac.recover), a
@@damageDone:
; \\\\\\\ implement enemy damage ///////

; //////// TEST A B \\\\\\\
; if A / B are pressed
;	ld hl, global_.isaac.tears
;	bit $7,(hl); flag A set
;	jr z,@Aset
;	ld a,$10
;	ld (global_.isaac.x),a
;	ld (global_.isaac.y),a
;@Aset:
;
;	bit $6,(hl); flag B set
;	jr z,@Bset
;	ld a,$90
;	ld (global_.isaac.x),a
;	ld (global_.isaac.y),a
;@Bset:
; \\\\\\\ TEST A B ////////
