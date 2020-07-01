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

; /////// DRAWING WALLS \\\\\\\
;    ///// UPPER WALL \\\\\
	
	ld de,20       ; loop iterator
	ld hl,$9800
	@wall_up_line1:			; while de != 0
	ld a, FLAT_BACKGROUND_WALL
	ldi (hl),a	 
	dec de		; de --
	ld a,e
	or d
	jr nz,@wall_up_line1	; end while
	ld bc, $000C   ; next line distance
	add hl, bc                      ;next line
	ld a, FLAT_BACKGROUND_WALL ;
	ldi (hl),a
	ld a, UP_RIGHT_CORNER ;
	ldi (hl),a
	ld de,16
	@wall_up_line2:			; while de != 0
	ld a, UP_BACKGROUND_WALL ;
	ldi (hl),a
	dec de	; de --
	ld a,e
	or d
	jr nz,@wall_up_line2	; end while
	ld a, UP_LEFT_CORNER ;
	ldi (hl),a
	ld a, FLAT_BACKGROUND_WALL ;
	ldi (hl),a
;    \\\\\ UPPER WALL /////

;    ///// SIDE WALLS \\\\\
	ld de,14
	@walls_sides:			; while de != 0
	ld bc, $000C   ; next line distance
	add hl, bc     ;next line
	ld a, FLAT_BACKGROUND_WALL ;
	ldi (hl),a	 
	ld a, LEFT_BACKGROUND_WALL ;
	ldi (hl), a
	ld bc, $0010
	add hl, bc
	ld a, RIGHT_BACKGROUND_WALL
	ldi (hl),a	
	ld a, FLAT_BACKGROUND_WALL
	ldi (hl), a
	dec de		; de --
	ld a,e
	or d
	jr nz,@walls_sides	; end while
;    \\\\\ SIDE WALLS /////
	ld bc, $000C   ; next line distance
	add hl, bc                      ;next line
;    ///// DOWN WALL \\\\\
	ld a, FLAT_BACKGROUND_WALL
	ldi (hl),a
	ld a, DOWN_LEFT_CORNER ;
	ldi (hl),a
	ld de,16       ; loop iterator
	@wall_down_line1:			; while de != 0
	ld a, DOWN_BACKGROUND_WALL 
	ldi (hl),a	; *hl <- 0; hl++
	dec de		; de --
	ld a,e
	or d
	jr nz,@wall_down_line1	; end while
	ld a, DOWN_RIGHT_CORNER
	ldi (hl),a
	ld a, FLAT_BACKGROUND_WALL
	ldi (hl),a

	ld bc, $000C   ; next line distance
	add hl, bc                      ;next line

	ld de,20
	@wall_down_line2:			; while de != 0
	ld a, FLAT_BACKGROUND_WALL ;
	ldi (hl),a	; *hl <- 0; hl++
	dec de		; de --
	ld a,e
	or d
	jr nz,@wall_down_line2	; end while
;    \\\\\ DOWN WALL /////

;    ///// DETAILING \\\\\

	ld a, FIRST_WALL_DETAIL
	ld hl, $9805
	ld (hl),a
	ld hl, $9A2F
	ld (hl),a
	inc a
	ld hl, $9810
	ld (hl),a
	ld hl, $9A24
	ld (hl),a
	inc a
	ld hl, $9880
	ld (hl),a
	ld hl, $99B3
	ld (hl),a
	inc a
	ld hl, $9980
	ld (hl),a
	ld hl, $9873
	ld (hl),a

	inc a
	ld hl, $9826
	ld (hl),a
	inc a
	ld hl, $982D
	ld (hl),a
	inc a
	ld hl, $98C1
	ld (hl),a
	inc a
	ld hl, $98D2
	ld (hl),a
	inc a
	ld hl, $9961
	ld (hl),a
	inc a
	ld hl, $9992
	ld (hl),a
	inc a
	ld hl, $9A06
	ld (hl),a
	inc a
	ld hl, $9A0D
	ld (hl),a
	

;    \\\\\ DETAILING /////

; \\\\\\\ DRAWING WALLS ///////

	ld a, %00000101
	ld b, %00000000
	call displayDoors

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

.INCLUDE "init/display_test.init.s"

; \\\\\\\ LOAD SPRITES ///////


; ////// Copy DMA code into HRAM \\\\\\\
	ld b,b
	ld hl, HRAM_DMA_PROCEDURE ;Place to copy the HRAM DMA start code
	ld bc, start_dma_in_ROM ;Procedure in ROM to copy
	ld de, DMA_PROCEDURE_SIZE ;Size of the procedure
@loopCopyDmaProcedure:
	ld a, (bc)
	ld (hl), a
	inc bc
	inc hl
	dec e ;only using the low byte because procedure smaller than 256 bytes
	jr nz, @loopCopyDmaProcedure
; \\\\\\ Copy DMA code into HRAM ///////

; ////// Clear shadow OAM \\\\\\\
	ld hl, SHADOW_OAM_START
	ld b,40*4 ; Shadow OAM size (= OAM size)
@loopClearShadowOAM:			
	ld (hl),$00	
	inc l	
	dec b		; b --
	jr nz,@loopClearShadowOAM	; end while
; \\\\\\ Clear shadow OAM ///////

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
