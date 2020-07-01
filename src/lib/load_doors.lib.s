; /// add the doors as activable items in a room \\\
    ld a, (load_map_.map_address)
    ld h, a
    ld a, (load_map_.map_address + 1)
    ld l, a
    ld b, (hl)
    ld a, (load_map_.next_object)
    ld h, a
    ld a, (load_map_.next_object + 1)
    ld l, a

    ;top door
    bit 7, b
    jr z, @noTopDoor
    ld a, VDOOR_INFO
    ldi (hl), a
    ld a, $10
    ldi (hl), a
    ld a, $54
    ldi (hl), a
    ld de, $0000 ; // TODO add door function
    ld a, d
    ldi (hl), a
    ld a, e
    ldi (hl), a
@noTopDoor

    ;bottom door
    bit 6, b
    jr z, @noBottomDoor
    ld a, VDOOR_INFO
    ldi (hl), a
    ld a, $A0
    ldi (hl), a
    ld a, $54
    ldi (hl), a
    ld de, $0000 ; // TODO add door function
    ld a, d
    ldi (hl), a
    ld a, e
    ldi (hl), a
@noBottomDoor:

    ;left door
    bit 5, b
    jr z, @noLeftDoor
    ld a, HDOOR_INFO
    ldi (hl), a
    ld a, $54
    ldi (hl), a
    ld a, $08
    ldi (hl), a
    ld de, $0000 ; // TODO add door function
    ld a, d
    ldi (hl), a
    ld a, e
    ldi (hl), a
@noLeftDoor:

    ;right door
    bit 4, b
    jr z, @noRightDoor
    ld a, HDOOR_INFO
    ldi (hl), a
    ld a, $54
    ldi (hl), a
    ld a, $A8
    ldi (hl), a
    ld de, $0000 ; // TODO add door function
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