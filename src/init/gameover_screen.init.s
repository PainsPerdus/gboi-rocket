gameOverScreenInit:

; ////// Copy Tiles \\\\\\
	
ld bc,_sizeof_GameOverTiles
ld de,GameOverTiles
ld hl,$8000 ;Block 0 start
@loopTiles: ; while bc != 0
    ld a,(de)
    ldi (hl),a 
    inc de         
    dec bc 
    ld a,b
    or c
    jr nz,@loopTiles  ; end while
; \\\\\\ Copy Background Tiles //////

; /////// CLEAR BG \\\\\\\
    ld de,32*32
    ld hl,$9800
@clmap:         ; while de != 0
    ld a,220;
    ldi (hl),a  ; *hl <- 220; hl++
    dec de      ; de --
    ld a,e
    or d
    jr nz,@clmap    ; end while
    ; The Z flag can't be used when dec on 16bit reg :(
; \\\\\\\ CLEAR BG ///////

; /////// COPY BACKGROUND MAP \\\\\\\\

;We need to copy the data (20*18) array, to the first top left bytes of the background map (32*32 array)
	ld d,20 ;first loop counter
	ld e,_sizeof_GameOverMap/20 ;second loop counter
	ld bc,GameOverMap ;data to copy
	ld hl,$9800 ;Background Map 1 (to copy to)
@map:
	ld a,(bc)
	ldi (hl),a ;copy data
	inc bc ;setup next byte to copy 
	dec d 
	jr nz,@map ;first loop on columns
	ld a,e ;save e
	ld de, 12
	add hl, de ;jump to next bg line
	ld e,a ;restore e
	ld d,20 ;reset d
	dec e 
	jr nz, @map; second loop on rows

; \\\\\\\ COPY BACKGROUND MAP ////////

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
