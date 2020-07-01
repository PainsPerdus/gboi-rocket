; /// all the door functions \\\
; /// top door function \\\
top_door_fun:
	push bc
	push de

	ld a, $90+$10-$15-$10
	ld (global_.isaac.y), a

	; load x, y
	ld a, (current_floor_.current_room)
	ld d, a
	ld a, (current_floor_.current_room + 1)
	ld e, a
	ld a, (de)
	dec a
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
@thereAreEnemies:

@waitvlb:           ; wait for the line 144 to be refreshed:
    ldh a,($44)
    cp 144          ; if a < 144 jump to waitvlb
    jr c, @waitvlb

	di
	call displayRoom
	ei

	pop de
	pop bc
    ret
; \\\ top door function ///










; /// bottom door function \\\
bot_door_fun:
	push bc
	push de

	ld a, $15+$10
	ld (global_.isaac.y), a

	; load x, y
	ld a, (current_floor_.current_room)
	ld d, a
	ld a, (current_floor_.current_room + 1)
	ld e, a
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
@thereAreEnemies:

@waitvlb:           ; wait for the line 144 to be refreshed:
    ldh a,($44)
    cp 144          ; if a < 144 jump to waitvlb
    jr c, @waitvlb

	di
	call displayRoom
	ei

	pop de
	pop bc
    ret
; \\\ bottom door function ///











; /// left door function \\\
left_door_fun:
	;push bc
	;push de

	ld a, $A0-$15+$08-$10
	ld (global_.isaac.x), a

	; load x, y
	ld a, (current_floor_.current_room)
	ld d, a
	ld a, (current_floor_.current_room + 1)
	ld e, a
	ld a, (de)
	swap a
	dec a
	swap a
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
	
	pop bc ;don't return so we pop something instead
	ld a, GAMESTATE_CHANGINGROOM
	jp setGameState
	
	//call load_map
	


/*@waitvlb:           ; wait for the line 144 to be refreshed:
    ldh a,($44)
    cp 144          ; if a < 144 jump to waitvlb
    jr c, @waitvlb

	di*/
	
	;call displayRoom
//	ei

	;pop de
	;pop bc
    ;ret
; \\\ left door function ///











; /// right door function \\\
right_door_fun:
	push bc
	push de

	ld a, $15+$08
	ld (global_.isaac.x), a

	; load x, y
	ld a, (current_floor_.current_room)
	ld d, a
	ld a, (current_floor_.current_room + 1)
	ld e, a
	ld a, (de)
	swap a
	inc a
	swap a
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
@thereAreEnemies:

@waitvlb:           ; wait for the line 144 to be refreshed:
    ldh a,($44)
    cp 144          ; if a < 144 jump to waitvlb
    jr c, @waitvlb

	di
	call displayRoom
	ei

	pop de
	pop bc
    ret
; \\\ right door function ///
; \\\ all the door functions ///
