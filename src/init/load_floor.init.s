@load_floor:

	ld a, (current_floor_.i_floor)
	cp 0  ; first floor is hardcoded
	jr nz, @not_first_floor
	
	; copy memery stored 1st floor into current_floor_
	ld de, first_floor
	ld hl, current_floor_
	ld a, _sizeof_current_floor_var - 3
	ld b, a
@loadFirstFloorLoop:
	ld a, (de)
	ld (hl), a
	inc de
	inc hl
	dec b
	jr nz, @loadFirstFloorLoop

	; find first room
	; TODO: we could have as convention that the
	;       starting room is the first room
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
	jr @floorReady

@not_first_floor:
	; randomly generate the floor
	xor c  ; c is the current number of room
	       ; don't take b as b is modified by rng

	; generate the first room
	ld de, current_floor_.rooms
	ld a, d  ; set it as the current room
	ld (current_floor_.current_room), a
	ld a, e
	ld (current_floor_.current_room + 1), a
	call rng
	ld h, d
	ld l, e
	ldi (hl), a  ; random coordinates
	ld a, 0  ; first map always has id 0
	ldi (hl), a
	ld a, ROOM_TYPE_START
	ldi (hl), a
	ld a, $ff  ; masks with all bit set
	ldi (hl), a
	ldi (hl), a
	ldi (hl), a
	ldi (hl), a
	ldi (hl), a
	ldi (hl), a
	ldi (hl), a
	ld d, h  ; de is the currently built room
	ld e, l
	inc c


@floorReady:
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
