; /!\ NEVER CALL THIS!!! THIS IS MEANT TO BE COPIED IN HRAM
start_dma_in_ROM:
  ld a, SHADOW_OAM_START / $100
  ldh  ($46),a ;start DMA transfer (starts right after instruction)
  ld  a,$28      ;delay...
@wait:           ;total 4x40 cycles, approx 160 μs
  dec a          ;1 cycle
  jr  nz,@wait    ;3 cycles
  ; Here, we NEED to have a relative jump to jump to the @wait in HRAM, not in ROM
  ret


