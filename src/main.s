.INCLUDE "../GBDefs/defs.s"
.INCLUDE "hardware_specs.s"

; //// WAITING TO THE UPDATE OF GBDefs \\\\
; Joy pad register
.DEFINE rP1 $FF00

.DEFINE P1F_5 %00100000 ; P15 out port, set to 0 to get buttons
.DEFINE P1F_4 %00010000 ; P14 out port, set to 0 to get dpad
; \\\\ WAITING TO THE UPDATE OF GBDefs ////

; ///////// Mapping \\\\\\\\\
.INCLUDE "var/global.var.s"
.INCLUDE "var/display.var.s"
.INCLUDE "var/sprite.var.s"
.INCLUDE "var/collision.var.s"
.INCLUDE "var/vectorisation.var.s"
.INCLUDE "var/rng.var.s"
.INCLUDE "var/check_inputs.var.s"

; $C000 to $C0FF is reserved for dynamic opcode

.ENUM $C100
	global_ INSTANCEOF global_var
	display_ INSTANCEOF display_var
	collision_ INSTANCEOF collision_var
	vectorisation_ INSTANCEOF vectorisation_var
	rng_state INSTANCEOF rng_state_var
	check_inputs_ INSTANCEOF check_inputs_var
	VBlank_lock DB
	GameState DB
.ENDE

; \\\\\\\\\ Mapping /////////

; ///////// Game States \\\\\\\\\\
.DEFINE GAMESTATE_TITLESCREEN $00
.DEFINE GAMESTATE_PLAYING $01
.DEFINE GAMESTATE_CHANGINGROOM $03
.DEFINE GAMESTATE_GAMEMENU $02
; \\\\\\\\\ Game States //////////


; ///////// DEFINE INTERRUPTIONS \\\\\\\\\
.ORG $0040 				; Write at the address $0040 (vblank interuption)
	call VBlank
	reti

.ORG $0048 				; Write at the address $0048 (hblank interruption)
	reti
	;push hl	;Save the hl registery that we're going to use
	;jp DISPLAY_RAM_OPCODE_START
;	jp display_.hblank_preloaded_opcode.address ;Jump to a zone in RAM with pre loaded op code

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
	ld sp,$E000     ; set the StackPointer
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

; //// VBlank_lock \\\\
	xor a
	ld (VBlank_lock),a    ; VBlank_lock = 0
; \\\\ VBlank_lock ////

; //// Game State \\\\
	ld a, GAMESTATE_TITLESCREEN
	ld (GameState), a 
; \\\\ Game State //// 

; /////// INCLUDE .INIT \\\\\\\
	call init
; \\\\\\\ INCLUDE .INIT ///////

; /////// ENABLE INTERRUPTIONS \\\\\\\
	ld a,%00001000
	ldh ($41),a		; enable STAT HBlank interrupt
	ld a,%00000011
	ldh ($FF),a		; enable VBlank interrupt and STAT interrupt
	ei						; interrutions are back!
; \\\\\\\ ENABLE INTERRUPTIONS ///////

; \\\\\\\\\ INIT /////////


; ///////// MAIN LOOP \\\\\\\\\
loop:
; //// WAIT FOR VBLANK \\\\
	halt
	ld a,(VBlank_lock)
	and a
  jp nz,loop			; wait until VBlank_lock = 0
; \\\\ WAIT FOR VBLANK ////

; //// STATE MACHINE FOR MAIN LOOP \\\\
	ld a, (GameState)
	cp GAMESTATE_TITLESCREEN
	jp z, MLstateTitleScreen
	cp GAMESTATE_PLAYING
	jp z, MLstatePlaying
MLstateTitleScreen:
	jp MLend
MLstatePlaying:
	.INCLUDE "body.s"
	.INCLUDE "display.s"
	jp MLend
MLend:
 
 ; \\\\ STATE MACHINE FOR MAIN LOOP ////

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
	jr nz,noSkipFrame
	jp endVBlank
noSkipFrame:
; \\\\ CHECK IF THE LOOP FINISHED ////

	ld a, (GameState)
	cp GAMESTATE_TITLESCREEN
	jp z, VstateTitleScreen
	cp GAMESTATE_PLAYING
	jp z, VstatePlaying
VstateTitleScreen:
	.INCLUDE "vblank/title_screen.vbl.s"
	jp Vend
VstatePlaying:
	.INCLUDE "vblank/display.vbl.s"
	.INCLUDE "vblank/check_inputs.vbl.s"
	jp Vend
Vend:

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


; ////////// Init Handler \\\\\\\\\\
init:
	ld a, (GameState)
	cp GAMESTATE_TITLESCREEN
	jp z, IstateTitleScreen
	cp GAMESTATE_PLAYING
	jp z, IstatePlaying
IstateTitleScreen:
	.INCLUDE "init/title_screen.init.s"
	jp Iend
IstatePlaying:
	.INCLUDE "init/display.init.s"
	.INCLUDE "init/global.init.s"
	.INCLUDE "init/room.init.s.stub"
	.INCLUDE "init/rng.init.s"
	.INCLUDE "init/check_inputs.init.s"
	jp Iend
Iend:
	ret

; \\\\\\\\\\ Init Handler //////////

; ///////// CHANGE STATE \\\\\\\\\\\
changeState:
	di
	ld (GameState), a
	;//We wait for VBlank to allow init scripts to run
waitvlb2: 					; wait for the line 144 to be refreshed:
	ldh a,($44)
	cp 144          ; if a < 144 jump to waitvlb
	jr c, waitvlb2
	xor a
	ldh ($40), a    ; ($FF40) = 0, turn the screen off


	call init

	reti

; \\\\\\\\\ CHANGE STATE ///////////
 
; ///////// INCLUDE .LIB \\\\\\\\\
.INCLUDE "lib/display_background_tile.lib.s"
.INCLUDE "lib/display_doors.lib.s"
.INCLUDE "lib/sprites.lib.s"
.INCLUDE "lib/CollisionSolverIsaac.lib.s"
.INCLUDE "lib/collision.lib.s"
.INCLUDE "lib/vectorisation.lib.s"
.INCLUDE "lib/rng.lib.s"
.INCLUDE "lib/ai.lib.s"
; \\\\\\\\\ INCLUDE .LIB /////////
