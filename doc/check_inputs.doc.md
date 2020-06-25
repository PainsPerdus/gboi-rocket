# Input checker

## Main include

This code updates the values of Isaac regarding the states of the buttons.

### file to include:

`check_inputs.s`

### Parameters:

### Return:


### Modified values:

| Label | Type | Size/Struc |
| ------------- | ------------- | ---------- |
| a | register | 1 byte |
| b | register | 1 byte |
| c | register | 1 byte |
| hl | register | 2 bytes |
| global_.isaac.speed | fixed address | 1 byte |
| global_.isaac.direction | 1 byte | 2 bits indicate Isaac's direction (11 = up, 00 = down, 01 = right, 10 = left) (pos 1:0), 6 other bits are free |

### Global variables used

| Label | Size |  Description  |
| ------------- | ---------- | ----------- |
| global_.isaac.speed | 1 byte | Isaac speed (split in 2 x 4bits, x speed and y speed. [7:4]: x speed, [3:0]: y speed) |
| direction | 1 byte | 2 bits indicate Isaac's direction (11 = up, 00 = down, 01 = right, 10 = left) (pos 1:0), 6 other bits are free |

### Global structs used


#### Isaac

Content of the struct "isaac" :

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
| direction | 1 byte | 2 bits indicate Isaac's direction (11 = up, 00 = down, 01 = right, 10 = left) (pos 1:0), 6 other bits are free |


### Reserved memory:


### Pseudo code

~~~C
// INIT ARROW
(0xFFEE) = %00100000; // select the arrow keys
b = get_arrow_values();
// CHECK ARROWS
// speed_x = a[7:4], speed_y = a [3:0]
// global_.isaac.direction = c[1:0]
speed_x = 0;
speed_y = 0;
direction = 0;
if (down_arrow(b)){
	speed_y = 2;
	direction = %11;
}else if (up_arrow(b)){
	speed_x = -2;
	direction = %00;
}
if (right_arrow(b)){
	speed_x = 2;
	direction = %01;
}else if (left_arrow(b)){
	speed_x = -2;
	direction = %10;
}
global_.isaac.speed = [speed_x, speed_y];
global_.isaac.direction = [global_.isaac.direction[7:3],direction]
~~~

* INIT ARROW: Set $FF00 to select the arrow keys.

* SET SPEED: Set the speed according to the key pressed.

### Notes



### TODO

* In a future version, we will have to set the direction value too.

* Set the seep to other value when the speed upgrade is set.
