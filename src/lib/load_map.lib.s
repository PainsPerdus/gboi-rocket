; ////// function to load a room from its file \\\\\\
load_map:
    push bc
    push de

    ; /// init cursor positions \\\
    ; // element cursors \\
    ld de, global_.blockings
    ld hl, load_map_.next_blocking
    ldi (hl), d
    ld (hl), e
    ld de, global_.enemies
    ld hl, load_map_.next_enemy
    ldi (hl), d
    ld (hl), e
    ld de, global_.objects
    ld hl, load_map_.next_object
    ldi (hl), d
    ld (hl), e
    ; \\ element cursors //

    ; // next enemy to load \\
    ld a, (load_map_.map_address)
    ld h , a
    ld a, (load_map_.map_address + 1)
    ld l, a
    ld de, $1F
    add hl, de
    ld a, h
    ld (load_map_.next_to_load), a
    ld a, l
    ld (load_map_.next_to_load + 1), a
    ; \\ next enemy to load //

    ; // reset counters \\
    xor a
    ld (load_map_.blockings_written), a
    ld (load_map_.enemies_written), a
    ld (load_map_.objects_written), a
    ; \\ reset counters //
    ; \\\ init cursor positions ///

    ; /// start y loop \\\
    ld a, (load_map_.map_address)
    ld h, a
    ld a, (load_map_.map_address + 1)
    ld l, a
    ld a, $20
    ld b, a
@y_loop:
    ; \\ start y loop ///

    ; // start x loop \\
    ld a, $18
    ld c, a
@x_loop:
    ; \\ start x loop //






    ; // first element switch \\
    ld a, (hl)
    ld e, a
    and %11110000
    swap a
    ld d, a

    ; / case floor \
    and a
    jp z, @end_first
    ; \ case floor /

    ; / case rock \
    ld a, d
    cp $02
    jr nz, @@not_rock
    ld a, (load_map_.next_blocking)
    ld h, a
    ld a, (load_map_.next_blocking + 1)

    ld l, a
    ld a, ROCK_INFO
    ldi (hl), a
    ld a, b
    ldi (hl), a
    ld a, c
    ldi (hl), a

    ld a, h
    ld (load_map_.next_blocking), a
    ld a, l
    ld (load_map_.next_blocking), a
    ld hl, load_map_.blockings_written
    inc (hl)
    jp @end_first
    ; \ case rock /
@@not_rock
    ; \\ first element switch //
@end_first:







    ; // transition \\
    ld a, c
    add $10
    ld c, a
    ; \\ transition //






    ; // second element switch \\
    ld a, e
    and %00001111
    ld d, a

    ; / case floor \
    and a
    jp z, @end_second
    ; \ case floor /

    ; / case rock \
    ld a, d
    cp $02
    jr nz, @@not_rock
    ld a, (load_map_.next_blocking)
    ld h, a
    ld a, (load_map_.next_blocking + 1)

    ld l, a
    ld a, ROCK_INFO
    ldi (hl), a
    ld a, b
    ldi (hl), a
    ld a, c
    ldi (hl), a
    
    ld a, h
    ld (load_map_.next_blocking), a
    ld a, l
    ld (load_map_.next_blocking), a
    ld hl, load_map_.blockings_written
    inc (hl)
    jp @end_second
    ; \ case rock /
@@not_rock
    ; \\ second element switch //
@end_second:






    ; // end x loop \\
    ld a, (load_map_.map_address)
    ld h, a
    ld a, (load_map_.map_address + 1)
    ld l, a
    inc hl
    ld a, h
    ld (load_map_.map_address), a
    ld a, l
    ld (load_map_.map_address + 1), a

    ld a, c
    add $10
    ld c, a
    cp $98
    jp nz, @x_loop
    ; \\ end x loop //

    ; /// end y loop \\\
    ld a, b
    add $10
    ld b, a
    cp $90
    jp nz, @y_loop
    ; \\\ end y loop ///


    pop de
    pop bc
    ret
; \\\\\\ function to load a room from its file //////