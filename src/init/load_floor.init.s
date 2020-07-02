@load_floor:

	ld a, (current_floor_.i_floor)

    ; load floor
    cp 0
    jr nz, @@not_first
	ld de, first_floor
    jr @@floorReady
@@not_first:
    cp 1
    jr nz, @@not_second
    ld de, second_floor
    jr @@floorReady
@@not_second:

@@floorReady
	ld hl, current_floor_
    ld a, _sizeof_current_floor_var - 3
	ld b, a
@initFloorLoop:
	ld a, (de)
	ld (hl), a
	inc de
	inc hl
	dec b
	jr nz, @initFloorLoop

; find first room
	ld a, (current_floor_.number_rooms)
	ld b, a
	ld de, current_floor_.rooms
@findStartLoop:
	ld h, d
	ld l, e
	inc hl
	inc hl
	ld a, (hl)
	bit 2, a
	jr nz, @@startFound
	ld hl, _sizeof_room
	add hl, de
	ld d, h
	ld e, l
	dec b
	jr nz, @findStartLoop
@@startFound:
	ld a, d
	ld (current_floor_.current_room), a
	ld a, e
	ld (current_floor_.current_room + 1), a

; load first room
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

	call displayRoom
