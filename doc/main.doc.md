# Description of main.s

## Header
Include defines for the game boy architecture.
~~~
.INCLUDE "../GBDefs/defs.s"
~~~
Include specifications for the generation of the binary file.
~~~
.INCLUDE "hardware_specs.s"
~~~
## Mapping
~~~
; ///////// Mapping \\\\\\\\\
.INCLUDE "global.var.s"
; $C000 to $C0FF is reserved for dynamic opcode 
.ENUM $C100
	global_ INSTANCEOF global_var
.ENDE
; \\\\\\\\\ Mapping /////////
~~~

Include the defines, structs and variable used of the module `xxx`
Each module `xxx` has to have a struct `xxx_var` declaring the variables used by the module.
~~~
.INCLUDE "xxx.var.s"
~~~

The variables are them *reserved* in memory by instantiating `xxx_var` in `xxx_`. `xxx_` is them used as a namespace for the variables of the module (**but not for the labels of the module**)
~~~
.ENUM $C000
  ...
  xxx_ INSTANCEOF xxx_var"
  ...
.ENDE
~~~

## DEFINE INTERRUPTIONS

Links the interruption `VBLank` to the function `VBLank` and the starting point to `start`.

~~~
.ORG $0040 				; Write at the address $0040 (vblank interuption)
	call VBlank
	reti

.ORG $0048              ; Write at the address $0048 (hblank interruption)
    push hl ;Save the hl registery that we're going to use
    jp display_.hblank_preloaded_opcode.address ;Jump to a zone in RAM with pre loaded op code
 
.ORG $0100 				; Write at the address $0100 (starting point of the prog)
	nop							; adviced from nintendo. nop just skip the line.
	jp start
~~~

## Init

See the pandoc for more info about what's done here. Basically clear the screen and initialize the modules.

Each module `xxx` has a `xxx.init.s` file with its initialization code.
~~~
; /////// INCLUDE .INIT \\\\\\\
...
.INCLUDE "xxx.init.s"
...
; \\\\\\\ INCLUDE .INIT ///////
~~~

## Main Loop

The main logic in included in `body.s`.

We use a lock to synchronize the update of the values with the update of the screen. After each iteration we wait for a VBlank, and if we didn't finished the iteration, the VBlank interruption do nothing.
~~~
; ///////// MAIN LOOP \\\\\\\\\
loop:
; //// WAIT FOR VBLANK \\\\
	halt
	ld a,(lock)
	and a
  jp nz,loop			; wait until lock = 0
; \\\\ WAIT FOR VBLANK ////

.INCLUDE "body.s"

; //// ALLOW VBLANK TO UPDATE THE SCREEN \\\\
	ld a,1
	ld (lock),a    ; lock = 1
; \\\\ ALLOW VBLANK TO UPDATE THE SCREEN ////
; \\\\\\\\\ MAIN LOOP /////////
	jp loop
; \\\\\\\\\ MAIN LOOP /////////
~~~

## VBlank

The VBlank function. This function is called with VBlank interrupt, but we only update the screen after each iteration of the loop. So, when the lock is not in the right state, we return at once. Else we run the code include in `xxx.vbl.s` files (the display module first, since we can only update the screen during the vblank time). The code included here has to be really fast. Long computations should be done in the loop.

~~~
; ///////// VBlank Interuption \\\\\\\\\
VBlank:
	push af
	push bc
	push de
	push hl
; //// CHECK IF THE LOOP FINISHED \\\\
	ld a,(lock)
	and a
	jp z,endVBlank
; \\\\ CHECK IF THE LOOP FINISHED ////

.INCLUDE "vblank/display.vbl.s"
.INCLUDE "vblank/check_inputs.vbl.s"

; //// REALLOW THE LOOP \\\\
	xor a
	ld (lock),a    ; lock = 0
; \\\\ REALLOW THE LOOP ////
endVBlank:
	pop hl
	pop bc
	pop de
	pop af
	ret
; \\\\\\\\\ VBlank Interuption /////////
~~~

## Include .lib

If the module `xxx` has function or other data that need to be called, the file `xxx.lib.s` is included here.
~~~
; ///////// INCLUDE .LIB \\\\\\\\\
...
.INCLUDE "xxx.lib.s"
...
; \\\\\\\\\ INCLUDE .LIB /////////
~~~
