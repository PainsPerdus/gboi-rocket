; /// all the door functions \\\
top_door_fun:
    ld a, $50
	ld b, a
	push hl
	ld l, ROCKS_SPRITESHEET
	call displayBackgroundTile
	pop hl
    ret

bot_door_fun:
    ld a, $50
	ld b, a
	push hl
	ld l, ROCKS_SPRITESHEET
	call displayBackgroundTile
	pop hl
    ret

left_door_fun:
    ld a, $50
	ld b, a
	push hl
	ld l, ROCKS_SPRITESHEET
	call displayBackgroundTile
	pop hl
    ret

right_door_fun:
    ld a, $50
	ld b, a
	push hl
	ld l, ROCKS_SPRITESHEET
	call displayBackgroundTile
	pop hl
    ret
; \\\ all the door functions ///