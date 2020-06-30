# Blackmagic initialization

## Setup Tear HBlank Opcode
We want to execute code in the HBlank to update the sprites. However, we only have at 85 clock cycles.
So we're going to write that code in WRAM and jump to it in HBLANK. The code that modifies the OAM needs to be less than 85 cycle. Then we can have some (a bit) longer reset code.
The tricky part is that we need to recycle possibly different sprites at each line.
Here we setup the basic code for the jump (the opcodes that won't change)
~~~arm
push hl        //16
jp REC         //16
ld hl, NNnn    //12
ld (hl), yy    //12
ld l, nn+1     //8
ld (hl), xx    //12
//TOTAL : 76 cycles
; after hblank
pop hl
reti
~~~
