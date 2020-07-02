stairs_function:
    xor a
    ld (global_.isaac.x), a
    ld (global_.isaac.y), a
	ld a, GAMESTATE_TITLESCREEN
	jp setGameState 
    ret
