rng:
@generate
    ld a, (rng_state.x)
    ld b, a
    swap a
    and $F0
    xor b; t = x^(x<<4)
    ld b, a
    sla a
    xor b; (t<<1) ^ t
    ld h, a
    ld a, (rng_state.y)
    ld (rng_state.x), a ; x = y
    ld a, (rng_state.z)
    ld (rng_state.y), a ; y = z
    ld a, (rng_state.a)
    ld (rng_state.z), a ; z = a
    ld b, a
    srl a
    xor b ; z ^ (z >> 1) 
    xor h 
    ld (rng_state.a), a; a = z ^ (z >> 1) ^ t ^ (t << 1)
    ret

