display_init:

; /////// INITIALIZE VARIABLES \\\\\\\
xor a
ld (display_.isaac.frame),a
ld (display_.isaac.shoot_timer),a
ld (display_.isaac.walk_timer),a

; \\\\\\\ INITIALIZE VARIABLES ///////


; /////// LOAD TILES \\\\\\\

; ///// Sprite Tiles \\\\\
	ld bc,(SPRITE_TILES_NUMBER+1)*16
	ld de,SpriteTiles
	ld hl,SPRITE_TILES_START_ADDRESS
@loopSpriteTiles: ; while bc != 0
	ld a,(de)
	ldi (hl),a	; *hl <- *de; hl++
	inc de			; de ++
	dec bc ; bc--
	ld a,b
	or c
	jr nz,@loopSpriteTiles	; end while
; \\\\\ Sprite Tiles /////

; ///// Background Tiles \\\\\
	ld bc,(BACKGROUND_TILES_NUMBER+1)*16
	ld de,BackgroundTiles
	ld hl,BACKGROUND_TILES_START_ADDRESS
@loopBackgroundTiles: ; while bc != 0
	ld a,(de)
	ldi (hl),a	; *hl <- *de; hl++
	inc de			; de ++
	dec bc ; bc--
	ld a,b
	or c
	jr nz,@loopBackgroundTiles	; end while
; \\\\\ Background Tiles /////

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
; \\ ISAAC SPRITES //


//TODO : Document this part
; // SETUP BULLET SPRITES \\
	ld hl, OAM_ISAAC_BULLETS
	ld b, OAM_ISAAC_BULLETS_SIZE+1
	ld a,10 ;initial posX
@loopSetupIsaacBullets
	ld (hl), 30
	inc l
	ld (hl), a
	inc l
	ld (hl), TEAR_SPRITESHEET
	inc l
	ld (hl), $00 ;Flags
	inc l
	add 10 ;add to X pos
	dec b
	jp nz,@loopSetupIsaacBullets 
; \\ SETUP BULLET SPRITES //

.INCLUDE "init/display_test.init.s"

; \\\\\\\ LOAD SPRITES ///////

; /////// SETUP BULLET HBLANK OPCODE \\\\\\\



; \\\\\\\ SETUP BULLET HBLANK OPCODE ///////


; /////// INIT COLOR PALETTES \\\\\\\
ld a,%11100100	; 11=Black 10=Dark Grey 01=Grey 00=White/trspt
ldh ($47),a	; background palette
ldh ($48),a	; sprite 0 palette
ldh ($49),a	; sprite 1 palette
; \\\\\\\ INIT COLOR PALETTES ///////

; /////// ENABLE SCREEN \\\\\\\
ld a,%10000011 	; screen on, bg on, tiles at $8000
ldh ($40),a
; \\\\\\\ ENABLE SCREEN ///////
