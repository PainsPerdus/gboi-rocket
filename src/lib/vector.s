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
  ld b, a
  call abs
  ld d, a //d = abs(direction.x)


  ;Vector's Y-axis
  ld a, (Y1)
  ld c, a
  ld a, (Y2)
  sub c
  ld (dy), a //Save Y-axis's vector it in dy
  ld b, a
  call abs
  ld e, a //e = abs(direction.y)

  ;abs(direction.x) < abs(direction.y)//2:
  ld a, d
  ld b, e
  sr1 b
  sub b
  bit 7, a
  jp nz, @uncheckedCondition1
  ld a, %00000000
  ld (dx), a
  @uncheckedCondition1:

  ;abs(direction.x) < abs(direction.y)//2:
  ld a, e
  ld b, d
  sr1 b
  sub b
  bit 7, a
  jp nz, @uncheckedCondition2
  ld a, %00000000
  ld (dy), a
  @uncheckedCondition2:

  ;Condition on x
  ld a, (dx)
  bit 7, a

  jp nz, @uncheckedCondition3
  ld a, %00001111
  ld (dx), a

  jp @uncheckedCondition4

  @uncheckedCondition3:
  sub 1
  bit 7, a
  jp z, @uncheckedCondition4

  ld a, %00000001
  ld (dx), a

  @uncheckedCondition4:

  ;Condition on y
  ld a, (dy)
  bit 7, a

  jp nz, @uncheckedCondition5
  ld a, %00001111
  ld (dy), a
  jp @uncheckedCondition6

  @uncheckedCondition5:
  sub 1
  bit 7, a

  jp z, @uncheckedCondition6

  ld a, %00000001
  ld (dy), a

  @uncheckedCondition4:

  pop de
  pop bc

\\\\ Vectorisation function ////

//// Albsolute value function \\\\
@abs:
  bit 7, b
  jp nz, @bpositive:

  cpl
  add 1

  @bpositive:
  ret


\\\\ Albsolute value function ////
