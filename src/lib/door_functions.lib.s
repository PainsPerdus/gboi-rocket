; /// all the door functions \\\
top_door_fun:
    ret

; /// bottom door function \\\
bot_door_fun:

	ld a, $25
	ld (global_.isaac.y), a

	; load x, y
	ld a, d
	ld (current_floor_.current_room), a
	ld a, e
	ld (current_floor_.current_room + 1), a
	ld a, (de)
	inc a
	ld c, a

	ld a, (current_floor_.number_rooms)
	ld b, a
	ld de, current_floor_.rooms
@findRoomLoop:
	ld a, (de)
	cp c
	jr z, @roomFound
	ld hl, _sizeof_room
	add hl, de
	ld d, h
	ld e, l
	dec b
	jr nz, @findRoomLoop
@roomFound:
	ld a, d
	ld (current_floor_.current_room), a
	ld a, e
	ld (current_floor_.current_room + 1), a

	; load room
	ld a, (current_floor_.current_room)
	ld h, a
	ld a, (current_floor_.current_room + 1)
	ld l, a
	inc hl
	inc hl
	ldi a, (hl)
	ld (load_map_.doors), a

	ld a, (current_floor_.current_room)
	ld h, a
	ld a, (current_floor_.current_room + 1)
	ld l, a
	inc hl
	ld e, (hl)
	xor a
	ld d, a
	ld h, d
	ld l, e
	add hl, de
	ld de, room_index
	add hl, de
	ldi a, (hl)
	ld (load_map_.map_address + 1), a
	ldi a, (hl)
	ld (load_map_.map_address), a
	
	call load_map

	ld a, (global_.enemies)
	bit 7, a
	jr nz, @thereAreEnemies
	ld a, (load_map_.doors)
	and %11110111
	ld (load_map_.doors), a
@thereAreEnemies

@waitvlb:           ; wait for the line 144 to be refreshed:
    ldh a,($44)
    cp 144          ; if a < 144 jump to waitvlb
    jr c, @waitvlb

	call displayRoom

    ret
; \\\ bottom door function ///

left_door_fun:
    ret

right_door_fun:
    ret
; \\\ all the door functions ///