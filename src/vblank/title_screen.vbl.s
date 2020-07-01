titleScreen:

; /////// SETUP LCDC TILE DATA BLOCK \\\\\\\
    ldh a,($40) ;LCDC
    set 4,a ;Switch to tile data banks 0-1
	ldh ($40),a
; \\\\\\\ SETUP LCDC TILE DATA BLOCK ///////

; /////// Update Animation \\\\\\\
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
	ld a,%00010000 ;Select button (non direction) 
	ldh ($00),a ;($FF00)=$20

	ldh a,($00) ;B=($FF00) lire état touches
	bit 3,a
	jr nz, @noSelect
	ld a, GAMESTATE_PLAYING
	call setGameState
@noSelect:
; \\\\\\\ CHECK SELECT PRESSED ///////	
