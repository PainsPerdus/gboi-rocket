# Vectorisation function

Takes `vectorisation_.p.1` and `vectorisation_.p.2` as arguments (points).

Return with `a` the general direction of p2-p1. (a[7:4]=dx, a[3:0]=dy, signed value).

modifies `vectorisation_.direction` (point), `a` and `b`

## Pseudo-code of vectorisation function

~~~python
if abs(direction.x) < abs(direction.y)//2:
    direction.x = 0
if abs(direction.y) < abs(direction.x)//2:
    direction.y = 0
if (direction.x < 0):
    direction.x = -1
if (direction.x > 0):
    direction.x = 1
if (direction.y < 0):
    direction.y = -1
if (direction.y > 0):
    direction.y = 1
~~~

## abs function

Takes `a` (signed values in two's complement).

Return with `a` the absolute value

modifies `a`
