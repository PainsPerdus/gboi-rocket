display_init:

; /////// INITIALIZE VARIABLES \\\\\\\
xor a
ld (display_.isaac.frame),a
ld (display_.isaac.shoot_timer),a
ld (display_.isaac.walk_timer),a
ld (display_.fly.frame),a

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

; /////// CLEARING ROOM \\\\\\\

;call displayRoom

; \\\\\\\ CLEARING ROOM ///////

; /////// DRAWING DOORS \\\\\\\

	ld a, %00000101
	ld b, %00000000
	call displayDoors

; \\\\\\\ DRAWING DOORS ///////

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

; // ISAAC SPRITES \\
; \\ ISAAC SPRITES //

; // SETUP ISAAC TEARS SPRITES \\
	ld hl, OAM_ISAAC_TEARS
	ld b, OAM_ISAAC_TEARS_SIZE
	ld a,10 ;initial posX
@loopSetupIsaacTears
	ld (hl), 50 ;posY
	inc l
	ld (hl), a
	inc l
	ld (hl), TEAR_SPRITESHEET
	inc l
	ld (hl), $00 ;Flags
	inc l
	add 10 ;add to X pos
	dec b
	jp nz,@loopSetupIsaacTears 
; \\ SETUP ISAAC TEARS SPRITES //

;.INCLUDE "init/display_test.init.s"

; \\\\\\\ LOAD SPRITES ///////

; /////// SETUP TEARS HBLANK OPCODE \\\\\\\
ld bc, OAM_ISAAC_TEARS ;OAM position of isaac bullets

ld hl, DISPLAY_RAM_OPCODE_START ; Start OAM critical section
ld (hl), $00 ; NOP
/*ld (hl), $21  ; ld hl, NNnn
inc l
ld (hl), c  ; nn //Tear sprite Y pos address in OAM low byte
inc l
ld (hl), b  ; NN //Tear sprite Y pos address in OAM high byte
inc l
ld (hl), $36  ; ld (hl), yy 
inc l
ld (hl), $35   ; yy //Tear new Y position
inc l
ld (hl), $2E  ; ld l, nn+1 (trick to inc l without changing flags)
inc l
inc c
ld (hl), c  ; nn+1 //Tear sprite X pos address in OAM low byte
inc l
ld (hl), $36  ; ld(hl), xx
inc l
ld (hl), $20   ; xx //Tear new X position*/
inc l ; Out of OAM critical section
ld (hl), $E1 ; pop hl
inc l ; We can do inc l instead of inc hl because we only have $00FF bytes avaliable
ld (hl), $D9 ; reti

; \\\\\\\ SETUP TEARS HBLANK OPCODE ///////


; /////// INIT COLOR PALETTES \\\\\\\
ld a,%11100100	; 11=Black 10=Dark Grey 01=Grey 00=White/trspt
ldh ($47),a	; background palette
ldh ($48),a	; sprite 0 palette
ldh ($49),a	; sprite 1 palette
; \\\\\\\ INIT COLOR PALETTES ///////

; ; /////// ENABLE SCREEN \\\\\\\
; ld a,%10000011 	; screen on, bg on, tiles at $8000
; ldh ($40),a
; ; \\\\\\\ ENABLE SCREEN ///////
