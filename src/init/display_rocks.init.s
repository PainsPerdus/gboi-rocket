; Display a rock at tile (X, Y) (X,Y being position on the 32x32 background grid)
displayBackgroundTile:
; //// Computer top left rock position \\\\
ld bc, 12 ;bc=X
ld de, 9 ;de=Y
sla e ;de=Y*2
sla e ;de=Y*4
sla e ;de=Y*8

ld hl,$9800
add hl, bc ;hl+=X
add hl, de ;hl+=Y
add hl, de ;hl+=Y
add hl, de ;hl+=Y
add hl, de ;hl+=Y

;hl now countains the top left rock position in the BG Map
; \\\\ Computer top left rock position ////

; //// Set rock 4 tiles \\\\
	//First tile
	ld (hl), ROCKS_SPRITESHEET+4
	//Second tile
	inc hl
	ld (hl), ROCKS_SPRITESHEET+5
	//Third tile
	ld bc, 31
	add hl,bc
	ld (hl), ROCKS_SPRITESHEET+6
	//Fourth tile
	inc hl
	ld (hl), ROCKS_SPRITESHEET+7

; \\\\ Set rock 4 tiles ////
