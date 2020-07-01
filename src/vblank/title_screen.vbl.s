titleScreen:

; /////// SETUP LCDC TILE DATA BANK \\\\\\\
    ldh a,($40) ;LCDC
    set 4,a ;Switch to tile data banks 0-1
	ldh ($40),a
; \\\\\\\ SETUP LCDC TILE DATA BANK ///////


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
