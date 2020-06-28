//// Vectorisation function \\\\

Vectorisation:
  push c
  push d
  push e

  ;Vector's X-axis
  ld a, X2
  sub X1
  ld b, a //Save it in b

  ;Vector's Y-axis
  ld a, Y2
  sub Y1
  ld c, a //Save it in c

  call pgcd //pgcd(a,b) -> give it in a
  ld e, a//save the pgcd in e ?

  call roundDivision// b = b/a
  ld d, b
  ld b, c
  call roundDivision// b = b/a


  pop e
  pop d
  pop c
  ret
\\\\ Vectorisation function ////

//// Integer Round Division \\\\
roundDivision:
  push d
  push e

  ld e, a
  ld a, b
  ld d, 0
  ;substract until getting 0 and save a counter in d
  @divisionCircle:
    sub e
    inc d
    jp nz, @divisionCircle

  ld b, d ;b = b/a

  pop e
  pop d
  ret
\\\\ Integer Round Division ////

//// PGCD calculator \\\\
;Here I use the substraction's method to calculate the pgcd
pgcd:
  push d
  push e
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

  pop e
  pop d
  ret
  \\\\ PGCD calculator ////
