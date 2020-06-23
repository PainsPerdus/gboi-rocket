/*$0040 is the interupt address*/
.ORG $0040
call VBlank ;Call directive Vblank
reti ;Return and enable interupt (unstack PC)

/*Game starts at address $0100*/
.ORG $0100
nop ;do nothing (Nitendo recommendation)
jp start ;jump to label start (without stacking PC)

/* $0150 is after the ROM header (ends at $0149 */
.ORG $0150
start: //Start of our game
di ;disable interruptions
ld sp,$FFF4 ;set stack pointer (SP) at almost the end of the HRAM (Nitendo directive)
xor a ;a XOR a is always 0 (sets A to 0 quickly)
ldh ($26),a ;($FF26)=A //Turns sound off

waitvbl: //We need to wait for the vblank (small period during which the screen isn't blanked) in order to init VRAM (Failure to do so will damage the screen!)
/* $FF44 is LY, vertical line processed by LCD Driver (0 to 153, >144 indicates VBlank) */
ldh a,($44) ;A=($FF44)
cp 144 ;Compares A with 144 (set the flags bits for A-144 without changing A)
jr c,waitvbl ;Jump to waitvlb if carry is one (so A < 144) because getting a negative number while substracting results in a 1 carry

xor a ;A=0
/* $FF40 is the LCDC (LCD Control bits) */
ldh ($40),a ;($FF40)=A //Disables the LCD (bit 7 controls on/off status)

//We copy the graphics from ROM to VRAM
ld b,5*8*2 ;B=48 //We load 4 tiles, so (8*8*3*2)/8 = 48 bytes (8 pixels = 2 bytes)
ld de,Tiles ;DE=Adress of "Tiles" Label, ROM pointer //This is where we're going to read the tiles
/* $8000 is the first address in VRAM, corresponding to Tile number 0 */
ld hl,$8000 ;HL=$8000, RAM pointer //This is where we're going to write the tiles
ldt: //Loop : for(b=48; b>0; b--)
ld a,(de) ;A=(DE)
ldi (hl),a ;(HL)=A, HL=HL+1
inc de ;DE=DE+1
dec b ;B=B-1
jr nz,ldt ;Jump to ldt if B not 0

//We need to cleanup the background (it contains the Nitendo logo) and fill it with Tile 0
ld de,32*32 ;DE=1024 background map size
/* $9800 is the first tile (upper left) of the background Map 32*32 array.
   Each cell contains the number of the tile */
ld hl,$9800 ;HL=$9800
clmap: //Loop : for(de=1024; de<0; de--)
xor a; ;A=0
ldi (hl),a ;(HL)=A, HL=HL+1 //We set the number of the tile to 0
dec de ;DE=DE-1
ld a,e ;A=E
or d ;A=A OR D //E or D is zero when both E and D are 0 (the Z flag doesn't work with 16 bit registers)
jr nz,clmap ;Jump to clmap if A not 0 (so if DE not zero)

//We cleanup the OAM (sprite attribution table)
/* $FE00 is the position of the OAM */
ld hl,$FE00 ;HL=$FEOO
ld b,40*4 ;B=160 (40 sprites with 4 bytes per sprite)
clspr: //Loop : for(b=160; b>0; b--)
/* Here we do ld (hl),$00 then inc l instead of ldi (HL),$00
   because it would corrupt the OAM due to an hardware bug.
   Also we cannot use inc hl we have to use inc l to avoid the same bug.
   This only happens when interacting with the OAM ($FE00 to $FE9F) */
ld (hl),$00 ;(HL)=0
inc l ;L=L+1
dec b ;B=B-1
jr nz,clspr ;Jump to clspr if B not 0

/* $FF42 is Scroll Y, $FF43 is Scroll X
   The position int he 256x256 background map (32x32 tiles) displayed on LCD upper left */
xor a ;A=0 //We put the background Scroll X and Scroll Y to 0 (upper left)
ldh ($42),a ;($FF42)=A
ldh ($43),a ;($FF42)=A

ld b, 50 //Start pos Y
ld c, 30 //Start pos X
//Prepare isaac sprite (4 sprites, top left, top right, bottom left, bottom right)
ld hl,$FE00
//top left
ld a,b //Start pos Y
ld (hl), a ;PosY
inc l
ld a,c //Start posX
ld (hl), a
inc l
ld (hl), $01
inc l
ld (hl), $00
inc l
//top right
ld a,b
ld (hl), a ;Pos Y
inc l
ld a,c
add 8
ld (hl), a ; Pos X
inc l
ld (hl), $02
inc l
ld (hl), $00
inc l
//bottom left
ld a,b
add 8
ld (hl), a ;PosY
inc l
ld a,c
ld (hl), a ;PosX
inc l
ld (hl), $03
inc l
ld (hl), $00
inc l
//bottom right
ld a,b
add 8
ld (hl), a ;PosY
inc l
ld a,c
add 8
ld (hl), a ;PosX
inc l
ld (hl), $04
inc l
ld (hl), $00


//Initialize the color palettes
ld a,%11100100 ;11=Black 10=Dark Grey 01=Light Grey 00=White/Transparent
/* $FF47 is BGP (BG Palette Data), assigning Color number 3, 2, 1, 0 (2 bit per color) */
ldh ($47),a ;Background Palette
ld a,%00011011
/* $FF48/$FF49 is OBP0/1 (Object Palette 0/1 Data), same as BGP for sprite palette 0/1
   but $00 is transparent */
ldh ($48),a ;Sprite Palette 0
ldh ($49),a ;Sprite Palette 1 //Unused here

//Activate screen
ld a,%10010011 ;Screen on, window tilemap select, window display disabled, BG tile data select (at $8000), BG Tile map select (at $9800), OBJ (Sprite) size (8x8), OBJ (Sprite) Display Enabled, BG/Window Display Priority (on)
ldh ($40),a ;LCDC //Activates Screen
ld a,%00010000 ;Enables VBlank Interupt
ldh ($41),a ;LCDC Status
ld a,%0000001 ;Enable VBlank Interupt (only)
ldh ($FF),a ;IE (Interupt Enable) Tells which interrupts are enabled
ei ;Enables interupts //We disabled them with di at the start of our program

