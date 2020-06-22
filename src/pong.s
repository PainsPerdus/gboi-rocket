.ROMDMG ;This is a Gameboy ROM
.NAME "PONGDEMO" ;ROM name (11 char max)
.CARTRIDGETYPE 0 ;Normal cartridge with 32ko of ROM
.RAMSIZE 0 ;No save RAM (0ko)
.COMPUTEGBCHECKSUM ;Won't boot without it
.COMPUTEGBCOMPLEMENTCHECK ;Won't boot without it
.LICENSEECODENEW "00" ;Dev license number (we don't have any)
.EMPTYFILL $00 ;Fill unused ROM space with 0


.MEMORYMAP ;We have two slots of 16ko, total 32ko
SLOTSIZE $4000
DEFAULTSLOT 0
SLOT 0 $0000
SLOT 1 $4000
.ENDME

.ROMBANKSIZE $4000
.ROMBANKS 2
.BANK 0 SLOT 0 ;Default slot at slot 0 (first 16 ko of ROM)

/*$C000 is the start of the RAM*/
.ENUM $C000 ;Declare variables
PaddleY DB //The paddle Y position
Paddle2Y DB //The second paddle Y position
BallX DB //The ball X position
BallY DB //The ball Y position
SpeedX DB //The ball X speed
SpeedY DB //The ball Y speed
.ENDE

.INCLUDE "defs.s"

/*$0040 is the interupt address*/
.ORG $0040
call VBlank ;Call directive Vblank
reti ;Return and enable interupt (unstack PC)

/*Game starts at address $0100*/
.ORG $0100
nop ;do nothing (Nitendo recommendation)
jp start ;jump to label start (without stacking PC)


/* Setting Nitendo Logo is now done in logo.s and linked */
.INCLUDE "logo.s"

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
ld b,3*8*2 ;B=48 //We load 3 tiles, so (8*8*3*2)/8 = 48 bytes (8 pixels = 2 bytes)
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

//Prepare the sprites (4 paddle sprites and 1 ball sprite)
//First we prepare the paddle sprites
//The 4 paddle sprite are all Tile 1, but Y position in incremented by 8 each times
ld hl,$FE00 ;HL=$FE00
ld b,4 ;B=4
ld a,$F ;A=16 //Y Position (minus 16)
ldspr: ;LOOP : for(b=4; b>0; b--)
ld (hl),a ;(HL)=A (OAM Sprite Y) //Set Y position
add 8 ;A=A+8 //Next Y position
inc l ;Increments L (we cannot use hdi because we're writing in the OAM)
ld (hl),$10 ;(HL)=$10 (OAM sprite X) //Set X position to $10 (minus 8)
inc l ;Increments L
ld (hl),$01 ;(HL)=1 (OAM sprite tile) //We use tile 1
inc l ;Increments L
ld (hl),$00 ;(HL)=0 (OAM sprite attribut) //Object Above BG, Not flipped, number 0 palette
inc l ;Increments L
dec b ;Decrements B
jr nz,ldspr ;Jump to ldspr if B not 0


//Then we prepare the ball sprite
ld (hl),$80 ;(HL)=$80 (OAM Sprite Y) //Ball starts at Y=$80-16
inc l ;Increments L
ld (hl),$80 ;(HL)=$80 (OAM Sprite X) //Ball starts at X=$80-8
inc l ;Increments L
ld (hl),$02 ;(HL)=2 (OAM sprite tile
inc l ;Increments L
ld (hl),$00 ;(HL)=0 (OAM sprite attribut)

//Prepare the second paddle's sprite (same but on X=144 (160-8)
inc l
ld b,4 ;B=4
ld a,$F ;A=16 //Y Position (minus 16)
ldspr2: ;LOOP : for(b=4; b>0; b--)
ld (hl),a ;(HL)=A (OAM Sprite Y) //Set Y position
add 8 ;A=A+8 //Next Y position
inc l ;Increments L (we cannot use hdi because we're writing in the OAM)
ld (hl),152 ;(HL)=$152 (OAM sprite X) //Set X position to 152 
inc l ;Increments L
ld (hl),$01 ;(HL)=1 (OAM sprite tile) //We use tile 1
inc l ;Increments L
ld (hl),%00100000 ;(HL)=0 (OAM sprite attribut) //Object Above BG, X flipped, number 0 palette
inc l ;Increments L
dec b ;Decrements B
jr nz,ldspr2 ;Jump to ldspr if B not 0


//Init variables
//Paddle starts at $20 (32 px) (top to bottom)
//Ball starts at X = 80$, Y=80$
//Speeds are all positive (going diagonally to bottom right)
ld a,$20
ld (PaddleY),a
ld (Paddle2Y),a
ld a,$80
ld (BallX),a
ld (BallY),a
ld a,1 //Start at slow speed (diagonally bottom right)
ld (SpeedX),a
ld (SpeedY),a

//Initialize the color palettes
ld a,%11100100 ;11=Black 10=Dark Grey 01=Light Grey 00=White/Transparent
/* $FF47 is BGP (BG Palette Data), assigning Color number 3, 2, 1, 0 (2 bit per color) */
ldh ($47),a ;Background Palette
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

//Now we just have to wait for VBlank interrupts (This is a very bad way to wait)
loop:
jr loop ;Infinite loop



//Main Loop
VBlank:
/* When we call VBlank, only PC is pushed on the stack, so we need to push the other
   registers to save them. Coding standards define which registers we should save. */
//Here we save the callee saved registers (registers that cannot be modified in a function without saving them first
//The registers not saved here are caller saved, that means the caller needs to save them himself, the function might modify them
push af ;push AF on the stack
push hl ;push HL on the stack

/* We need to read the pressed directions key at $FF00,
   but first set the flag to read the direction keys instead of the button keys.
   $FF00 goes as follow (bit 0 to 5) : Right or A, Left or B, Up or Select,
   Down or Start, Select Button Keys, Select Direction Keys */
ld a,%00100000 ;Selects directions key
ldh ($00),a ;($FF00)=$20

/* Check for up/down pressed keys and update paddle position */
//DOWN
ldh a,($00) ;B=($FF00) ;Read key state (pressed key = 0, unpressed = 1)
ld b,a ;B=A
bit $3,b ;test bit 3 of B
jr nz,nod ;jump to nod if B not 0 //Jumps if DOWN unpressed
//We lower the paddle by 2
ld a,(PaddleY) 
inc a
inc a
ld (PaddleY),a
//Check if the paddle off screen
cp 144+16-32 ;Low Screen Limit + 16 Hardware offset - sprite size
jr c,nod ;Jump to nod if carry (so if a<144+16-32) //Jump unless paddle too far down
ld a,144+16-32 //Set paddle Y to down screen limit
ld (PaddleY),a
nod:
//UP
bit $2,b ;test bit 2 of B
jr nz,nou ;jump to nou if B not 0 //Jumps if UP unpressed
//We raise  the paddle by 2
ld a,(PaddleY) 
dec a
dec a
ld (PaddleY),a
//Check if the paddle off screen
cp 16 ;High screen limit (0) + Hardware 16 offset
jr nc,nou ;Jump to nou if not carry (a>=16) //Jump unless paddle too far up
ld a,16 //Set paddle Y to up screen limit
ld (PaddleY),a
nou:

//Update the paddle's sprite position in OAM
ld hl,$FE00 ;OAM sprite 0 Y
ld a,(PaddleY)
ld (hl),a
ld hl,$FE04 ;OAM sprite 1 Y
add $8 ;8 pixels lower
ld (hl),a
ld hl,$FE08 ;OAM sprite 2 Y
add $8 ;8 pixels lower
ld (hl),a
ld hl,$FE0C
add $8 ;8 pixels lower
ld (hl),a

//Same for paddle 2
//DOWN (RIGHT)
ldh a,($00) ;B=($FF00) ;Read key state (pressed key = 0, unpressed = 1)
ld b,a ;B=A
bit $0,b ;test bit 0 of B
jr nz,nol ;jump to nol if B not 0 //Jumps if RIGHT unpressed
//We lower the paddle by 2
ld a,(Paddle2Y) 
inc a
inc a
ld (Paddle2Y),a
//Check if the paddle off screen
cp 144+16-32 ;Low Screen Limit + 16 Hardware offset - sprite size
jr c,nol ;Jump to nol if carry (so if a<144+16-32) //Jump unless paddle too far down
ld a,144+16-32 //Set paddle Y to down screen limit
ld (Paddle2Y),a
nol:
//UP (LEFT)
bit $1,b ;test bit 1 of B
jr nz,nor ;jump to nor if B not 0 //Jumps if LEFT unpressed
//We raise  the paddle by 2
ld a,(Paddle2Y) 
dec a
dec a
ld (Paddle2Y),a
//Check if the paddle off screen
cp 16 ;High screen limit (0) + Hardware 16 offset
jr nc,nor ;Jump to nor if not carry (a>=16) //Jump unless paddle too far up
ld a,16 //Set paddle Y to up screen limit
ld (Paddle2Y),a
nor:

//Update the paddle's sprite position in OAM
ld hl,$FE14 ;OAM sprite 4 Y
ld a,(Paddle2Y)
ld (hl),a
ld hl,$FE18 ;OAM sprite 5 Y
add $8 ;8 pixels lower
ld (hl),a
ld hl,$FE1C ;OAM sprite 6 Y
add $8 ;8 pixels lower
ld (hl),a
ld hl,$FE20 ;OAM sprite 7 Y
add $8 ;8 pixels lower
ld (hl),a



//Update ball position
/* On X */
ld hl,BallX ;Put BallX pointer into hl //Update X position according to X speed
ld a,(SpeedX) ;A=Speed X
add (hl) ;A=(BallX)+SpeedX
//Handle right border collision
cp 160 ;border = 160+8-ball size (8)
jr c,nocxr ;Jump if BallX < 160 no right side collision
call lowbeep ;Collision, play sound
ld a,(SpeedX) //Invert ball X speed (Speed X = - Speed X)
cpl ;two complement (A = A xor $FF)
inc A ;because -A = two complement of A + 1
ld (SpeedX),a
ld a,160 ;Place back the ball at the border in case it overshooted
nocxr:
//Hanle left border collision
cp 2 ;left border + max speed //This is weird, shouldn't we do cp 8 (left border + offset)?
jr nc,nocxl ;BallX > 2 : no left border collision
call lowbeep ;Collision, play sound
ld a,(SpeedX) //Invert ball X speed
cpl
inc A
ld (SpeedX),a
ld a,8 ;Reset ball position to left screen edge (border at 0+8)
nocxl:
//Update ball position according to collisions (BallX still in HL)
ld (hl),a ;fix X pos
/* On Y */
ld hl,BallY //Update Y position according to Y speed
ld a,(SpeedY)
add (hl)
//Handle bottom border collision
cp 144+8 ;bottom border = 144-ball height(8) + 16 (hardware shift)
jr c,nocyr ;BallY < 152 : no collision
call lowbeep ;collision : play sound
ld a,(SpeedY) ;Invert ball Y speed
cpl
inc A
ld (SpeedY),a
ld a,144+8 ;Put back the ball at the border
nocyr:
//Handle top border collision
cp 16 ;top border (0 + 16)
jr nc,nocyl ;BallY > 16, no top collision
call lowbeep ;Collision, play sound
ld a,(SpeedY) ;Invert ball Y speed 
cpl
inc A
ld (SpeedY),a
ld a,8+8 ;16? Put back the ball at the border
nocyl:
//Update ball position according to collisions
ld (hl),a ;fix Y pos

//Paddle Collisions first paddle
//We check if the ball if between 10 and 16 (in front of the paddle)
ld a,(BallX)
cp 8+16 ;HW offset + 16
jr nc,nopaddle ;BallX > 8+16 : no collision with paddle possible
cp 8+10 ;HW offset + 10
jr c,nopaddle ;BallX < 8+16 : no collision with paddle possible
//We check if speed is negative (ball going towards the paddle)
ld a,(SpeedX)
bit 7,a
jr z,nopaddle ;SpeedX (positive) : no paddle collision possible
//We need to test if the ball is aligned with the paddle
//So if ball's bottom position is higher as the top position of the paddle
//And ball's top position is higher than the paddle's bottom position
//First we check high limite (ball's bottom, paddle top)
ld a,(BallY)
add 8 ;Bottom of ball = BallY+sprite height
ld b,a ;save result in B
ld a,(PaddleY)
cp b ;compare paddle Y with ball Y+8
jr nc,nopaddle ;paddle Y > ballY +8 : no paddle collision possible
//Now we test the low limit (top of ball, bottom of paddle)
ld hl,BallY
ld a,(PaddleY)
add 32 ;Bottom of paddle = Paddle Y + paddle height (4 sprites of height 8)
cp (hl) ;compare paddle Y+32 to ballY
jr c,nopaddle ;PaddleY+32 < BallY ;no paddle collision possible
//If all the above test didn't jump, it means we have a collision!
//Now we define 3 zones for collision, to have 3 different bounce
ld hl,BallY
ld a,(PaddleY)
add 8 ;quarter of the paddle
cp (hl) ;compare quarter of the paddle to ballY
jr c,nofirst ;Not in first sector if PaddleY+10 < BallY
ld b,$2 ;B=2 //First sector is fast bounce
jp endsectors
nofirst:
ld a,(PaddleY)
add 32-8 ;3/4 of the paddle
cp (hl) ;compare 3/4 of the paddle to ballY
jr nc,nothird ;Not in third sector if PaddleY+22 > BallY
ld b,$2 ;B=2 //Third sector is fast bounce
jp endsectors
nothird:
ld b,$1 ;B=1 //Middle sector is slow bounce
endsectors:
call hibeep ;Paddle collision, play high sound
ld a,b ;Update speed X
ld (SpeedX),a
nopaddle:



//Paddle Collisions second paddle
//We check if the ball if between 146 and 152 (in front of the paddle)
ld a,(BallX)
cp 152
jr nc,nopaddle2 ;BallX > 152 : no collision with paddle possible
cp 146
jr c,nopaddle2 ;BallX < 146 : no collision with paddle possible
//We check if speed is positive (ball going towards the paddle)
ld a,(SpeedX)
bit 7,a
jr nz,nopaddle2 ;SpeedX is negative : no paddle collision possible
//We need to test if the ball is aligned with the paddle
//So if ball's bottom position is higher as the top position of the paddle
//And ball's top position is higher than the paddle's bottom position
//First we check high limite (ball's bottom, paddle top)
ld a,(BallY)
add 8 ;Bottom of ball = BallY+sprite height
ld b,a ;save result in B
ld a,(Paddle2Y)
cp b ;compare paddle Y with ball Y+8
jr nc,nopaddle2 ;paddle Y > ballY +8 : no paddle collision possible
//Now we test the low limit (top of ball, bottom of paddle)
ld hl,BallY
ld a,(Paddle2Y)
add 32 ;Bottom of paddle = Paddle Y + paddle height (4 sprites of height 8)
cp (hl) ;compare paddle Y+32 to ballY
jr c,nopaddle2 ;PaddleY+32 < BallY ;no paddle collision possible
//If all the above test didn't jump, it means we have a collision!
//Now we define 3 zones for collision, to have 3 different bounce
ld hl,BallY
ld a,(Paddle2Y)
add 8 ;quarter of the paddle
cp (hl) ;compare quarter of the paddle to ballY
jr c,nofirst2 ;Not in first sector if PaddleY+10 < BallY
ld b,$FE ;B=-2 //First sector is fast bounce
jp endsectors2
nofirst2:
ld a,(Paddle2Y)
add 32-8 ;3/4 of the paddle
cp (hl) ;compare 3/4 of the paddle to ballY
jr nc,nothird2 ;Not in third sector if PaddleY+22 > BallY
ld b,$FE ;B=-2 //Third sector is fast bounce
jp endsectors2
nothird2:
ld b,$FF ;B=-1 //Middle sector is slow bounce
endsectors2:
call hibeep ;Paddle collision, play high sound
ld a,b ;Update speed X
ld (SpeedX),a
nopaddle2:


//Update ball sprite
ld hl,$FE10 ;$FE00 + 4*4 (Sprite number 3 in OAM)
ld a,(BallY)
ld (hl),a ;OAM sprite 3 Y
inc l
ld a,(BallX)
ld (hl),a ;OAM sprite 3 X

pop hl ;pop HL (we pushed it on the stack at the start of Vblank call)
pop af ;Same for AF
ret ;Return of the CALL

//Sound calls
lowbeep:
call setsnd //Setup sound
ld a,%00000000
ldh ($13),a ;$FF13 is NR13 channel 1 frequency lo (lower 8 bit of 11 bit frequency
ld a,%11000111 ;$FF14 is NR14 channel 1 frequency hi (bit 0-2 = frequency higher 3 bits), bit 6 : stop output when length in NR11 expires, bit 7 is restart sound
ldh ($14),a
ret

hibeep:
call setsnd
ld a,%11000000 ;low sound bits 
ldh ($13),a
ld a,%11000111 ;high sound bits and activation
ldh ($14),a
ret

setsnd:
ld a,%10000000
ldh ($26),a ;$FF26 is NR52 (sound on/off), this turns sound 1 ON (we turned that off at the begining)
ld a,%01110111
ldh ($24),a ;$FF24 is NR50, channel control/ON-OFF/Volume We set SO1 and SO2 to max volume, and we don't enable Vin to SO1/SO2 (Vin = get external sound from cartridge)
ld a,%00010001
ldh ($25),a ;$FF25 is selection of sound output terminal : we output sound 1 to SO1 and SO2
ld a,%10111000
ldh ($11),a ;$FF11 is NR11 : channel 1 sound length and wave pattern duty (we set length to %111000 = $38 and pattern Duty to %10= 50 percent (normal sine)
ld a,%11110000
ldh ($12),a ;$FF12 is NR12, Channel 1 volume enveloppe. We set enveloppe sweep and direction to 0, and initiale volume to max
ret


//Load the tiles at $800
.ORG $800
Tiles:
.INCBIN "tiles.bin"
