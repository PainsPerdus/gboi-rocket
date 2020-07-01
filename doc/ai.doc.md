# IA

## IA function

A simple IA that follow Isaac.

### Label:

`AI`

### Parameters:

| Label | Type | Size/Struct |  Description  |
| ------------- | ------------- | ---------- | ----------- |
| hl | register | 2 bytes | Address to the monster. |


### Return:

### Modified values:

| Label | Type | Size/Struc |
| ------------- | ------------- | ---------- |
| (hl) | Variable in RAM | enemy |
| a | register | 1 byte |
| b | register | 1 byte |
| hl | register | 2 bytes |

`vectorisation_.p.1` and `vectorisation_.p.2`

### Global variables used

| Label | Size |  Description  |
| ------------- | ---------- | ----------- |
| Isaac| isaac | Isaac |

### Global structs used

| Label | Size/Struct | Description |
| ----- | ---- | ----------- |
| x | 1 byte | abscissa of Isaac |
| y | 1 byte | ordinate of Isaac |
| hp | 1 byte | health point of Isaac |
| dmg | 1 byte | damage dealt by Isaac |
| upgrades | 2 bytes | upgrades earned by Isaac (flags, to be defined) |
| range | 1 byte | 7 bits for range of Isaac's tears (pos 6:0), 1 flag that tells if a tear was shot during the previous image (pos 7)|
| speed | 1 byte | Isaac speed (split in 2 x 4bits, x speed (pos 7:4) and y speed (pos 3:0)) |
| tears | 1 byte | 3 bits for horizontal speed of tears (pos 5:3), 3 bits for vertical speed (pos 2:0), 1 flag for "A was pressed the frame before" in postion (pos 7), 1 flag for "B  was pressed" (pos 6)|
| recover | 1 byte | recovery time |
| bombs | 1 byte | number of bombs Isaac has |
| direction | 1 byte | 2 bits indicate Isaac's direction (00 = up, 11 = down, 10 = right, 01 = left) (pos 1:0), 6 other bits are free |

### Reserved memory:


### Pseudo code

~~~C
char collision(
  enemy* enemy_p)
  direction = vectorisation(enemy_p->x,
                            enemy_p->y,
                            isaac.x,
                            isaac.y
                          );
  enemy.x += direction.dx
  enemy.y += direction.dy

}
~~~

### Notes



### TODO

* Do different stuff depending on the type of the ennemy.
