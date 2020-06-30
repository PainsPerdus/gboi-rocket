; /////// SETUP TEARS HBLANK OPCODE \\\\\\\
ld bc, OAM_ISAAC_TEARS ;OAM position of isaac bullets
ld hl, DISPLAY_RAM_OPCODE_START ; Start OAM critical section
ld (hl), $00 ; NOP
/*ld (hl), $21  ; ld hl, NNnn
inc l
ld (hl), c  ; nn //Tear sprite Y pos address in OAM low byte
inc l
ld (hl), b  ; NN //Tear sprite Y pos address in OAM high byte
inc l
ld (hl), $36  ; ld (hl), yy
inc l
ld (hl), $35   ; yy //Tear new Y position
inc l
ld (hl), $2E  ; ld l, nn+1 (trick to inc l without changing flags)
inc l
inc c
ld (hl), c  ; nn+1 //Tear sprite X pos address in OAM low byte
inc l
ld (hl), $36  ; ld(hl), xx
inc l
ld (hl), $20   ; xx //Tear new X position*/
inc l ; Out of OAM critical section
ld (hl), $E1 ; pop hl
inc l ; We can do inc l instead of inc hl because we only have $00FF bytes avaliable
ld (hl), $D9 ; reti
; \\\\\\\ SETUP TEARS HBLANK OPCODE ///////
