; //// IA function \\\\
AI:
  inc hl
  ldi a,(hl)
  ld (vectorisation_.p.1.y),a
  ld a,(hl)
  ld (vectorisation_.p.1.x),a
  ld a,(global_.isaac.y)
  ld (vectorisation_.p.2.y),a
  ld a,(global_.isaac.x)
  ld (vectorisation_.p.2.x),a
  call vectorisation ;   direction = vectorisation(enemy_p->x, enemy_p->y,isaac.x,isaac.y)

  ld b,a

  swap a
  and %00001111
  bit $3,a
  jr z,posit_x
  or %11110000
  posit_x:
  add (hl)
  ld (hl),a
  dec hl

  ld a,b
  and %00001111
  bit $3,a
  jr z,posit_y
  or %11110000
  posit_y:
  add (hl)
  ld (hl),a

  ret
; //// IA function \\\\
