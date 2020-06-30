.DEFINE LEVEL_GEN_INITIAL_LEVEL 11

level_gen_init:
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
    dec b ; as already contains height : 1 iteration averted
@mult_loop: ; Mélissa, I hate you right now :)
    add l
    dec b
    jr nz, @mult_loop ; for (b=height-1; b > 0; b--) a += l
    ; a = width * height
    ld b, a
    xor a
    ld HL, level_gen_.map
@init_map_loop:
    


