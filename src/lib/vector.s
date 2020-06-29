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
  ld d, a


  ;Vector's Y-axis
  ld a, (Y1)
  ld c, a
  ld a, (Y2)
  sub c
  ld (dy), a //Save Y-axis's vector it in dy
  ld b, a
  call abs
  ld e, a

  ;compare abs(direction.x) et abs(direction.y)
  sub d


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

    if abs(direction.x) < abs(direction.y):
      direction.x = 0
    if abs(direction.y) < abs(direction.x):
      direction.y = 0
    if (direction.x < 0):
      direction.x = -1
    if (direction.y > 0):
      direction.y = 1
    if (direction.y < 0):
      direction.y = -1
    if (direction.y > 0):
      direction.y = 1
    return direction

    1 = %0001, -1 = %1111

  pop de
  pop bc
  ret
