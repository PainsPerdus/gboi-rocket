displayBackgroundTile:
	push bc
	push de ;Save callee saved registers
	

; ///// Computer top left position in the BG Map \\\\\

; //// Compute X \\\\
	sub 8
	srl a; a=x/2
	srl a; a=x/4
	srl a; a=x/8=X
	ld d,$00
	ld e, a ;load a in a 16 bits register
; \\\\ Compute X ////

; //// Compute 8*Y \\\\
	ld a,b
	sub 16
	ld c,a
	ld b,$00 ; bc now contains y = 8*Y
; \\\\ Compute 8*Y ////

	//First we save the tile id argument that's in l before touching hl
	ld a,l

	//We can now compute the top left position
	ld hl,$9800
	add hl, de ;hl+=X
	add hl, bc ;hl+=8*Y
	add hl, bc ;hl+=8*Y
	add hl, bc ;hl+=8*Y
	add hl, bc ;hl+=8*Y
	//hl now contains the top left rock position in the BG Map

; \\\\\ Computer top left rock position /////

; ///// Set the 4 tiles \\\\\
	//First tile
	ldi (hl), a
	//Second tile
	inc a
	ld (hl), a 
	//Third tile
	ld bc, 31
	add hl,bc
	inc a
	ldi (hl), a
	//Fourth tile
	inc a
	ld (hl), a 

; \\\\\ Set the 4 tiles /////

	pop de
	pop bc ;Restore callee saved registers
	ret
