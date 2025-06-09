; /// add the doors as activable items in a room \\\
    ld hl, load_room_.room_info
    ld b, (hl)
    ld a, (load_room_.next_object)
    ld l, a
    ld a, (load_room_.next_object + 1)
    ld h, a

    ;top door
    bit ROOM_INFO_DOOR_UP_FLAG, b
    jr z, @noTopDoor
    ld a, VDOOR_INFO
    ldi (hl), a

    bit ROOM_INFO_ALIVE_FLAG, b
    jr nz, @@closeDoors
    ld a, $00+OPEN_TOP_BOTTOM_DOOR_OFFSET
    jr @@openDoors
@@closeDoors:
    ld a, $00
@@openDoors:
    ldi (hl), a

    ld a, TOP_BOTTOM_DOOR_Y
    ldi (hl), a
    ld de, top_door_fun
    ld a, d
    ldi (hl), a
    ld a, e
    ldi (hl), a
@noTopDoor:

    ;bottom door
    bit ROOM_INFO_DOOR_DOWN_FLAG, b
    jr z, @noBottomDoor
    ld a, VDOOR_INFO
    ldi (hl), a

    bit ROOM_INFO_ALIVE_FLAG, b
    jr nz, @@closeDoors
    ld a, ROOM_PIXEL_SIZE-OPEN_TOP_BOTTOM_DOOR_OFFSET
    jr @@openDoors
@@closeDoors:
    ld a, ROOM_PIXEL_SIZE
@@openDoors:
    ldi (hl), a

    ld a, TOP_BOTTOM_DOOR_Y
    ldi (hl), a
    ld de, bot_door_fun
    ld a, d
    ldi (hl), a
    ld a, e
    ldi (hl), a
@noBottomDoor:

    ;left door
    bit ROOM_INFO_DOOR_LEFT_FLAG, b
    jr z, @noLeftDoor
    ld a, HDOOR_INFO
    ldi (hl), a
    ld a, LEFT_RIGHT_DOOR_X
    ldi (hl), a

    bit ROOM_INFO_ALIVE_FLAG, b
    jr nz, @@closeDoors
    ld a, $00+OPEN_LEFT_RIGHT_DOOR_OFFSET
    jr @@openDoors
@@closeDoors:
    ld a, $00
@@openDoors:
    ldi (hl), a

    ld de, left_door_fun
    ld a, d
    ldi (hl), a
    ld a, e
    ldi (hl), a
@noLeftDoor:

    ;right door
    bit ROOM_INFO_DOOR_RIGHT_FLAG, b
    jr z, @noRightDoor
    ld a, HDOOR_INFO
    ldi (hl), a
    ld a, LEFT_RIGHT_DOOR_X
    ldi (hl), a

    bit ROOM_INFO_ALIVE_FLAG, b
    jr nz, @@closeDoors
    ld a, ROOM_PIXEL_SIZE-OPEN_LEFT_RIGHT_DOOR_OFFSET
    jr @@openDoors
@@closeDoors:
    ld a, ROOM_PIXEL_SIZE
@@openDoors:
    ldi (hl), a
    
    ld de, right_door_fun
    ld a, d
    ldi (hl), a
    ld a, e
    ldi (hl), a
@noRightDoor:

    ld a, l
    ld (load_room_.next_object), a
    ld a, h
    ld (load_room_.next_object + 1), a
    
; \\\ add the doors as activable items in a room ///
