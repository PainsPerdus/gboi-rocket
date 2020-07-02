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
	ld a,(global_.isaac.y)
	add ISAAC_OFFSET_Y_FEET
	ld (collision_.p.1.y),a
	add ISAAC_HITBOX_Y_FEET
	ld (collision_.p_RD.1.y),a
	ld a,(global_.isaac.x)
	add ISAAC_OFFSET_X
	ld (collision_.p.1.x),a
	add ISAAC_HITBOX_X
	ld (collision_.p_RD.1.x),a
;   \\\\ collision Y  init ////
	call preloaded_collision_obstacles
	; //// CANCEL MOUVEMENT \\\\
	and a
	jr z, @@noCollision
	ld a,(global_.isaac.y)
	sub b
	ld (global_.isaac.y),a ; isaac.y -= speed y
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
	ld a,(global_.isaac.y)
	add ISAAC_OFFSET_Y_FEET
	ld (collision_.p.1.y),a
	add ISAAC_HITBOX_Y_FEET
	ld (collision_.p_RD.1.y),a
	ld a,(global_.isaac.x)
	add ISAAC_OFFSET_X
	ld (collision_.p.1.x),a
	add ISAAC_HITBOX_X
	ld (collision_.p_RD.1.x),a
;   \\\\ collision X  init ////
	call preloaded_collision_obstacles
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

; /////// FIRE BULLETS \\\\\\\
@fire_bullet:
	ld hl,global_.isaac.cooldown
	dec (hl)
	jr nz,@@no_fire
	ld a,ISAAC_COOLDOWN
	ld (global_.isaac.cooldown),a
	ld a,(global_.isaac.tears)
	bit ISAAC_A_FLAG, a
	jr z,@@no_fire
	ld hl,global_.isaac_tears
	ld a,(global_.issac_tear_pointer)
	ld d,0
	ld e,a
	add hl,de
	add _sizeof_tear
	cp n_isaac_tears*_sizeof_tear
	jr nz,@@no_pointer_overflow
	xor a
@@no_pointer_overflow:
	ld (global_.issac_tear_pointer),a
	ld a,(global_.isaac.y)
	add ISAAC_Y_CENTER
	ldi (hl),a
	ld a,(global_.isaac.x)
	add ISAAC_X_CENTER
	ldi (hl),a
	inc hl
	ld a,(global_.isaac.direction)
	and DIRECTION_MASK
	cp ORIENTATION_LF
	jr nz,@@not_left
	ld (hl),DIRECTION_LF
	jr @@no_fire
@@not_left:
	cp ORIENTATION_RG
	jr nz,@@not_right
	ld (hl),DIRECTION_RG
	jr @@no_fire
@@not_right:
	cp ORIENTATION_UP
	jr nz,@@not_up
	ld (hl),DIRECTION_UP
	jr @@no_fire
@@not_up:
	cp ORIENTATION_DW
	jr nz,@@not_down
	ld (hl),DIRECTION_DW
	jr @@no_fire
@@not_down:
	cp ORIENTATION_LF
	jr nz,@@not_left


@@no_fire:

; \\\\\\\ FIRE BULLETS ///////
