; /// add the doors as activable items in a room \\\
    ld hl, load_map_.map_info
    ld b, (hl)
    ld a, (load_map_.next_object)
    ld h, a
    ld a, (load_map_.next_object + 1)
    ld l, a

    ;top door
    bit ROOM_INFO_DOOR_UP_FLAG, b
    jr z, @noTopDoor
    ld a, VDOOR_INFO
    ldi (hl), a

    bit ROOM_INFO_ALIVE_FLAG, b
    jr nz, @@closeDoors
    ld a, $00+$12
    jr @@openDoors
@@closeDoors:
    ld a, $00
@@openDoors:
    ldi (hl), a

    ld a, $54
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
    ld a, $A0-$12
    jr @@openDoors
@@closeDoors:
    ld a, $A0
@@openDoors:
    ldi (hl), a

    ld a, $54
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
    ld a, $54
    ldi (hl), a

    bit ROOM_INFO_ALIVE_FLAG, b
    jr nz, @@closeDoors
    ld a, $00+$0A
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
    ld a, $54
    ldi (hl), a

    bit ROOM_INFO_ALIVE_FLAG, b
    jr nz, @@closeDoors
    ld a, $A0-$0A
    jr @@openDoors
@@closeDoors:
    ld a, $A0
@@openDoors:
    ldi (hl), a
    
    ld de, right_door_fun
    ld a, d
    ldi (hl), a
    ld a, e
    ldi (hl), a
@noRightDoor:

    ld a, h
    ld (load_map_.next_object), a
    ld a, l
    ld (load_map_.next_object + 1), a
    
; \\\ add the doors as activable items in a room ///
