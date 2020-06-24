display_init:
; /////// LOAD TILES \\\\\\\
	ld b,14*32
	ld de,Tiles
	ld hl,$8000
@ldt:					; while bc != 0
	ld a,(de)
	ldi (hl),a	; *hl <- *de; hl++
	inc de			; de ++
	dec bc ; bc--
	ld a,b
	or c
	jr nz,@ldt		; end while
; \\\\\\\ LOAD TILES ///////

; /////// CLEAR BG \\\\\\\
	ld de,32*32
	ld hl,$9800
@clmap:			; while de != 0
	xor a;
	ldi (hl),a	; *hl <- 0; hl++
	dec de		; de --
	ld a,e
	or d
	jr nz,@clmap	; end while
	; The Z flag can't be used when dec on 16bit reg :(
; \\\\\\\ CLEAR BG ///////

; /////// CLEAR OAM \\\\\\\
	ld hl,$FE00
	ld b,40*4
@clspr:			; while b != 0
	ld (hl),$00	; *hl <- O
	inc l		; hl ++ (no ldi hl or inc hl: bug hardware!)
	dec b		; b --
	jr nz,@clspr	; end while

			; set the background offset to 0
	xor a
	ldh ($42),a
	ldh ($43),a
; \\\\\\\ CLEAR OAM ///////

; /////// LOAD SPRITES \\\\\\\
	ld hl,$FE00

	; [$FE00-$FE04[ = ball [Y, X, sprite num, 0]
	; load the ball sprite
	ld (hl),$80		; ball.y <- 0x80
	inc l
	ld (hl),$80		; ball.x <- 0x80
	inc l
	ld (hl),$02		; ball.tile <- tile[2]
	inc l
	ld (hl),$00		; ball.attribute <- 0
	inc l

; \\\\\\\ LOAD SPRITES ///////

; /////// INIT COLOR PALETTES \\\\\\\
ld a,%11100100	; 11=Black 10=Dark Grey 01=Grey 00=White/trspt
ldh ($47),a	; background palette
ldh ($48),a	; sprite 0 palette
ldh ($49),a	; sprite 1 palette
ld a,%10010011 	; screen on, bg on, tiles at $8000
ldh ($40),a
; \\\\\\\ INIT COLOR PALETTES ///////
