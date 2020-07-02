titleScreen:

; /////// SETUP LCDC TILE DATA BLOCK \\\\\\\
    ldh a,($40) ;LCDC
    set 4,a ;Switch to tile data banks 0-1
	ldh ($40),a
; \\\\\\\ SETUP LCDC TILE DATA BLOCK ///////

; /////// Update Animation \\\\\\\
	ld a,(title_screen_.timer)
	and a
	jr z, @notimer
	dec a
	ld (title_screen_.timer), a
	jr @endtimer
@notimer:
	xor a
	ld (title_screen_.pointer), a
@endtimer:
	ld a, (title_screen_.animation_counter)
	inc a
	ld (title_screen_.animation_counter), a ;animation_counter++
	cp 7 ;Wait some frames before updating animation
	jp nz,@noUpdateAnimation
	xor a
	ld (title_screen_.animation_counter),a ;reset counter
	; Update animation 
    ldh a,($40) ;LCDC
	xor %00001000
	ldh ($40),a
@noUpdateAnimation
; \\\\\\\ Update Animation ///////


; /////// CHECK SELECT PRESSED \\\\\\\	
	ld h, $3F
	ld a, (title_screen_.pointer)
	ld l, a
	ld a,(hl)
	ld c,a
	ld a,%11011111 ;Select button (non direction) 
	ldh ($00),a ;($FF00)=$20
	ldh a,($00) ;B=($FF00) lire état touches
	bit 3,a
	jr nz, @noStart
	ld a, GAMESTATE_PLAYING
	jp setGameState
@noStart:
	cp c
	jr z, @do
	ld a,%11101111
	ldh ($00), a
	ldh a,($00)
	cp c
	jr nz, @end
@do:
	ld a, 20
	ld (title_screen_.timer), a
	ld a,l
	cp 19
	jr z, @ok
	inc a
	ld (title_screen_.pointer),a
	jr @end
@ok
	ld b,b
	ld l,0
	ld (global_.isaac.tears), a
@end:
	
; \\\\\\\ CHECK SELECT PRESSED ///////	
