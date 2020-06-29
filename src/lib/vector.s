//// Vectorisation function \\\\

Vectorisation:
  push bc
  push de

  ;Vector's X-axis
  ld a, (X1)
  ld b, a
  ld a, (X2)
  sub b
  ld b, a //Save X-axis's vector it in b

  ;Vector's Y-axis
  ld a, (Y1)
  ld c, a
  ld a, (Y2)
  sub c
  ld c, a //Save Y-axis's vector it in c

  call pgcd //pgcd(a,b) -> give it in a
  ld e, a//save the pgcd in e ?

  call roundDivision// b = b/a
  ld d, b
  ld b, c
  call roundDivision// b = b/a

  ld a, d

  pop de
  pop bc
  ret
\\\\ Vectorisation function ////

//// Integer Round Division \\\\
roundDivision:
  push de

  ld e, a
  ld a, b
  ld d, 0
  ;substract until getting 0 and save a counter in d
  @divisionCircle:
    sub e
    inc d
    jp nz, @divisionCircle

  ld b, d ;b = b/a

  pop de
  ret
\\\\ Integer Round Division ////

//// PGCD calculator \\\\
;Here I use the substraction's method to calculate the pgcd
pgcd:
  push de
  ld e, a //save a
  ld a, 0
  @pgcdCircle:
    ld d, a//save the result of the substraction
    ;to have the max of a and b
    sub b
    bit 7, a
    jp z, @bmax
    add b
    jp @afterbmax
    @bmax:
    add b
    ld e, a
    ld a, b
    ld b, e
    :mtn le max est dans a et le min dans b
    @afterbmax:

    sub b
    jp z, @pgcdCircle //when we finally get 0 as substract
  //take the last non-zero substract
  ld a, d

  pop de
  ret
  \\\\ PGCD calculator ////
