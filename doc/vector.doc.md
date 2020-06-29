~~~
;Vectorisation
/* @requires X1 Y1 unsigned coordinates of position1
             X2 Y2 unsigned coordinates of position2
   @ensures a pseudo-unitary vector from position1 to position2
             X coordinate of the vector in a
             Y coordinate of the vector in b*/
~~~

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

~~~
;abs
/* @ensures two's complement value in b
   @ensures absolute value of b returned in a/*
~~~
