display_init:

; /////// INITIALIZE VARIABLES \\\\\\\
xor a
ld (display_.isaac.frame),a
ld (display_.isaac.shoot_timer),a
ld (display_.isaac.walk_timer),a

; \\\\\\\ INITIALIZE VARIABLES ///////

; /////// LOAD TILES \\\\\\\
	ld bc,14*32
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

; // ISAAC SPRITES \\
/* This is not needed because we update all the sprites in display.s
ld a, $39;(global_.isaac.y)
ld b, a
ld a, $40;(global_.isaac.x)
ld c, a
//top left
ld a,b 
ld (hl), a ;PosY
inc l
ld a,c 
ld (hl), a ;PosX
inc l
ld (hl), ISAAC_TOP_LEFT + 1 ;First isaac standing sprite
inc l
ld (hl), $00 ;Flags
inc l
//top right
ld a,b
ld (hl), a ;PosY
inc l
ld a,c
add 8
ld (hl), a ; PosX
inc l
ld (hl), ISAAC_TOP_RIGHT + 1 ;Second isaac standing sprite
inc l
ld (hl), $00 ;Flags
inc l
//bottom left
ld a,b
add 8
ld (hl), a ;PosY
inc l
ld a,c
ld (hl), a ;PosX
inc l
ld (hl), ISAAC_BOTTOM_LEFT_STAND + 1;Third isaac standing sprite
inc l
ld (hl), $00 ;Flags
inc l
//bottom right
ld a,b
add 8
ld (hl), a ;PosY
inc l
ld a,c
add 8
ld (hl), a ;PosX
inc l
ld (hl), ISAAC_BOTTOM_RIGHT_STAND +1 ;Fourth isaac standing sprite
inc l
ld (hl), $00 ;Flags
*/
; \\ ISAAC SPRITES //

; \\\\\\\ LOAD SPRITES ///////

; /////// INIT COLOR PALETTES \\\\\\\
ld a,%11100100	; 11=Black 10=Dark Grey 01=Grey 00=White/trspt
ldh ($47),a	; background palette
ldh ($48),a	; sprite 0 palette
ldh ($49),a	; sprite 1 palette
; \\\\\\\ INIT COLOR PALETTES ///////

; /////// ENABLE SCREEN \\\\\\\
ld a,%10010011 	; screen on, bg on, tiles at $8000
ldh ($40),a
; \\\\\\\ ENABLE SCREEN ///////
