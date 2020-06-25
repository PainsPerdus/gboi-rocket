.INCLUDE "../GBDefs/defs.s"
.INCLUDE "hardware_specs.s"

; ///////// Mapping \\\\\\\\\
.INCLUDE "var/global.var.s"
.INCLUDE "var/display.var.s"

.ENUM $C000
	global_ INSTANCEOF global_var
	display_ INSTANCEOF display_var
.ENDE
; \\\\\\\\\ Mapping /////////



; ///////// DEFINE INTERRUPTIONS \\\\\\\\\
.ORG $0040 				; Write at the address $0040 (vblank interuption)
	call VBlank
	reti

.ORG $0100 				; Write at the address $0100 (starting point of the prog)
	nop							; adviced from nintendo. nop just skip the line.
	jp start
; \\\\\\\\\ DEFINE INTERRUPTIONS /////////



; ///////// INIT \\\\\\\\\

; /////// DISABLE INTERRUPTIONS \\\\\\\
.org $0150 				; Write after $0150. Safe zone after the header.
start:
	di							; disable interrupt
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
.INCLUDE "init/global.init.s"
.INCLUDE "init/display.init.s"
; \\\\\\\ INCLUDE .INIT ///////

; /////// ENABLE INTERRUPTIONS \\\\\\\
	ld a,%00010000
	ldh ($41),a		; enable VBlank interruption
	ld a,%00000001
	ldh ($FF),a		; twice, BECAUSE IT'S FUN
	ei						; interrutions are back!
; \\\\\\\ ENABLE INTERRUPTIONSS ///////

; \\\\\\\\\ INIT /////////



; ///////// MAIN LOOP \\\\\\\\\
loop:
	jr loop
; \\\\\\\\\ MAIN LOOP /////////



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



; ///////// INCLUDE .LIB \\\\\\\\\
.INCLUDE "lib/sprites.lib.s"
; \\\\\\\\\ INCLUDE .LIB /////////
