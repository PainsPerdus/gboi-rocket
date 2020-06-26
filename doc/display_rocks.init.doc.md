# Display Rocks

We display a rock at the position (X,Y), relative to the 32x32 background Grid.
TODO: Compute those coordinate from pixel coordinate.

## Compute top left rock position

~~~C
hl = $9800 //Background Map Start
hl += 32*Y + X
~~~
We need to use 16 bits additions and registers.  
Y is from 0 to 31, so we have to do `de=Y*8` by shifting left `e` 3 times.   
Then we do `add hl,de` 4 times to add `8*4=32` times Y to `hl`.  
We could just add 32 Y times to hl with a loop, but it's slower when Y>7.

## Set rock 4 tiles

### First tile

First tile is the one pointed by `hl`.
We load the first rock tile.

### Second tile

We increment `hl` to switch the the second tile.
We load the second rock tile.

### Third tile


### Fourth tile

