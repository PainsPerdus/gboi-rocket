//// Vectorisation function \\\\

Vectorisation:
  push bc
  push de

  ;Vector's X-axis
  ld a, (X1)
  ld b, a
  ld a, (X2)
  sub b
  ld (dx), a //Save X-axis's vector it in dx

  ;Vector's Y-axis
  ld a, (Y1)
  ld c, a
  ld a, (Y2)
  sub c
  ld (dy), a //Save Y-axis's vector it in dy


  ;abs(direction.x) < abs(direction.y)//2:
  ld a, (dy)
  call abs
  ld b, a
  ld a, (dx)
  call abs
  sr1 b
  sub b
  bit 7, a
  jr nz, @uncheckedCondition1
  ld a, 0
  ld (dx), a

@uncheckedCondition1:
  ;abs(direction.y) < abs(direction.x)//2:
  ld a, (dx)
  call abs
  ld b, a
  ld a, (dy)
  sr1 b
  sub b
  bit 7, a
  jp nz, @uncheckedCondition2
  ld a, 0
  ld (dy), a
  @uncheckedCondition2:

  ;Condition on x
  ld a, (dx)
  bit 7, a

  jp nz, @uncheckedCondition3
  ld a, %11110000
  ld (dx), a

  jr @uncheckedCondition4

@uncheckedCondition3:
  and a
  jr z, @uncheckedCondition4

  ld a, %00010000
  ld (dx), a

@uncheckedCondition4:

  ;Condition on y
  ld a, (dy)
  bit 7, a

  jr nz, @uncheckedCondition5
  ld a, %00001111
  ld (dy), a
  jr @uncheckedCondition6

@uncheckedCondition5:

  and a

  jr z, @uncheckedCondition6

  ld a, %00000001
  ld (dy), a

  @uncheckedCondition4:

  pop de
  pop bc

\\\\ Vectorisation function ////

//// Albsolute value function \\\\
@abs:
  bit 7, a
  jp nz, @bpositive:

  cpl
  add 1

@bpositive:
  ret

\\\\ Albsolute value function ////
