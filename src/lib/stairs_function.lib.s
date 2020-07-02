stairs_function:
    ;xor a
    ;ld (global_.isaac.x), a
    ;ld (global_.isaac.y), a
	ld a, (current_floor_.i_floor)
    inc a
    ld (current_floor_.i_floor), a
	ld a, GAMESTATE_CHANGINGFLOOR
	jp setGameState 
    ret
