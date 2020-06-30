; //// IA function \\\\
AI:
  inc hl
  ldi a,(hl)
  ld (vectorisation_.p.1.y),a
  ldi a,(hl)
  ld (vectorisation_.p.1.x),a
  ld a,(global_.isaac.y)
  ld (vectorisation_.p.2.y),a
  ld a,(global_.isaac.x)
  ld (vectorisation_.p.2.x),a
  call vectorisation ;   direction = vectorisation(enemy_p->x, enemy_p->y,isaac.x,isaac.y)
  inc hl
  ld (hl),a

; ///// RANDOM DIRECTION \\\\\
  push hl
  call rng
  pop hl
  bit 1,a
  jp nz,@not_random ; p = 1/2
  push hl
  push de
  call rng
  and %00000111
  ld e,a
  ld d,0
  ld hl,ai_.directions
  add hl,de
  ld a,(hl)
  pop de
  pop hl
  ld (hl),a
@not_random:
; \\\\\ RANDOM DIRECTION /////

  ret
; \\\\ IA function ////
