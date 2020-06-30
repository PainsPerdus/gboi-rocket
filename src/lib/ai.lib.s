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

  ret
; //// IA function \\\\
