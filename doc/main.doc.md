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
...
.ENUM $C000
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

.ORG $0100 				; Write at the address $0100 (starting point of the prog)
	nop							; adviced from nintendo. nop just skip the line.
	jp start
~~~

## Init

See the pandoc for more info about what's done here. Basically clear the screen and initialize the modules.
~~~
; ///////// INIT \\\\\\\\\
; /////// DISABLE INTERRUPTIONS \\\\\\\
.org $0150 			; Write after $0150. Safe zone after the header.
start:
	di						; disable interrupt
; \\\\\\\ DISABLE INTERRUPTIONS ///////
; /////// TURN THE SCREEN AND SOUND OFF \\\\\\\
	ld sp,$FFF4     ; set the StackPointer
	xor a						; a=0
	ldh ($26),a     ; ($FF26) = 0, turn the sound off
waitvlb: 					; wait for the line 144 to be refreshed:
	ldh a,($44)
	cp 144          ; if a < 144 jump to waitvlb
	jr c, waitvlb
                  ; now we are in the vblank,
                  ; the screen is not eddited for a few
                  ; cycles.
									; turn the screen off:
	xor a
	ldh ($40), a    ; ($FF40) = 0, turn the screen off
; \\\\\\\ TURN THE SCREEN AND SOUND OFF ///////

; /////// INCLUDE .INIT \\\\\\\
;.INCLUDE "main.init.s"
; \\\\\\\ INCLUDE .INIT ///////

; /////// ENABLE INTERRUPTIONS \\\\\\\
	ld a,%00010000
	ldh ($41),a		; enable VBlank interruption
	ld a,%00000001
	ldh ($FF),a		; twice, BECAUSE IT'S FUN
	ei						; interrutions are back!
; \\\\\\\ ENABLE INTERRUPTIONSS ///////

; \\\\\\\\\ INIT /////////
~~~

Each module `xxx` has a `xxx.init.s` file with its initialization code.
~~~
; /////// INCLUDE .INIT \\\\\\\
...
.INCLUDE "xxx.init.s"
...
; \\\\\\\ INCLUDE .INIT ///////
~~~

## Main Loop

Do nothing, we work in `VBlank`.
~~~
; ///////// MAIN LOOP \\\\\\\\\
loop:
	jr loop
; \\\\\\\\\ MAIN LOOP /////////
~~~

## VBlank

The VBLank function. **We include the `display` module first.**. The VLblank is a save time to edit the screen, and after this time, we can't edit the screen anymore, but we can still compute the values for the next frame.

If the module `xxx` (`display` aside) needs to execute code at each iteration, the file `xxx.s` is included inside the file `body.s`.

~~~
; ///////// VBlank Interuption \\\\\\\\\
VBlank:
	push af
	push hl
.INCLUDE "display.s"
.INCLUDE "body.s"
	pop hl
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
