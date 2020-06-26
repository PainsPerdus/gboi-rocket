# Display Background Tile

Function : display a background element at the position x and y (in pixels)

| Label |   Type   | Size        | Description                                       |
| ----- | -------- | ----------- | --------------------------------------------------|
| A     | register | 1 byte      | x (x position of the element in pixels-8 pixels)  |
| B     | register | 1 byte      | y (y position of the element in pixels-16 pixels) |
| L     | register | 1 byte      | ID of the first tile (out of 4)                   |

Modifies: A, HL
Restores: BC, DE

So, if you want to display isaac on the screen at 0,0, you need to call the fonction with x = 0 and y = 0, because the screen starts at (x:-8, y:-16)

NOTE : x and y have to be multiples of 8. Undefined behaviour may occur otherwise.

We display an element at the position (x,y) in pixels.  
(X,Y) (capital letters) represent the positions of the element in the 32*32 background grid space.

## Computer top left position in the BG Map

### Compute X
~~~C
X = x/8
~~~

### Compute 8*Y

We already have y=8*Y, and we'll need to do 32*Y. 
So we just copy y into a 16 bits register and we'll add it 4 times. 

### Compute top left position
~~~C
hl = $9800 //Background Map Start
hl += 32*Y + X //Because background map is a 32*32 array
~~~

Note: We need to use 16 bits additions and registers to add to hl

## Set the 4 tiles

### First tile

First tile is the one pointed by `hl`.  
We load the first tile.

### Second tile

We increment `hl` to switch the the second tile.  
We load the second tile.

### Third tile
For the third tile, we need to switch to the line below.  
We add 31 to `hl` (32-1) because we already added 1  
We load the third tile.

### Fourth tile
We increment `hl` to switch to the fourth tile.  
We load the fourth tile.  

