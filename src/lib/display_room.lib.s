displayRoom:
	push bc
	push de ;Save callee saved registers
	
	ld d, a ; doors positions
	ld e, b	; doors status (opened/closed)
	
	
; ///// CLEAR ROOM \\\\\
	ld d, 14
	ld e, 16                ; loop iterators
	ld b, $00
	ld hl,$9842
@clear_line:			; while de != 0
	ld (hl),b	 
	inc hl
	dec e		        ; e --
	jr nz,@clear_line       ; end while
	ld a,d
	ld d,$00
	ld e, 16                ; loop iterator
	add hl, de
	dec a
	ld d,a                  ; d --
	jr nz,@clear_line
	
; \\\\\ CLEAR ROOM /////

	pop de
	pop bc ;Restore callee saved registers
	ret