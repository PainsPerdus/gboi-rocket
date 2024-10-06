@load_floor:

	ld a, (current_floor_.i_floor)
	cp 0  ; first floor is hardcoded
	jr nz, @not_first_floor
	
; /// load first floor \\\
@load_first_floor:
	; copy memery stored 1st floor into current_floor_
	ld de, first_floor
	ld hl, current_floor_
	ld a, _sizeof_current_floor_var - 3
	ld b, a
@@loadFirstFloorLoop:
	ld a, (de)
	ld (hl), a
	inc de
	inc hl
	dec b
	jr nz, @@loadFirstFloorLoop

	; find first room
	; TODO: we could have as convention that the
	;       starting room is the first room
	ld a, (current_floor_.number_rooms)
	ld b, a
	ld de, current_floor_.rooms
@@findStartLoop:
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
	jr nz, @@findStartLoop
@@startFound:
	ld a, d
	ld (current_floor_.current_room), a
	ld a, e
	ld (current_floor_.current_room + 1), a
	jp @floorReady
; \\\ load first floor ///

; /// generate next floor \\\
@not_first_floor:
	; generate the first room
	ld hl, current_floor_.rooms
	ld a, h  ; set it as the current room
	ld (current_floor_.current_room), a
	ld a, l
	ld (current_floor_.current_room + 1), a

	; create first room
	call rng  ; clobbers h
	and $33  ; TODO: remove
	ld hl, current_floor_.rooms
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

//// other rooms generation \\\\
	; generate some new rooms
	;
	; the idea is to pick a random spot on the grid
	; and check if it is suitable for a new room
	;
	; not very optimal (we should expect many misses)
	; but not really a problem (we are outside the
	; game loop)
@@generate_new_room:
	call rng  ; generate candidate coordinates
	and $33  ; TODO: remove
	ld b, a  ; b is candidate coordinates

	; check that not already taken
	; check that another room is a neighboor (has a common wall)
	ld hl, current_floor_.rooms
	ld a, (current_floor_.number_rooms)
	ld c, a  ; c is room counter
	ld e, 0  ; boolean found neighboor
@@check_other_rooms_loop:
	ld a, (hl)  ; load other room coordinates
	cp b
	jr z, @@generate_new_room  ; same coordinates: abort
	ld a, e
	cp 0  ; do we already know a neighboor
	      ; if yes, no need to find a new one
	jr nz, @@continue_check_other_rooms

	; check if neighboor y-wise
	ld a, (hl)  ; reload other room coordinates
	and ROOM_Y_MASK
	ld d, a  ; d is other room y
	ld a, b
	and ROOM_Y_MASK  ; a is candidate y
	sub d  ; a is difference between coordinates
	jr z, @@check_other_x
	cp 1  ; check if diff = 1
	jr z, @@other_y_is_neighboor
	add 1  ; check if diff = -1
	jr nc, @@continue_check_other_rooms
@@other_y_is_neighboor:
	ld e, 1  ; candidate and other are neighboors y-wise

	; check if neighboor x-wise
@@check_other_x:
	ld a, (hl)  ; reload other room coordinates
	and ROOM_X_MASK
	swap a
	ld d, a  ; d is other room y
	ld a, b
	and ROOM_X_MASK
	swap a  ; a is candidate x
	sub d  ; a is difference between coordinates
	jr z, @@continue_check_other_rooms  ; e is already set if needed
	cp 1  ; check if diff = 1
	jr z, @@other_x_is_neighboor
	add 1  ; check if diff = -1
	jr nc, @@continue_check_other_rooms
@@other_x_is_neighboor:
	ld a, e
	; this time we use a xor, because if other is a neighboor
	; both y-wise and x-wise, it is not a real neighboor
	xor 1
	ld e, a
@@continue_check_other_rooms:
	ld a, e  ; stash e because it is still needed
	ld de, _sizeof_room  ; get next room
	add hl, de
	ld e, a
	dec c
	jr nz, @@check_other_rooms_loop

	; all other rooms checked, was neighboor found?
	ld a, e
	cp 0
	jr z, @@generate_new_room

	;coordinates are ok
	pop hl  ; pop room being built
	ld (hl), b  ; set coordinates
	inc hl
	push hl  ; rng clobbers h
	call rng
	pop hl
	and %111
	inc a  ; room id between 1 and 8
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
	jr nz, @@generate_new_room
	
	; make last room a boss room
	ld de, _sizeof_room - 2  ; get previous room info
	ld a, l  ; perform l - e
	sub e
	ld l, a  ; ld doesn't update flags
	ld a, h  ; propagate carry flag to h
	sbc 0
	ld h, a
	ld a, (hl)
	and ~ROOM_INFO_TYPE_MASK  ; clear room type
	or ROOM_TYPE_BOSS  ; set room type boss
	ld (hl), a
	dec hl
	ld (hl), 0  ; room id 0 for boss room
; \\\\ other rooms generation ////

; //// add doors \\\\
@add_doors:
	; add the doors for each room
	ld hl, current_floor_.rooms
	ld a, (current_floor_.number_rooms)
	ld d, a  ; d is room 1 counter
@@room_1_doors:
	push de  ; push room 1 counter
	push hl  ; push current room 1
	ld b, (hl)  ; b is room 1 coordinates
	ld a, (current_floor_.number_rooms)
	ld c, d  ; room 2 counter is room 1 counter
	         ; because it will be decreased at loop start
	         ; c is room 2 counter
@@room_2_doors:
	dec c
	jr z, @@contine_room_1_doors
	ld de, _sizeof_room
	add hl, de  ; next room in hl
	ld e, 0  ; e will store some info later
	ld a, (hl)
	and ROOM_Y_MASK
	ld d, a  ; d is room 2 y
	ld a, b
	and ROOM_Y_MASK  ; a is room 1 y
	sub d  ; a is r1.y - r2.y
	jr z, @@potential_x_neighboor
	cp 1  ; check diff = 1
	jr z, @@potential_y_neighboor_1_is_bot
	add 1  ; check diff = -1
	jr nc, @@room_2_doors
; potential_y_neighboor_1_is_top:
	ld e, 1
	jr @@potential_x_neighboor
@@potential_y_neighboor_1_is_bot:
	ld e, 2
@@potential_x_neighboor:
	ld a, (hl)
	and ROOM_X_MASK
	swap a
	ld d, a  ; d is room 2 x
	ld a, b
	and ROOM_X_MASK
	swap a  ; a is room 1 x
	sub d  ; a is r1.x - r2.x
	jr z, @@check_y_neighboor_1_is_top
; check_x_neighboor_1_is_right:
	cp 1  ; check if diff = 1
	jr nz, @@check_x_neighboor_1_is_left
	inc hl  ; get room 2 info
	inc hl
	set ROOM_INFO_DOOR_RIGHT_FLAG, (hl)
	dec hl  ; restore room 2 ptr
	dec hl
	pop de  ; get room 1 ptr
	push de
	inc de  ; get room 1 info
	inc de
	ld a, (de)
	set ROOM_INFO_DOOR_LEFT_FLAG, a
	ld (de), a
	jr @@room_2_doors
@@check_x_neighboor_1_is_left:
	add 1  ; check if diff = -1
	jr nc, @@room_2_doors
	inc hl  ; get room 2 info
	inc hl
	set ROOM_INFO_DOOR_LEFT_FLAG, (hl)
	dec hl  ; restore room 2 ptr
	dec hl
	pop de  ; get room 1 ptr
	push de
	inc de  ; get room 1 info
	inc de
	ld a, (de)
	set ROOM_INFO_DOOR_RIGHT_FLAG, a
	ld (de), a
	jr @@room_2_doors
@@check_y_neighboor_1_is_top:
	ld a, e
	cp 1
	jr nz, @@check_y_neighboor_1_is_bot
	inc hl  ; get room 2 info
	inc hl
	set ROOM_INFO_DOOR_UP_FLAG, (hl)  
	dec hl  ; restore room 2 ptr
	dec hl
	pop de  ; get room 1 ptr
	push de
	inc de  ; get room 1 info
	inc de
	ld a, (de)
	set ROOM_INFO_DOOR_DOWN_FLAG, a
	ld (de), a
	jr @@room_2_doors
@@check_y_neighboor_1_is_bot:
	cp 2
	jr nz, @@room_2_doors
	inc hl  ; get room 2 info
	inc hl
	set ROOM_INFO_DOOR_DOWN_FLAG, (hl)
	dec hl  ; restore room 2 ptr
	dec hl
	pop de  ; get room 1 ptr
	push de
	inc de  ; get room 1 info
	inc de
	ld a, (de)
	set ROOM_INFO_DOOR_UP_FLAG, a
	ld (de), a
	jr @@room_2_doors
@@contine_room_1_doors:
	pop hl  ; hl is room 1
	pop de  ; d is room 1 counter
	ld bc, _sizeof_room
	add hl, bc
	dec d
	jp nz, @@room_1_doors
; \\\\ add doors ////
; \\\ generate next floor ///

; /// load first room \\\
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
; \\\ load first room ///
