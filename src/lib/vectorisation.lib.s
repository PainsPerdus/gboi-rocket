;//// Vectorisation function \\\\

vectorisation:
  ld b,b
  ;Vector's X-axis
  ld a, (vectorisation_.p.1.x)
  ld b,a
  ld a, (vectorisation_.p.2.x)
  sub b
  ld (vectorisation_.direction.x), a ;Save X-axis's vector it in dx

  ;Vector's Y-axis
  ld a, (vectorisation_.p.1.y)
  ld b, a
  ld a, (vectorisation_.p.2.y)
  sub b
  ld (vectorisation_.direction.y), a ;Save Y-axis's vector it in dy

  ;abs(direction.x) < abs(direction.y)//2:
  ld a, (vectorisation_.direction.y)
  call @abs
  ld b, a
  ld a, (vectorisation_.direction.x)
  call @abs
  srl b
  sub b
  bit 7, a
  jr z, @uncheckedCondition1
  xor a
  ld (vectorisation_.direction.x), a

@uncheckedCondition1:
  ;abs(direction.y) < abs(direction.x)//2:
  ld a, (vectorisation_.direction.x)
  call @abs
  ld b, a
  ld a, (vectorisation_.direction.y)
  call @abs
  srl b
  sub b
  bit 7, a
  jp z, @uncheckedCondition2
  ld a, 0
  ld (vectorisation_.direction.y), a
@uncheckedCondition2:


  ;Condition on x
  ld a, (vectorisation_.direction.x)
  bit 7, a
  jp z, @uncheckedCondition3
  ld a,%11110000
  ld (vectorisation_.direction.x), a

  jr @uncheckedCondition4

@uncheckedCondition3:
  and a
  jr z, @uncheckedCondition4

  ld a, %00010000
  ld (vectorisation_.direction.x), a

@uncheckedCondition4:

  ld a,(vectorisation_.direction.x)


  ;Condition on y
  ld a, (vectorisation_.direction.y)
  bit 7, a

  jr z, @uncheckedCondition5
  ld a, %00001111
  ld (vectorisation_.direction.y), a
  jr @uncheckedCondition6

@uncheckedCondition5:

  and a

  jr z, @uncheckedCondition6

  ld a, %00000001
  ld (vectorisation_.direction.y), a

  @uncheckedCondition6:

  ld a,(vectorisation_.direction.x)
  ld b,a
  ld a,(vectorisation_.direction.y)
  or b

  ret

;\\\\ Vectorisation function ////

;//// Albsolute value function \\\\
@abs:
  bit 7, a
  jp z, @@positive
  cpl
  inc a
@@positive:
  ret

;\\\\ Albsolute value function ////
