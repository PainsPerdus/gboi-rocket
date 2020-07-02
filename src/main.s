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
.INCLUDE "var/music.var.s"
.INCLUDE "var/load_map.var.s"
.INCLUDE "var/ai.var.s"
.INCLUDE "var/title_screen.var.s"
.INCLUDE "var/current_floor.var.s"
.INCLUDE "var/tears.var.s"

; $C000 to $C0FF is reserved for shadow OAM

.ENUM $C100
	global_ INSTANCEOF global_var
	display_ INSTANCEOF display_var
	collision_ INSTANCEOF collision_var
	vectorisation_ INSTANCEOF vectorisation_var
	rng_state INSTANCEOF rng_state_var
	check_inputs_ INSTANCEOF check_inputs_var
	music_state_ INSTANCEOF music_state_var
	ai_ INSTANCEOF ai_var
	title_screen_ INSTANCEOF title_screen_var
	load_map_ INSTANCEOF load_map_var
	current_floor_ INSTANCEOF current_floor_var
	tears_ INSTANCEOF tears_var
	GameState DB
	OldGameState DB
	VBlank_lock DB
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
	jp HBlank

.ORG $0050
	call timer_interrupt
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

; //// VBlank_lock \\\\
	xor a
	ld (VBlank_lock),a    ; VBlank_lock = 0
; \\\\ VBlank_lock ////

; //// Game State \\\\
	ld a, GAMESTATE_TITLESCREEN
	ld (GameState), a
	ld (OldGameState), a
; \\\\ Game State ////

; //// Stack pointer \\\\
	ld sp,$E000     ; set the StackPointer in WRAM
; \\\\ Stack pointer ////

; /////// TURN THE SOUND OFF \\\\\\\
	xor a						; a=0
	ldh ($26),a     ; ($FF26) = 0, turn the sound off
; \\\\\\\ TURN THE SOUND OFF ///////

; //// SET INITIAL GAME STATE \\\\
    ;//We set the initial game state, this will first wait for vblank and turn off the screen.
	;//It will then reti and enable interrupts.
	ld a, GAMESTATE_TITLESCREEN
	jp setGameState ; Set initial gamestate
; \\\\ SET INITIAL GAME STATE ////


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
	cp GAMESTATE_CHANGINGROOM
	jp z, MLstateChangingRoom
MLstateTitleScreen:
	jp MLend
MLstatePlaying:
	.INCLUDE "body.s"
	.INCLUDE "display.s"
	jp MLend
MLstateChangingRoom:
	ld a, GAMESTATE_PLAYING
	jp setGameState ;Change gamestate to playing
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

; ///////// HBlank Interuption \\\\\\\\\
HBlank: ;/!\ WARNING : LIMITED TO 85 CYCLES WITH ALL SPRITES, 200 WITH NO SPRITES
	; //jp: 16
	push af ; //16
	ldh a,($44) ; //12
	cp 13*8-16 ; Switch to tile blocks 1-2 at this line  //8
	; //We can switch where we want if we started drawing block 1 (before drawing block 2)
	jr nz,HBlankEnd ; //12
	ldh a,($40) ;LCDC //12
	res 4,a ;Switch to tile data blocks 1-2 //8
	ldh ($40),a ; //12
	//total: 96 < 200, with few sprites it should be ok.
HBlankEnd
	pop af
	reti

; \\\\\\\\\ HBlank Interuption /////////

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
	;ld b,b ;Breakpoint to test if frame was skipped
	jp endVBlank
noSkipFrame:
; \\\\ CHECK IF THE LOOP FINISHED ////

	ld a, (GameState)
	cp GAMESTATE_TITLESCREEN
	jp z, VstateTitleScreen
	cp GAMESTATE_PLAYING
	jp z, VstatePlaying
	cp GAMESTATE_CHANGINGROOM
	jp z, VstateChangingRoom
VstateTitleScreen:
	.INCLUDE "vblank/title_screen.vbl.s"
	jp Vend
VstatePlaying:
	.INCLUDE "vblank/display.vbl.s"
	.INCLUDE "vblank/check_inputs.vbl.s"
	jp Vend
VstateChangingRoom:
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
	push bc
	push de
	ld a, (GameState)
	cp GAMESTATE_TITLESCREEN
	jp z, IstateTitleScreen
	cp GAMESTATE_PLAYING
	jp z, IstatePlaying
	cp GAMESTATE_CHANGINGROOM
	jp z, IstateChangingRoom
