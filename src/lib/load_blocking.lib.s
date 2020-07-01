; /// add the bloching element whose info is stored in e \\\
    ld a, (load_map_.next_blocking)
    ld h, a
    ld a, (load_map_.next_blocking + 1)
    ld l, a

    ld a, e
    ldi (hl), a
    ld a, b
    ldi (hl), a
    ld a, c
    ldi (hl), a

    ld a, h
    ld (load_map_.next_blocking), a
    ld a, l
    ld (load_map_.next_blocking + 1), a
    ld hl, load_map_.blockings_written
    inc (hl)
; \\\ add a blocking element ///