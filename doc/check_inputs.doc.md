# Input checker

## Main include

This code updates the values of Isaac regarding the states of the buttons.

We check the values of the inputs in VBlank, and save them in the `check_inputs_.keys_values` variables.

In the main loop we update isaac values.

### file to include:

`check_inputs.var.s`

`check_inputs.init.s`

`check_inputs.s`

`check_inputs.vbl.s`

### Reserved memory:

| Label | Size |  Description  |
| ------------- | ---------- | ----------- |
| check_inputs_.keys_values | 1 byte | Values of the keys. |
| check_inputs_.keys_values[0] | 1 bit | Right Key. |
| check_inputs_.keys_values[1] | 1 bit | Left Key. |
| check_inputs_.keys_values[2] | 1 bit | Up Key. |
| check_inputs_.keys_values[3] | 1 bit | Down Key. |
| check_inputs_.keys_values[4] | 1 bit | A Key. |
| check_inputs_.keys_values[5] | 1 bit | B Key. |
| check_inputs_.keys_values[6] | 1 bit | Select Key. |
| check_inputs_.keys_values[7] | 1 bit | Start Key. |

# Defines

| Label | Value | Description |
| ----- | ----- | ----------- |
| RG_KEY  | 0 | Index of the right key value in check_inputs_.keys_values  |
| LF_KEY  | 1 | Index of the left key value in check_inputs_.keys_values   |
| UP_KEY  | 2 | Index of the up key value in check_inputs_.keys_values     |
| DW_KEY  | 3 | Index of the down key value in check_inputs_.keys_values   |
| A_KEY   | 4 | Index of the A key value in check_inputs_.keys_values      |
| B_KEY   | 5 | Index of the B key value in check_inputs_.keys_values      |
| SEL_KEY | 6 | Index of the select key value in check_inputs_.keys_values |
| ST_KEY  | 7 | Index of the start key value in check_inputs_.keys_values  |


### Modified values in loop:

| Label | Type | Size/Struc |
| ------------- | ------------- | ---------- |
| a | register | 1 byte |
| b | register | 1 byte |
| c | register | 1 byte |
| hl | register | 2 bytes |
| global_.isaac.speed | fixed address | 1 byte |
| global_.isaac.direction | fixed address | 1 byte
| global_.isaac.tears | fixed address | 1 byte |

### Modified values in vblank:

| Label | Type | Size/Struc |
| ------------- | ------------- | ---------- |
| a | register | 1 byte |
| b | register | 1 byte |

### Global variables used in loop

| Label | Size |  Description  |
| ------------- | ---------- | ----------- |
| global_.isaac.speed | 1 byte | Isaac speed (split in 2 x 4bits, x speed and y speed. [7:4]: x speed, [3:0]: y speed) |
| global_.isaac.direction | 1 byte | 2 bits indicate Isaac's direction (11 = up, 00 = down, 01 = right, 10 = left) (pos 1:0), 6 other bits are free |
| global_.isaac.tears | 1 byte | 3 bits for horizontal speed of tears (pos 5:3), 3 bits for vertical speed (pos 2:0), 1 flag for "A was pressed the frame before" in postion (pos 7), 1 flag for "B  was pressed" (pos 6)|

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


### Pseudo code in loop

~~~C
// INIT ARROW
b = (check_inputs_.keys_values);
// CHECK ARROWS
// speed_x = a[7:4], speed_y = a [3:0]
speed_x = 0;
speed_y = 0;
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

// SET AB
if (A(b))	// bit $0,b
	set(global_.isaac.tears.a);
else
	res(global_.isaac.tears.a);
if (B(b)) // bit $0,a
	set(global_.isaac.tears.b);
else
	res(global_.isaac.tears.b);

~~~

* INIT ARROW: Set $FF00 to select the arrow keys.

* CHECK ARROWS: Set the speed and direction according to the key pressed.

* INIT AB: Set $FF00 to select the button keys.

* CHECK AB: Set the a/b flags according to the key pressed.

### Notes



### TODO

* In a future version, we will have to set the direction value too.

* Set the seep to other value when the speed upgrade is set.
