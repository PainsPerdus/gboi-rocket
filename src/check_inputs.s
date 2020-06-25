
; //////// CHECK INPUTS \\\\\\\\

;NOTE: for arrow keys, bits (3 to 0) are Down, Up, Left, Right

move_check_input:
	ld a,%00100000	; Select arrow keys
	ldh ($00),a
	ldh a,($00)			; Read arrow keys
	ld b,a

	xor a ; a = 0

	bit $0,b			; Test Oth bit (right)
	jr nz,@nor
	or %00100000	; a [7:4] = 2
	jr @nol
@nor:
	bit $1,b			; Test 1th bit (left arrow)
	jr nz,@nol
	or %11100000 	; a [7:4] = -2
@nol:
	bit $3,b		 	; Test third bit (down)
	jr nz,@nod
	or %00000010 	; a [3:0] = 2
	jr @nou
@nod:
	bit $2,b			; Test second bit (up)
	jr nz,@nou
	or %00001110 	; a [3:0] = -2
@nou:
	ld (global_.isaac.speed),a

; \\\\\\\\ CHECK INPUTS ////////
