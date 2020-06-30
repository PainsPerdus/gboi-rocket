# Initialize display 

## Initialize Variables

| Label                      | Value |
| -------------------------- | ----- |
| _display.isaac.frame       | $0    |
| _display.isaac.shoot_timer | $0    |
| _display.isaac.walk_timer  | $0    |

## Load Tiles

Here we copy all the used tiles from ROM to VRAM.  
We have two sets of tiles to copy, the sprite tiles and the background tiles.
For each set, we are going to do the same process:  
`BC` stores the number of bytes to copy and is calculated as such :
~~~C
BC = n * 16 //Each sprite is 16 bytes (8*8/4 because 4 pixels per byte)
~~~
Where `n` is the number of sprites (currently 14)

Due to the number of sprites, we need to use a 16 bits register `BC` to count the bytes. As `dec bc` doesn't update the `Z` register, we need to update it manually to test if `BC` is not zero. 
~~~nasm
dec bc
ld a,b
or c ; this updates correctly the Z register
~~~

### Sprite Tiles ###

We copy the sprite tiles from ROM to VRAM.  
In ROM, sprite tiles are at the label SpriteTiles. In VRAM we need to copy them to SPRITE_TILES_START_ADDRESS.
We need to copy SPRITE_TILES_NUMBER sprites, so SPRITE_TILES_NUMBER * 16 bytes. 
We can have a maximum of 256 sprite tiles. 

### Background Tiles ### 

We copy the background tiles from ROM to VRAM.  
In ROM, background tiles are at the label BackgroundTiles. In VRAM we need to copy them to BACKGROUND_TILES_START_ADDRESS.
We need to copy BACKGROUND_TILES_NUMBER sprites, so BACKGROUND_TILES_NUMBER * 16 bytes.  
We can have a maximum of 128 background tiles. 


## Clear BG

BG currently contains the Nitendo Logo, so we need to clear it. 
The BG is 32*32 tiles. $9800 where the first background map is defined. We need to fill all tiles with background tile id 0. We'll add later actual tiles, this is just for safety so that all the background is cleared and doesn't contain random tiles in real hardware.  

## Drawing walls
We have to draw 16px large walls around the room. We work in a 20x18 area in the BG grid.
de i used as loop iterator
bc is used to keep the distance to the next line in the BG grid

the walls are display by order of appearance in the BG grid.

# upper wall
For the first two lines, we use two loop.
first loop draws 20 basic wall tiles
skip to next line (32 -20 = 12)
draw two hardcoded tiles for the left corner
second loop draws 16 wall tiles
draw two hardcoded tiles for the right corner

# side walls
draw first outer wall tile
draw first inner wall tile
skip to the other side (18 - 2 = 16)
draw second inner wall tile
draw second outer wall tile
skip to next line (32 -20 = 12)

# down wall
same logic as upper wall section.

## Clear OAM

There are 40 sprites in the OAM, each sprites take up 4 bytes, so we need to clear the 40*4 bytes of the OAM and set everything to 0.

## Load Sprites

### Isaac Sprites

As we change the sprites values in OAM, we don't need to set them up here. All flags are set to $00 when we clear the OAM.

### Setup Isaac Tears Sprites

We setup the OAM tears sprites.   
There are OAM_ISAAC_TEARS_SIZE bullets, and we start storing them at address OAM_ISAAC_TEARS.   
Here is what we're going to do (hold on to your assembly)   
We're going to reserve only OAM_ISAAC_TEARS_SIZE sprites for the bullets. However, we want to display way more than that!  
So during the HBlank interrupt, we're going to reuse those sprites and update the positions to show more sprites. Please see [blackmagic.s](blackmagic.doc.md) for more info. 

## Init Color Palettes

We initialize a basic color palette (in same order as colors) and set it on background and sprite.
This can change if we want to use multiple palettes. 

## Enable Screen

We turn on the screen, the background by setting the LCDC (LCD Control Register) to `%10000011`
Here is what Pandocs says about the LCDC : 
```
Bit 7 - LCD Display Enable             (0=Off, 1=On)
Bit 6 - Window Tile Map Display Select (0=9800-9BFF, 1=9C00-9FFF)
Bit 5 - Window Display Enable          (0=Off, 1=On)
Bit 4 - BG & Window Tile Data Select   (0=8800-97FF, 1=8000-8FFF)
Bit 3 - BG Tile Map Display Select     (0=9800-9BFF, 1=9C00-9FFF)
Bit 2 - OBJ (Sprite) Size              (0=8x8, 1=8x16)
Bit 1 - OBJ (Sprite) Display Enable    (0=Off, 1=On)
Bit 0 - BG/Window Display/Priority     (0=Off, 1=On)
```
So we enable the LCD, don't enable the window.   
Select the first adressing mode for window and background (Bank 1 and 2). This is to separate the Sprite tiles (from 0 to 255, going from bank 0 to bank 1) and the Background tiles, going from 0 to 127 (Bank 2). We won't store background tiles in bank1 even though we could.  
We also select the first tilemap for background, 8x8 sprite size, and enable sprite display and BG/Window prioerity

