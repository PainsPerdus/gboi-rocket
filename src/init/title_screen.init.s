title_screen:

; ////// Init Variables \\\\\\
	xor a
	ld (title_screen_.animation_counter), a ;Reset animation counter

; \\\\\\ Init Variables //////

; ////// Copy Tiles \\\\\\
	
; ///// BLOCK 0 \\\\\
ld bc,_sizeof_IntroScreenTiles0
ld de,IntroScreenTiles0
ld hl,$8000 ;Block 0
@loopTiles0: ; while bc != 0
    ld a,(de)
    ldi (hl),a 
    inc de         
    dec bc 
    ld a,b
    or c
    jr nz,@loopTiles0  ; end while
; \\\\\ BLOCK 0 /////

; ///// BLOCK 1 \\\\\
ld bc,_sizeof_IntroScreenTiles1
ld de,IntroScreenTiles1
ld hl,$8800 ;Block 1
@loopTiles1: ; while bc != 0
    ld a,(de)
    ldi (hl),a 
    inc de         
    dec bc 
    ld a,b
    or c
    jr nz,@loopTiles1 ; end while
; \\\\\ BLOCK 1 /////

; ///// BLOCK 2 \\\\\
ld bc,_sizeof_IntroScreenTiles2
ld de,IntroScreenTiles2
ld hl,$9000 ;Block 2
@loopTiles2: ; while bc != 0
    ld a,(de)
    ldi (hl),a 
    inc de         
    dec bc 
    ld a,b
    or c
    jr nz,@loopTiles2 ; end while
; \\\\\ BLOCK 2 /////

; \\\\\\ Copy Background Tiles //////

; /////// CLEAR BG \\\\\\\
    ld de,32*32
    ld hl,$9800
@clmap:         ; while de != 0
    xor a;
    ldi (hl),a  ; *hl <- 0; hl++
    dec de      ; de --
    ld a,e
    or d
    jr nz,@clmap    ; end while
    ; The Z flag can't be used when dec on 16bit reg :(
; \\\\\\\ CLEAR BG ///////

; /////// COPY BACKGROUND MAPS \\\\\\\\

; ///// MAP 1 \\\\\
;We need to copy the data (20*18) array, to the first top left bytes of the background map (32*32 array)
	ld d,20 ;first loop counter
	ld e,_sizeof_IntroMap1/20 ;second loop counter
	ld bc,IntroMap1 ;data to copy
	ld hl,$9800 ;Background Map 1 (to copy to)
@map1:
	ld a,(bc)
	ldi (hl),a ;copy data
	inc bc ;setup next byte to copy 
	dec d 
	jr nz,@map1 ;first loop on columns
	ld a,e ;save e
	ld de, 12
	add hl, de ;jump to next bg line
	ld e,a ;restore e
	ld d,20 ;reset d
	dec e 
	jr nz, @map1; second loop on rows
; \\\\\ MAP 1 /////

; ///// MAP 2 \\\\\
/*
	ld d,20 ;first loop counter
	ld e,_sizeof_IntroMap2/20 ;second loop counter
	ld bc,IntroMap2 ;data to copy
	ld hl,$9800 ;Background Map 1 (to copy to)
@map2:
	ld a,(bc)
	ldi (hl),a ;copy data
	inc bc ;setup next byte to copy 
	dec d 
	jr nz,@map2 ;first loop on columns
	ld a,e ;save e
	ld de, 12
	add hl, de ;jump to next bg line
	ld e,a ;restore e
	ld d,20 ;reset d
	dec e 
	jr nz, @map2; second loop on rows
	*/
; \\\\\ MAP 2 /////

; \\\\\\\ COPY BACKGROUND MAPS ////////

; /////// CLEAR OAM \\\\\\\
    ld hl,$FE00
    ld b,40*4
@clspr:         ; while b != 0
    ld (hl),$00 ; *hl <- O
    inc l       ; hl ++ (no ldi hl or inc hl: bug hardware!)
    dec b       ; b --
    jr nz,@clspr    ; end while
            ; set the background offset to 0
    xor a
    ldh ($42),a
    ldh ($43),a
; \\\\\\\ CLEAR OAM ///////

; /////// INIT COLOR PALETTES \\\\\\\
ld a,%11100100  ; 11=Black 10=Dark Grey 01=Grey 00=White/trspt
ldh ($47),a ; background palette
ldh ($48),a ; sprite 0 palette
ldh ($49),a ; sprite 1 palette
; \\\\\\\ INIT COLOR PALETTES ///////

; /////// ENABLE SCREEN \\\\\\\
ld a,%10010001  ; screen on, bg on, tiles at $8000
ldh ($40),a
; \\\\\\\ ENABLE SCREEN ///////
