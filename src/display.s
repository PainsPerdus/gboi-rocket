display:
; ////// UPDATE SPRITES POSITION \\\\\\
; // Isaac \\
		ld a, (global_.isaac.y)
		ld b,a
		ld a, (global_.isaac.x)
		ld c,a
//top left
		ld hl,$FE00
		ld a, b
		ld (hl), a ;posY
		inc l
		ld a, c
		ld (hl), a ; posX
//top right
		ld hl,$FE04
		ld a,b
		ld (hl),a ;posY
		inc l
		ld a,c
		add 8
		ld (hl),a ;posX
//bottom left
		ld hl,$FE08
		ld a,b
		add 8
		ld (hl), a ;posY
		inc l
		ld a,c
		ld (hl), a ;posX
//bottom right
		ld hl,$FE0C
		ld a,b
		add 8
		ld (hl), a ;posY
		inc l
		ld a,c
		add 8
		ld (hl), a ;posX
; \\ Isaac //
; \\\\\\ UPDATE SPRITES POSITION //////