IstateTitleScreen:
	xor a
	ldh ($40), a    ; ($FF40) = 0, turn the screen off
	ld a,%00001000
	ldh ($41),a		; enable STAT HBlank interrupt
	ld a,%00000111
	ldh ($FF),a		; enable VBlank interrupt and STAT interrupt (for HBlank)
	.INCLUDE "init/title_screen.init.s"
	jp Iend
IstatePlaying:
	ld a,(OldGameState)
	cp GAMESTATE_CHANGINGROOM ;If changing room, we don't need to reinit everything
	jp z, Iend
	xor a
	ldh ($40), a    ; ($FF40) = 0, turn the screen off
	ld a,%00000000
	ldh ($41),a		; disable STAT HBlank interrupt
	ld a,%00000101
	ldh ($FF),a		; enable VBlank interrupt only (nothing in HBlank)
	.INCLUDE "init/display.init.s"
	.INCLUDE "init/global.init.s"
	.INCLUDE "init/rng.init.s"
	.INCLUDE "init/check_inputs.init.s"
	.INCLUDE "init/ai.init.s"
	.INCLUDE "init/music.init.s"
	; /////// ENABLE SCREEN \\\\\\\
	ld a,%10000011 	; screen on, bg on, tiles at $8000
	ldh ($40),a
	; \\\\\\\ ENABLE SCREEN ///////
	jp Iend
IstateChangingRoom:
	xor a
	ldh ($40), a    ; ($FF40) = 0, turn the screen off
	.INCLUDE "init/changeRoom.init.s"
	; /////// ENABLE SCREEN \\\\\\\
	ld a,%10000011 	; screen on, bg on, tiles at $8000
	ldh ($40),a
	; \\\\\\\ ENABLE SCREEN ///////
	jp Iend
Iend:
	pop de
	pop bc
	ret

; \\\\\\\\\\ Init Handler //////////

; ///////// CHANGE STATE \\\\\\\\\\\
setGameState:
	di ;we don't want interrupts when we change up game states
	ld l, a ; Save new GameState
	ld a, (GameState)
	ld (OldGameState), a ; Save old GameState
	ld a, l ; Restore new GameState
	ld (GameState), a ; GameState = a //Set new Gamestate
	;//We wait for VBlank to allow init scripts to run
waitvlb: 					; wait for the line 144 to be refreshed:
	ldh a,($44)
	cp 144          ; if a < 144 jump to waitvlb
	jr nz, waitvlb ; We want to be at the exact start of the vblank for safety
	;We're in vblank we can turn the screen off!

	call init

	//Reset VBlank_lock
	xor a
	ld (VBlank_lock),a    ; VBlank_lock = 0

	ei
	jp loop //Return to main loop

; \\\\\\\\\ CHANGE STATE ///////////

; ///////// INCLUDE .LIB \\\\\\\\\
.INCLUDE "lib/display_background_tile.lib.s"
.INCLUDE "lib/display_doors.lib.s"
.INCLUDE "lib/display_tears.lib.s"
.INCLUDE "lib/sprites.lib.s"
.INCLUDE "lib/CollisionSolverIsaac.lib.s"
.INCLUDE "lib/collision.lib.s"
.INCLUDE "lib/vectorisation.lib.s"
.INCLUDE "lib/rng.lib.s"
.INCLUDE "lib/ai.lib.s"

.INCLUDE "lib/knockback.lib.s"
.INCLUDE "lib/load_map.lib.s"
.INCLUDE "lib/door_functions.lib.s"
.INCLUDE "lib/maps.lib.s"
.INCLUDE "lib/display_room.lib.s" 
.INCLUDE "lib/stairs_function.lib.s"
.INCLUDE "lib/display_dma.lib.s"
; \\\\\\\\\ INCLUDE .LIB /////////

.INCLUDE "rooms/start.room"
.INCLUDE "rooms/basic1.room"
.INCLUDE "rooms/basic2.room"
.INCLUDE "rooms/basic3.room"
.INCLUDE "rooms/basic4.room"
.INCLUDE "rooms/basic5.room"
.INCLUDE "rooms/basic6.room"
.INCLUDE "rooms/basic7.room"
.INCLUDE "rooms/basic8.room"

.INCLUDE "rooms/basic.room"
first_floor:
.INCLUDE "maps/map1.level1"
room_index:
.INCLUDE "rooms/correspondingIDAdress.room"

.ORG $3F00
.DB %11101011, %11101111, %11101011, %11101111, %11100111, %11101111, %11100111, %11101111, %11101101, %11101111, %11101110, %11101111, %11101101, %11101111, %11101110, %11101111, %11011101, %11101111, %11011110, %11101111

.BANK 1 SLOT 1
.ORGA $4000
.INCLUDE "lib/music.lib.s"