/*
	states INSTANCEOF state n_states*/

global_init:
	ld hl,global_.sheets
	ld b,n_sheets

; ////// ROCK \\\\\\
	ld a,%10010000	; size = 0, block, hurt by bombs.
	ldi (hl),a
	ld a,0	; dmg = 0
	ldi (hl),a
	ld a,0
	ldi (hl),a
	ldi (hl),a ; no funtion pointer or whatever
	ldi (hl),a ; speed = 0
	ld a,0
	ldi (hl),a ; 0 HP
; \\\\\\ ROCK //////

; ////// VOID \\\\\\
	ld a,%00010000	; size = 0, block, hurt by bombs.
	ldi (hl),a
	ld a,0	; dmg = 0
	ldi (hl),a
	ld a,0
	ldi (hl),a
	ldi (hl),a ; no funtion pointer or whatever
	ldi (hl),a ; speed = 0, that a rock, duh
	ld a,1
	ldi (hl),a ; a rock has 1 HP
; \\\\\\ VOID //////


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

	ld b,n_elements
	ld de,global_.states
@elements_loop: ; they are no element for now
	xor a
	ldi (hl),a ; hp = 0
	ldi (hl),a ; x = 0
	ldi (hl),a ; y = 0
	ldi (hl),a ; sheet = 0
	ld a,0
	ldi (hl),a ; speed x = 0, speed y = 0
	ld a,d
	ldi (hl),a
	ld a,e
	ldi (hl),a ; state
	inc de
	dec b
	jp nz,@elements_loop

	; tears
	xor a
	ldi (hl),a	; issac_tear_pointer = 0
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

	ld b,n_states
@states_loop:
	ldi (hl),a ; placeholder = O (they are no element for now)
	dec b
	jp nz,@states_loop
