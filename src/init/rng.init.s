
rng_init:
    ld a, 1
    ld (rng_state.a), a
    xor a
    ld (rng_state.x), a
    ld (rng_state.y), a
    ld (rng_state.z), a