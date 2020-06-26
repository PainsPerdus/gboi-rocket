# Display Background Tile

Function : display a rock at the position X and Y (in pixels)

| Label |   Type   | Size/Struct | Description                    |
| ----- | -------- | ----------- | ------------------------------ |
| a     | register | 1 byte      | x (+-16 pixels)                |
| b     | register | 2 bytes     | y (+-8pixels)                  |
| l     | register | 2 bytes     | ID of the first tile (out of 4)|

NOTE : x and y have to be divisible by 8. Undefined behaviour may occur otherwise.

We display a rock at the position (X,Y), relative to the 32x32 background Grid.
TODO: Compute those coordinate from pixel coordinate.

; ///// Computer top left position in the BG Map \\\\\

~~~C
hl = $9800 //Background Map Start
/// compute X \\\
X = x/8
\\\ compute X ///
/// compute 8*Y \\\
Y = y
note : we will have to multiply Y by 32. But instead , we take y (Y*8) and add it 4 times.
\\\ compute 8*Y ///

hl += 4*Y + X //position of tile depending of cols and rows
~~~

; \\\\\ Computer top left rock position /////

We need to use 16 bits additions and registers.  
Y is from 0 to 31, so we have to do `de=Y*8` by shifting left `e` 3 times.   
Then we do `add hl,de` 4 times to add 8*4=32 times Y to `hl`.  
We could just add 32 Y times to hl with a loop, but it's slower when Y>7.

; ///// Set the 4 tiles \\\\\

### First tile

First tile is the one pointed by `hl`.  
We load the first rock tile.

### Second tile

We increment `hl` to switch the the second tile.  
We load the second rock tile.

### Third tile
For the third tile, we need to switch to the line below.  
We add 31 to `hl` (32-1) because we already added 1  
We load the third rock tile.

### Fourth tile
We increment `hl` to switch to the fourth tile.  
We load the fourth rock tile.  

; \\\\\ Set the 4 tiles /////
