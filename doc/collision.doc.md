# Collisions

## Collision function

This is the first draft for a collision function.

### Label:

`collision`

### Parameters:

| Label | Type | Size/Struct |  Description  |
| ------------- | ------------- | ---------- | ----------- |
| collision_.p.1 | fixed address | point | Left Top corner of the first element checked |
| collision_.p.2 | fixed address | point | Left Top corner of the second element checked |
| collision_.hitbox1 | fixed address | 1 byte | Id of the hitbox of the first element checked |
| collision_.hitbox2 | fixed address | 1 byte | Id of the hitbox of the second element checked |

### Return:

| Label | Type | Size |  Description  |
| ------------- | ------------- | ---------- | ----------- |
| a | register |1 byte| 1 if collision detected, 0 else. |

### Modified values:

| Label | Type | Size/Struc |
| ------------- | ------------- | ---------- |
| a | register | 1 byte |
| hl | register | 2 bytes |
| collision_.p.1 | fixed address | point |
| collision_.p.2 | fixed address | point |

### Global variables used

| Label | Size |  Description  |
| ------------- | ---------- | ----------- |
| hitboxs_width[2]| 2*1 bytes| Array of the hitboxes width |
| hitboxs_height[2]| 2*1 bytes| Array of the hitboxes height |

### Global structs used

#### point

| Label | Size |  Description  |
| ------------- | ---------- | ----------- |
| x | 1 byte | abscissa of the point |
| y | 1 byte | ordinate of the point |

### Reserved memory:

| Label | Size/Struct |  Description  |
| ------------- | ---------- | ----------- |
| collision_.p.1 | point | Left Top corner of the first element checked |
| collision_.p.2 | point | Left Top corner of the second element checked |
| collision_.hitbox1| 1 bytes| Id of the hitbox of the first element checked |
| collision_.hitbox2| 1 bytes| Id of the hitbox of the second element checked |
| collision_.p_RD.1 | point | Right Down corner of the first element checked |
| collision_.p_RD.2 | point | Right Down corner of the second element checked |


### Pseudo code

~~~C
char collision(
  char collision_.p.1,
  char collision_.p.2,
  char collision_.hitbox1,
  char collision_.hitbox2){
    // INIT
    collision_.p_RD.1.x = collision_.p.1.x + hitboxs_width[collision_.hitbox1];
    collision_.p_RD.1.y = collision_.p.1.y + hitboxs_height[collision_.hitbox1];
    collision_.p_RD.2.x = collision_.p.2.x + hitboxs_width[collision_.hitbox2];
    collision_.p_RD.2.y = collision_.p.2.y + hitboxs_height[collision_.hitbox2];
    // COMPARE
    if (collision_.p.1.x > collision_.p_RD.2.x) // 1 is to the left off 2
      return 0;
    if (collision_.p.2.x > collision_.p_RD.1.x) // 2 is to the left off 1
      return 0;
    if (collision_.p.2.y > collision_.p_RD.1.y) // 1 is upper than 2
      return 0;
    if (collision_.p.1.y > collision_.p_RD.2.y) // 2 is upper than 1
      return 0;
    return 1;
}
~~~

* INIT generates the right/down points of the two objects from there hitboxs and left/up points.

* COMPARE checks if left of the first element is to the right of the right of the second element. If yes, there are no collision, 1 is to the left of 2. Then we check if 2 is to the left of 1, if 1 is upper than 2, and if 2 is upper than 1. After that, we know the two objects collide.

### Notes

This function is critical. It has to be optimized.

### TODO

* Optimisation, wait until the variables are needed before initialisating them.

* Find a way to tel if one element is already loaded.

* Can we efficiently detect the side of the collision?

* Does using a point instead of a hitbox for ine element improve the performance?



## collision_obstacles function

This function test the rectangles in argument collide with any obstacle.

### Label:

`collision_obstacles`

### Parameters:

| Label | Type | Size/Struct |  Description  |
| ------------- | ------------- | ---------- | ----------- |
| collision_.p.1 | fixed address | point | Left Top corner of the first element checked |
| collision_.hitbox1 | fixed address | 1 byte | Id of the hitbox of the first element checked |

### Return:

| Label | Type | Size |  Description  |
| ------------- | ------------- | ---------- | ----------- |
| a | register |1 byte| 1 if collision detected, 0 else. |

### Modified values:

| Label | Type | Size/Struc |
| ------------- | ------------- | ---------- |
| a | register | 1 byte |
| hl | register | 2 bytes |
| collision_.p.1 | fixed address | point |
| collision_.p.2 | fixed address | point |

### Global variables used

| Label | Size |  Description  |
| ------------- | ---------- | ----------- |
| hitboxs_width[2]| 2*1 bytes| Array of the hitboxes width |
| hitboxs_height[2]| 2*1 bytes| Array of the hitboxes height |

### Global structs used

#### point

| Label | Size |  Description  |
| ------------- | ---------- | ----------- |
| x | 1 byte | abscissa of the point |
| y | 1 byte | ordinate of the point |

### Reserved memory:

| Label | Size/Struct |  Description  |
| ------------- | ---------- | ----------- |
| collision_.p.1 | point | Left Top corner of the first element checked |
| collision_.p.2 | point | Left Top corner of the second element checked |
| collision_.hitbox1| 1 bytes| Id of the hitbox of the first element checked |
| collision_.hitbox2| 1 bytes| Id of the hitbox of the second element checked |
| collision_.p_RD.1 | point | Right Down corner of the first element checked |
| collision_.p_RD.2 | point | Right Down corner of the second element checked |


### Pseudo code

~~~C
char collision_obstacles(
  char collision_.p.1,
  char collision_.hitbox1){
  for (obstacle : global_.blockings){
    a = collision(collision_.p.1,
                  (obstacle.x,obstacle,y),
                  collision_.hitbox1,
                  obstacle.hitbox);
    if (a)
      return a;
  }
  return 0;
}
~~~
