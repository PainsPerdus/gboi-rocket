# init.s documentation

## TODO : document initialization
Everybody has his own doc for this part, so we need to make one in common.
This code is all from the pong tutorial.

## Prepare isaac sprite

### Initialize variables
We initialize isaac posX and posY with default values.

### Setup OAM
There are 4 sprites for isaac, in this order in the ROM:  
 - top left
 - top right
 - bottom left
 - bottom right
We put their position in the OAM according to isaac PosX and PosY. 
(TODO: for now, we use a fixed posX and posY in b and c, we need to load that from memory)

