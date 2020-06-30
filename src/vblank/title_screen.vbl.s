titleScreen:
	ld b,b
	ld a, GAMESTATE_PLAYING
	call changeState
