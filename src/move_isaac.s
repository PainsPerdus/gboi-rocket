move_and_collide:

	ld hl,global_.isaac.lagCounter
	dec (hl)
	jp nz,@no_move
	ld a,(global_.isaac.speedFreq)
	ld (global_.isaac.lagCounter),a

	ld a,(global_.isaac.speed)
	and MASK_4_LSB
	jr z,@no_diag_move
	ld a,(global_.isaac.speed)
	and MASK_4_MSB
	jr z,@no_diag_move

	ld a,(global_.isaac.speedFreq)
	bit 1,a
	jp nz,@multiple_of_2
	inc a
@multiple_of_2:
	srl a
	add (hl)
	ld (global_.isaac.lagCounter),a
@no_diag_move:


@y:
; //////// MOVE ISAAC  Y \\\\\\\
	ld a,(global_.isaac.speed)
	and MASK_4_LSB
	bit $3,a
	jr z,@@posit
	or MASK_4_MSB
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
	call collision_obstacles
	xor a ;TODO DISABLE COLLISIONS
	; //// CANCEL MOUVEMENT \\\\
	and a
	jr z, @@noCollision
	ld a,(global_.isaac.y)
	sub b
	ld (global_.isaac.y),a ; isaac.y -= speed y
	add $08
	ld (collision_.p.1.y),a
	ld a,(global_.isaac.speed)
	and MASK_4_MSB
	ld (global_.isaac.speed),a ; speed y = 0
	; \\\\ CANCEL MOUVEMENT ////
@@noCollision:
; \\\\\\\ MOVE ISAAC  Y ////////

@x:
; //////// MOVE ISAAC  X \\\\\\\
	ld a,(global_.isaac.speed)
	and MASK_4_MSB
	swap a
	bit $3,a
	jp z,@@posit
	or MASK_4_MSB
@@posit:
	ld b,a									; B = SPEED X
	ld hl,global_.isaac.x
	add (hl)
	ld (hl),a								; x += speed x

;   //// collision X  init \\\\
	ld a, (global_.isaac.x)
	ld (collision_.p.1.x), a
;   \\\\ collision X  init ////
	call collision_obstacles
	xor a ; // TODO DISABLE COLLISIONS
	; //// CANCEL MOUVEMENT \\\\
	and a
	jr z, @@noCollision
	ld a,(global_.isaac.x)
	sub b
	ld (global_.isaac.x),a ; isaac.x -= speed x
	ld a,(global_.isaac.speed)
	and MASK_4_LSB
	ld (global_.isaac.speed),a ; speed y = 0
	; \\\\ CANCEL MOUVEMENT ////
	@@noCollision:
; \\\\\\\ MOVE ISAAC  X ////////
@no_move:
