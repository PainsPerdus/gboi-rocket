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
	ld b, a  ; b is candidate coordinates

	; check that not already taken
	; check that another room is a neighboor (has a common wall)
	ld hl, current_floor_.rooms
	ld a, (current_floor_.number_rooms)
	ld c, a  ; c is room counter
	ld e, 0  ; number of found neighboors
@@check_other_rooms_loop:
	ld a, (hl)  ; load other room coordinates
	cp b
	jr z, @@generate_new_room  ; same coordinates: abort

	; compute the Manhattan distance between both
	; rooms, if distance is 1, the two are neighboors
	; compute abs(diff(x))
	push bc  ; we will need more free registers
 	ld a, (hl)  ; reload other room coordinates
 	and ROOM_Y_MASK
 	ld d, a  ; d is other room y
 	ld a, b
 	and ROOM_Y_MASK  ; a is candidate y
 	sub d  ; a is difference between coordinates
	jr nc, @@y_diff_no_carry
	ld d, a  ; perform a = -a using d
	xor a
	sub d
@@y_diff_no_carry:
	ld c, a  ; c is partial distance
	
	;compute abs(diff(y))
 	ld a, (hl)  ; reload other room coordinates
 	and ROOM_X_MASK
 	swap a
 	ld d, a  ; d is other room y
 	ld a, b
 	and ROOM_X_MASK
 	swap a  ; a is candidate x
 	sub d  ; a is difference between coordinates
	jr nc, @@x_diff_no_carry
	ld d, a  ; perform a = -a using d
	xor a
	sub d
@@x_diff_no_carry:
	add c  ; a is Manhattan distance
	       ; no risk of overflow, max value is 16+16=32
	pop bc  ; restore registers

	; process result
	cp 1  ; is distance 1
	jr nz, @@continue_check_other_rooms
	inc e  ; rooms are neighboors

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
	; we don't want a too compact floor, so abort if
	; too many neighboors
	cp 3
	jr nc, @@generate_new_room

	;coordinates are ok
	pop hl  ; pop room being built
	ld (hl), b  ; set coordinates
	inc hl
	ld a, 0
	ldi (hl), a  ; set room id 0 for now
	ld a, ROOM_TYPE_NORMAL
	set ROOM_INFO_ALIVE_FLAG, a
	ldi (hl), a  ; set room info
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
	pop hl  ; pop room after the last
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
	            ; TODO: use the real boss room
; \\\\ other rooms generation ////

; //// add doors \\\\
@add_doors:
	; add the doors for each room
	; here we are testing all (room 1, room 2) pairs
	; we don't optimise the nested loops because
	; it allows us to only check room 1 bottom and right
	; (and therefore room 2 top and left) doors at
	; each step, which saves a massive amount of
	; complexity (e.g in term of register usage)

	; start of loop on room 1
	ld hl, current_floor_.rooms
	ld a, (current_floor_.number_rooms)
	ld b, a  ; b is room 1 counter
@@room_1_doors:
	push hl  ; push current room 1
	ld d, (hl)  ; d is room 1 coordinates

	;start of loop on room 2
	ld hl, current_floor_.rooms
	ld a, (current_floor_.number_rooms)
	ld c, a  ; c is room 2 counter
@@room_2_doors:
	ld a, (hl)  ; get room 2 coordinates
	cp d  ; are 1 and 2 the same room ?
	jr z, @@continue_room_2_doors

	; process x coordinates
	and ROOM_X_MASK
	swap a
	ld e, a  ; e is room 2 x
	ld a, d
	and ROOM_X_MASK
	swap a  ; a is room 1 x
	cp e  ; are 1 and 2 on same column ?
	jr z, @@doors_same_column
	inc a
	cp e  ; is 1 one column left of 2
	jr nz, @@continue_room_2_doors

	; case: 1 is one column left of 2
	ld a, (hl)  ; reload room 2 coordinates
	and ROOM_Y_MASK
	ld e, a  ; e is room 2 y
	ld a, d
	and ROOM_Y_MASK  ; a is room 1 y
	cp e  ; are 1 and 2 on same row ?
	      ; if yes they are left/right neighboors
	jr nz, @@continue_room_2_doors
	inc hl  ; get room 2 info
	inc hl
	set ROOM_INFO_DOOR_LEFT_FLAG, (hl)
	dec hl
	dec hl
	pop de  ; get room 1 ptr
	push de  ; keep it on the stack
	inc de  ; get room 1 info
	inc de
	ld a, (de)
	set ROOM_INFO_DOOR_RIGHT_FLAG, a
	ld (de), a
	dec de
	dec de
	ld a, (de)  ; restore room 1 coordinates in d
	ld d, a

@@doors_same_column:
	; case: 1 is on the same column as 2
	ld a, (hl)  ; reload room 2 coordinates
	and ROOM_Y_MASK
	ld e, a  ; e is room 2 y
	ld a, d
	and ROOM_Y_MASK  ; a is room 1 y
	inc a
	cp e  ; is 1 one row above 2
	      ; if yes they are top/down neighboors
	jr nz, @@continue_room_2_doors
	inc hl  ; get room 2 info
	inc hl
	set ROOM_INFO_DOOR_UP_FLAG, (hl)
	dec hl
	dec hl
	pop de  ; get room 1 ptr
	push de  ; keep it on the stack
	inc de  ; get room 1 info
	inc de
	ld a, (de)
	set ROOM_INFO_DOOR_DOWN_FLAG, a
	ld (de), a
	dec de
	dec de
	ld a, (de)  ; restore room 1 coordinates in d
	ld d, a

@@continue_room_2_doors:
	ld a, d  ; preserve d
		 ; /!\ using a to store data
	ld de, _sizeof_room  ; get next room 2
	add hl, de
	ld d, a
	dec c
	jr nz, @@room_2_doors
@@continue_room_1_doors:
	pop hl  ; hl is room 1
	ld de, _sizeof_room
	add hl, de
	dec b
	jr nz, @@room_1_doors
; \\\\ add doors ////

; //// set room ids \\\\
@set_room_ids:
	ld hl, current_floor_.rooms
	ld de, _sizeof_room
	add hl, de  ; skip first room that always has id 0
	ld a, (current_floor_.number_rooms)
	ld b, a  ; b is the room counter
	dec b  ; first room is skipped
	dec b  ; stop 1 room earlier: don't touch boss room

@@loop_rooms:
	push bc  ; push room counter (in b)
	inc hl
	inc hl  ; hl is room info ptr
	ld a, (hl)  ; a is room info
	and ROOM_INFO_DOOR_MASK
	ld c, a  ; c is room doors
	push hl  ; push current room info ptr

@@loop_candidates:
	call rng  ; b and h are clobbered
	and %111  ; TODO: this is a dirty way of selecting
	          ; the right range
	inc a
	ld b, a  ; b is the new candidate id
	; perform room_data_ptr_ptr=room_index+2*(candidate)
	; room index is an array of ptr pointing to the
	; rooms in ROM
	ld e, a
	ld l, a
	xor a
	ld d, a  ; de is candidate
	ld h, a  ; hl is candidate
	add hl, de  ; hl is candidate x2
	ld de, room_index
	add hl, de  ; hl is room_data_ptr_ptr
	ld e, (hl)
	inc hl
	ld d, (hl)  ; de is candidate room data ptr
	ld a, (de)  ; a is candidate info
	and c  ; a is the doors that are in both
	cp c  ; check the doors of current are all 
	      ; present in candidate
	jr nz, @@loop_candidates

	; set the room id to the selected candidate
	pop hl  ; pop current room info ptr
	dec hl  ; hl is room id ptr
	ld (hl), b
	dec hl  ; hl is current room
	ld de, _sizeof_room
	add hl, de  ; hl is next room

	; continue the loop
	pop bc  ; pop room counter in b
	dec b
	jr nz, @@loop_rooms
; \\\\ set room ids ////
; \\\ generate next floor ///

; /// load first room \\\
@floorReady:
	; set first map doors
	ld a, (current_floor_.current_room)
	ld h, a
	ld a, (current_floor_.current_room + 1)
	ld l, a
	inc hl
	inc hl
	ld a, (hl)  ; a is current room info
	ld (load_map_.doors), a

	dec hl
	ld e, (hl)  ; e is current room id
	xor a
	ld d, a  ; de is current room id
	ld h, d
	ld l, e  ; hl is current room id
	add hl, de  ; hl is current room id x2
	ld de, room_index
	add hl, de  ; hl is current room id index
	ldi a, (hl)
	ld (load_map_.map_address + 1), a
	ldi a, (hl)
	ld (load_map_.map_address), a

	call load_map

	call displayRoom
; \\\ load first room ///
