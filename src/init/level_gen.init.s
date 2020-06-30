.DEFINE LEVEL_GEN_INITIAL_LEVEL 11

level_gen_init:
    push DE
@init_level:
    ld HL, level_gen_.level
    ld (HL), LEVEL_GEN_INITIAL_LEVEL
@init_size:
    ld a, (HL)
    ld b, a
    srl b
    inc HL ; HL = level_gen_.height
    ld (HL), b
    sub b
    inc HL ; HL = level_gen_.width
    ld (HL), a
    ; start multipliation
    ld l, a
    ld h, b
    push HL ; save height : h width : l
    dec b ; as already contains height : 1 iteration averted
@@mult_loop: ; Mélissa, I hate you right now :)
    add l
    dec b
    jr nz, @@mult_loop ; for (b=height-1; b > 0; b--) a += l
    ld d, a ; save for later
    ; a = width * height
    ; initialize map
    ld b, a
    xor a
    ld HL, level_gen_.map
@init_map_loop:
    ldi (HL), a
    dec b
    jr nz, @init_map_loop
    ; recover height : h width : l
    pop HL
    ld b, l ; b = width
    ld a, h
    srl a
    bit 0, h
    jr z, @noaddi
    inc a
@noaddi:
    ld h, a ; h  = height/2 + 1 or 0

    ld a, l
    srl a
    bit 0, l
    jr z, @noaddj
    inc a
@noaddj:
    ld l, a ; l = width/2 + 1 or 0

    dec h
    dec l

    xor a
@@mult_loop: ; Mélissa, I hate you right now :)
    add h
    dec b
    jr nz, @@mult_loop

    

    pop DE


