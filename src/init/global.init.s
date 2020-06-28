/*
	states INSTANCEOF state n_states*/

global_init:

	ld hl,global_.blocking_inits

@rock:
; ////// ROCK \\\\\\
	ld a,%11000000	; alive, hurt by bombs, ID 0, size 0
	ldi (hl),a
; \\\\\\ ROCK //////

@void:
; ////// VOID \\\\\\
	ld a,%00001000	; not alive, not hurt by bombs, ID 1; size 0
	ldi (hl),a
; \\\\\\ VOID //////

@hwall:
; ////// horizontal wall \\\\\\
	ld a, %10010010 ; alive, not hurt by bombs, ID 2, size 2
	ldi (hl),a
; \\\\\\ horizontal wall //////

@vwall:
; ////// vertical wall \\\\\\
	ld a, %10011011 ; alive, not hurt by bombs, ID 3, size 3
	ldi (hl),a
; \\\\\\ vertical wall //////

@isaac_init:
	ld hl, global_.isaac
	ld a,$20
	ldi (hl),a; x = 32
	ld a,$40
	ldi (hl),a; y = 64
	ld a,10
	ldi (hl),a; hp = 10
	ld a,1
	ldi (hl),a; dmg = 1
	xor a
	ldi (hl),a
	ldi (hl),a; flags off
	ld a,$10
	ldi (hl),a; range = 16
	ld a,0
	ldi (hl),a; speed = 0
	ld a,%00010000
	ldi (hl),a; tear x=2, tear y=0, a_flag = 0, b_flag = 0
	xor a
	ldi (hl),a; recover=0
	ldi (hl),a; bombs=0
	ld a,%00000011
	ldi (hl),a ; direction : smiling to the camera

	ld b,n_blockings
	ld hl, global_.blockings
@blocking_loop: ; they are no element for now
	ld a, (global_.blocking_inits.2.info)
	ldi (hl), a
	xor a
	ldi (hl), a
	ldi (hl), a
	dec b
	jp nz,@elements_loop

	; tears
	ld hl, global_.issac_tear_pointer
	xor a
	ldi (hl),a	; issac_tear_pointer = 0
	ld hl, global_.isaac_tears
	ld b,n_isaac_tears
@isaac_tears_loop:
	ldi (hl),a ; x = 0
	ldi (hl),a ; y = 0
	ldi (hl),a ; not alive, not upgraded, speed x = 0, speed y = 0
	dec b
	jp nz,@isaac_tears_loop

	ldi (hl),a	; ennemy_tear_pointer = 0
	ld b,n_ennemy_tears
@ennemy_tears_loop:
	ldi (hl),a ; x = 0
	ldi (hl),a ; y = 0
	ldi (hl),a ;  not alive, not upgraded, speed x = 0, speed y = 0
	dec b
	jp nz,@ennemy_tears_loop


	ld hl, global_.enemy_inits

@void_enemy:
	; /// void enemy \\\
	ld a, %00000000 ; not alive, ID 0, size 0
	ldi (hl),a
	xor a
	ldi (hl), a ; no hp
	ldi (hl), a ; void enemy doesn't exist, it can't hurt you
	ld (global_.speeds.1), a ; no speed
	; \\\ void enemy ///

	ld hl, global_.enemies
	ld b, n_enemies
@enemy_loop:
	ld a, (global_.enemy_inits.1.info)
	ldi (hl), a
	xor a
	ldi (hl), a
	ldi (hl), a
	ld a, (global_.enemy_inits.1.hp)
	ldi (hl), a
	xor a
	ldi (hl), a
	ld a, (global_.enemy_inits.1.dmg)
	ldi (hl), a
	dec b
	jp nz, @enemy_loop

	ld hl, global_.object_inits

@void_object:
	; /// void object \\\
	ld a, %00000000 ; not alive, ID 0, size 0
	ldi (hl),a
	xor a
	ldi (hl), a
	ldi (hl), a ; no function
	; \\\ void object ///

	ld hl, global_.objects
	ld b, n_objects
@object_loop:
	ld a, (global_.object_inits.1.info)
	ldi (hl), a
	xor a
	ldi (hl), a
	ldi (hl), a
	ld a, (global_.object_inits.1.function)
	ldi (hl), a
	ld a, (global_.object_inits.1.function + 1)
	ldi (hl), a
	dec b
	jp nz, @object_loop