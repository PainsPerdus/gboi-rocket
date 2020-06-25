# Initialize display 

## Load Tiles

Here we copy all the used tiles from ROM to VRAM.  
ROM tiles are stored at the `Tiles` label, and we copy them over to $8000 (start of VRAM)
`BC` stores the number of bytes to copy and is calculated as such :
~~~C
BC = n * 32 //Each sprite is 32 bytes (8*8/2)
~~~
Where `n` is the number of sprites (currently 14)

Due to the number of sprites, we need to use a 16 bits register `BC` to count the bytes. As `dec bc` doesn't update the `Z` register, we need to update it manually to test if `BC` is not zero. 
~~~nasm
dec bc
ld a,b
or c ; this updates correctly the Z register
~~~

## Clear BG

BG currently contains the Nitendo Logo, so we need to clear it. 
The BG is 32*32 tiles. $9800 where the first background map is defined. We need to fill all tiles with tile id 0 because the background sprite is the sprite with id 0.  
WARN: this could change later

Here is the description of the 8 bits of each background map byte (from PanDocs) :
| Bit     | Name                      | Description                             |
|---------|---------------------------|-----------------------------------------|
| Bit 0-2 | Background Palette number | (BGP0-7)                                | 
| Bit 3   | Tile VRAM Bank number     | (0=Bank 0, 1=Bank 1)                    |
| Bit 4   | Not used                  |                                         |
| Bit 5   | Horizontal Flip           | (0=Normal, 1=Mirror horizontally)       |
| Bit 6   | Vertical Flip             | (0=Normal, 1=Mirror vertically)         |
| Bit 7   | BG-to-OAM Priority        | (0=Use OAM priority bit, 1=BG Priority) |

We set everything to 0. 

## Clear OAM

There are 40 sprites in the OAM, each sprites take up 4 bytes, so we need to clear the 40*4 bytes of the OAM and set everything to 0.

## Load Sprites

### Isaac Sprites
There are 4 sprites for isaac, in this order in the ROM:  
 - top left
 - top right
 - bottom left
 - bottom right
We put their position in the OAM according to isaac x and y positions

To make it a little faster and easier we store Isaac position in 2 registers. 

## Init Color Palettes

We initialize a basic color palette (in same order as colors) and set it on background and sprite.
This can change if we want to use multiple palettes. 

## Enable Screen

We turn on the screen, the background by setting the LCDC STAT (LCDC Status Register) to `%10010011`
Here is what Pandocs says about the STAT : 
```
Bit 6 - LYC=LY Coincidence Interrupt (1=Enable) (Read/Write)
Bit 5 - Mode 2 OAM Interrupt         (1=Enable) (Read/Write)
Bit 4 - Mode 1 V-Blank Interrupt     (1=Enable) (Read/Write)
Bit 3 - Mode 0 H-Blank Interrupt     (1=Enable) (Read/Write)
Bit 2 - Coincidence Flag  (0:LYC<>LY, 1:LYC=LY) (Read Only)
Bit 1-0 - Mode Flag       (Mode 0-3, see below) (Read Only)
          0: During H-Blank
          1: During V-Blank
          2: During Searching OAM
          3: During Transferring Data to LCD Driver
```