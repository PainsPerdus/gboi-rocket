; /// add the bloching element whose info is stored in e \\\
    ld a, (load_room_.next_blocking)
    ld l, a
    ld a, (load_room_.next_blocking + 1)
    ld h, a

    ld a, e
    ldi (hl), a
    ld a, b
    ldi (hl), a
    ld a, c
    ldi (hl), a

    ld a, l
    ld (load_room_.next_blocking), a
    ld a, h
    ld (load_room_.next_blocking + 1), a
; \\\ add a blocking element ///
