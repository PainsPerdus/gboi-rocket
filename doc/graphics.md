# Documentation for graphics.s

## Update sprites position

We start by updating sprite positions in OAM because we need to do it before the end of VBlank. After, the OAM will be locked. 

### Isaac

TODO : add constants for sprite position in OAM  
We update each sprite posX and posY according to isaac posY and posY.
For that we start by copying the positions in registers to save time, then we update the sprites in the following order:  
- top left
- top right
- bottom left
- bottom right
