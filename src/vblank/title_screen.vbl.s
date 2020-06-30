titleScreen:
	
	ld a,%00010000 ; Selection touches de direction
	ldh ($00),a ;($FF00)=$20

	ldh a,($00) ;B=($FF00) lire état touches
	bit 3,a
	jr nz, @noSelect
	ld a, GAMESTATE_PLAYING
	call setGameState
@noSelect:
