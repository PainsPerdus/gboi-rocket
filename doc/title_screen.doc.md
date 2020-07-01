# Complete title_screen documentation

## Variables (title_screen.var.s)

| Label | Size | Description |
| ----- | ---- | ----------- |
| animation_counter | 1 byte | Counter for title screen animation. |

## Init (title_screen.init.s)

Basically, we are going to use Block 0 and 1 for the first part of the background, they change the mapping to Block 1 and Block 2 for the second part. All reusable tiles between the two parts will be in Block 1. 
To use more than 256 tiles for the background, we have to change the blocks used during HBlank after a certain line when drawing the screen. This is possible by modifying the LCDC register. 

### Init Variables

| Label | Size | Value |
| ----- | ---- | ----------- |
| animation_counter | 1 byte | 0 |

### Copy Tiles

Copy tiles from the 3 spritesheets to the corresponding 3 VRAM blocks.  
- We use Block 0 for the top of the screen.
- We use Block 1 for the rest of the top of the screen and recyclable tiles.
- We use Block 2 for the bottom of the screen.

### Clear BG

Fill the whole background with first tile (pretty standard)

### Copy Background Maps

In order to avoid writting hundreds of lines of assembly, we prepared some data containing the two background maps and stores them in ROM.  
This process was very tedious and done by hand.  
Now we copy them into the 2 background maps. We are going to use the first background map to store the first animation frame, and the second background map for the second animation frame. They we again use the LCDC register to switch during VBlank when we change the animation frame from the first background map to the second one.  
It seems the gameboy was engineered for that kind of stuff.

### ...

Then we clearn OAM, init color Palettes, and enable screen (we don't enable sprites).
This is almost the same as in display.init.s

## VBlank (title_screen.vbl.s)

### Setup LCDC tile data block

As we reset the tile data block in HBlank to switch to the blocks 1-2, we need to set it back to blocks 0-1.

### Update Animatoin

We don't run the animation every frame because it would be too fast, so we have a counter counting the number of vblank since the animation frame was last changed.  
Then to update the animation we just have to use bit 3 of LCDC, BG Tile Map Display Select

### Check Select Pressed

We check if the select button is pressed, if so we quit the title screen by changing the state to `GAMESTATE_PLAYING`.
