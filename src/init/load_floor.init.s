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
	jp @floorReady

@not_first_floor:
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
	push hl  ; push currently being built room
	ld a, 1
	ld (current_floor_.number_rooms), a

	; generate some new rooms
	;
	; the idea is to pick a random spot on the grid
	; and check if it is suitable for a new room
	;
	; not very optimal (we should expect many misses)
	; but not really a problem (we are outside the
	; game loop)
@generate_new_room:
	call rng  ; generate candidate coordinates
	ld b, a  ; b is candidate coordinates

	; check that not already taken
	; check that another room is a neighboor (has a common wall)
	ld hl, current_floor_.rooms
	ld a, (current_floor_.number_rooms)
	ld c, a  ; c is room counter
	xor e  ; boolean found neighboor
@check_other_rooms_loop:
	ld a, (hl)  ; load other room coordinates
	cp b
	jr z, @generate_new_room  ; same coordinates: abort
	ld d, a  ; stash other room coordinates
	ld a, e
	cp 0  ; do we already know a neighboor
	      ; if yes, no need to find a new one
	jr nz, @continue_check_other_rooms
	ld a, d

	; check if neighboor y-wise
	and ROOM_Y_MASK
	ld d, a  ; d is other room y
	ld a, b
	and ROOM_Y_MASK  ; a is candidate y
	sub d  ; a is difference between coordinates
	jr z, @check_other_x
	cp 1
	jr z, @other_y_is_neighboor
	add 1
	jr nc, @continue_check_other_rooms
@other_y_is_neighboor:
	ld e, 1  ; candidate and other are neighboors y-wise

	; check if neighboor x-wise
@check_other_x:
	ld a, (hl)  ; reload other room coordinates
	and ROOM_X_MASK
	swap a
	ld d, a  ; d is other room y
	ld a, b
	and ROOM_X_MASK
	swap a  ; a is candidate x
	sub d  ; a is difference between coordinates
	jr z, @continue_check_other_rooms  ; e is already set
	cp 1
	jr z, @other_x_is_neighboor
	add 1
	jr nc, @continue_check_other_rooms
@other_x_is_neighboor:
	ld a, e
	; this time we use a xor, because if other is a neighboor
	; both y-wise and x-wise, it is not a real neighboor
	xor 1
	ld e, a
@continue_check_other_rooms:
	ld de, _sizeof_room
	add hl, de
	dec c
	jr nz, @check_other_rooms_loop

	; all other rooms checked, was neighboor found?
	ld a, e
	cp 0
	jr z, @generate_new_room

	;coordinates are ok
	pop hl  ; pop room being built
	ld (hl), b  ; set coordinates
	inc hl
	call rng
	and %111
	ldi (hl), a  ; set random id
	ld a, ROOM_TYPE_NORMAL
	ldi (hl), a  ; set room type
	ld a, $ff  ; masks with all bit set
	ldi (hl), a
	ldi (hl), a
	ldi (hl), a
	ldi (hl), a
	ldi (hl), a
	ldi (hl), a
	ldi (hl), a
	push hl  ; push next currently being built room
	ld a, (current_floor_.number_rooms)
	inc a
	ld (current_floor_.number_rooms), a
	cp 10  ; TODO: make room number variable
	jr nz, @generate_new_room

; TODO: last room should be a boss
; TODO: add doors

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
