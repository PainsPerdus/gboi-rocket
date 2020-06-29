displayDoors:
	push bc
	push de ;Save callee saved registers
	
	ld d, a ; doors positions
	ld e, b	; doors status (opened/closed)
	
	
	bit 0, d
	jp z, @no_up_door	

	ld a, UP_DOOR
	ld hl, $9808
	ld (hl),a
	inc a
	ld hl, $980B
	ld (hl),a
	ld hl, $9809
	add e
	inc a
	ldi (hl),a
	add 2
	ldi (hl),a
	ld hl, $9829
	add 2
	ldi (hl),a
	add 2
	ldi (hl),a
	
	@no_up_door:
	bit 1,d
	jp z, @no_left_door	

	ld a, LEFT_DOOR
	ld hl, $98E0
	ld (hl),a
	inc a
	add e
	ld hl, $9900
	ldi (hl),a
	add 2
	ld (hl),a
	ld hl, $9920
	add 2
	ldi (hl),a
	add 2
	ldi (hl),a
	ld hl, $9940
	add 2
	sub e
	ldi (hl),a
	
	@no_left_door:

	bit 2, d
	jp z, @no_right_door	

	ld a, RIGHT_DOOR
	ld hl, $98F3
	ld (hl),a
	inc a
	add e
	ld hl, $9912
	ldi (hl),a
	add 2
	ld (hl),a
	ld hl, $9932
	add 2
	ldi (hl),a
	add 2
	ldi (hl),a
	ld hl, $9953
	add 2
	sub e
	ldi (hl),a
	
	@no_right_door:
	bit 3, d
	jp z, @no_down_door	

	ld a, DOWN_DOOR
	add e
	ld hl, $9A09
	ldi (hl), a
	add 2
	ld (hl), a
	add 2
	ld hl, $9A29
	ldi (hl), a
	add 2
	ld (hl), a
	add 2
	sub e
	ld hl, $9A28
	ld (hl), a
	inc a
	ld hl, $9A2B
	ld (hl), a
	

	
	@no_down_door:

	pop de
	pop bc ;Restore callee saved registers
	ret