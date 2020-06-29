# Display background doors

Function : displays 1 to 4 doors depending of room configuration. Doors can be all opened or all closed.

Modifies: A, HL  
Restores: BC, DE  
Arguments:  A, B

| Label |   Type   | Size        | Description                                       |
| ----- | -------- | ----------- | --------------------------------------------------|
| A     | register | 1 byte      | doors to display (00001111 = all doors; 00001000 = down only))           |
| B     | register | 1 byte      | doors status ; 0000001 = doors closed, 00000000 = doors opened |

details for A argument : only bit 0 to 3 are tested.
0 : up door
1 : left door
2 : right door
3 : down door


## Displaying a door

Each door is composed of 6 8x8 tiles.

For each door, we display the tiles in the order imposed by spritesheet.
Each door has two "corners" tiles. the address in BG grid are hardcoded.

the four central tiles of each door are the only ones changing when a door closes. 
"Closing" the door consist in adding the door status (0 or 1) to the current tile id.
these are 2x2 squares :

display the first one
next grid box
next tile id
display second
jump to second line (first one + 31)
display the third one
next grid box
next tile id
display fourth

## Selecting which doors to display

door selector Byte is stored in d

~~~C

if (bit0(d))
{
	draw_up_door()
}
if (bit1(d))
{
	draw_left_door()
}
if (bit2(d))
{
	draw_right_door()
}
if (bit3(d))
{
	draw_down_door()
}

~~~

