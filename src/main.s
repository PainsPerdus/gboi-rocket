.INCLUDE "../GBDefs/defs.s"
.INCLUDE "hardware_specs.s"

; ///////// Mapping \\\\\\\\\
.INCLUDE "var/global.var.s"
.INCLUDE "var/display.var.s"
.INCLUDE "var/sprite.var.s"
.INCLUDE "var/collision.var.s"

.ENUM $C000
	global_ INSTANCEOF global_var
	display_ INSTANCEOF display_var
	collision_ INSTANCEOF collision_var
	VBlank_lock DB
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
.INCLUDE "init/room.init.s.stub"
.INCLUDE "init/display.init.s"
; \\\\\\\ INCLUDE .INIT ///////
; //// VBlank_lock \\\\
	xor a
	ld (VBlank_lock),a    ; VBlank_lock = 0
; \\\\ VBlank_lock ////

; /////// ENABLE INTERRUPTIONS \\\\\\\
	ld a,%00000000
	ldh ($41),a		; Disable LCD STAT interruptions
	ld a,%00000001
	ldh ($FF),a		; Enable VBlank global interruption
	ei						; interrutions are back!
; \\\\\\\ ENABLE INTERRUPTIONSS ///////

; \\\\\\\\\ INIT /////////



; ///////// MAIN LOOP \\\\\\\\\
loop:
; //// WAIT FOR VBLANK \\\\
	halt
	ld a,(VBlank_lock)
	and a
  jp nz,loop			; wait until VBlank_lock = 0
; \\\\ WAIT FOR VBLANK ////

.INCLUDE "body.s"

; //// ALLOW VBLANK TO UPDATE THE SCREEN \\\\
	ld a,1
	ld (VBlank_lock),a    ; VBlank_lock = 1
; \\\\ ALLOW VBLANK TO UPDATE THE SCREEN ////
; \\\\\\\\\ MAIN LOOP /////////
	jp loop
; \\\\\\\\\ MAIN LOOP /////////


; ///////// VBlank Interuption \\\\\\\\\

VBlank:
	push af
	push bc
	push de
	push hl
; //// CHECK IF THE LOOP FINISHED \\\\
	ld a,(VBlank_lock)
	and a
	jp z,endVBlank
; \\\\ CHECK IF THE LOOP FINISHED ////

.INCLUDE "vblank/display.vbl.s"
.INCLUDE "vblank/check_inputs.vbl.s"

; //// REALLOW THE LOOP \\\\
	xor a
	ld (VBlank_lock),a    ; VBlank_lock = 0
; \\\\ REALLOW THE LOOP ////
endVBlank:
	pop hl
	pop de
	pop bc
	pop af
	ret
; \\\\\\\\\ VBlank Interuption /////////



; ///////// INCLUDE .LIB \\\\\\\\\
.INCLUDE "lib/display_background_tile.lib.s"
.INCLUDE "lib/display_doors.lib.s"
.INCLUDE "lib/sprites.lib.s"
.INCLUDE "lib/CollisionSolverIsaac.lib.s"
.INCLUDE "lib/collision.lib.s"
; \\\\\\\\\ INCLUDE .LIB /////////
