
; //////// CHECK INPUTS \\\\\\\\

;NOTE: for arrow keys, bits (3 to 0) are Down, Up, Left, Right

move_check_input:

; /////// INIT ARROW \\\\\\\
	ld a,%00100000	; Select arrow keys
	ldh ($00),a
	ldh a,($00)			; Read arrow keys
	ld b,a
; \\\\\\\ INIT ARROW ///////

; /////// CHECK ARROWS \\\\\\\
	xor a 				; speed_x = 0; speed_y = 0;
	ld c,0				; orientation = 0;
	bit $3,b		 	; Test third bit (down)
	jr nz,@nod
	or %00000010 	; a [3:0] = 2
	ld c,%00000011; orientation = %11;
	jr @nou
@nod:
	bit $2,b			; Test second bit (up)
	jr nz,@nou
	or %00001110 	; a [3:0] = -2
	ld c,%00000000; orientation = %00;
@nou:
	bit $0,b			; Test Oth bit (right)
	jr nz,@nor
	or %00100000	; a [7:4] = 2
	ld c,%00000001; orientation = %01;
	jr @nol
@nor:
	bit $1,b			; Test 1th bit (left arrow)
	jr nz,@nol
	or %11100000 	; a [7:4] = -2
	ld c,%00000010; orientation = %10;
@nol:
	ld (global_.isaac.speed),a
	ld a,(global_.isaac.direction)
	and %11111100
	or c
	ld (global_.isaac.direction),a
	; \\\\\\\ SET SPEED ///////

; \\\\\\\\ CHECK INPUTS ////////