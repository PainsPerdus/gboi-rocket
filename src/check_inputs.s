
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
	ld a,(global_.isaac.direction)
	and %00000011
	ld c,a
	xor a 				; speed_x = 0; speed_y = 0;
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
; \\\\\\\ CHECK ARROWS ///////

; /////// INIT AB \\\\\\\
	ld a,%00010000	; Select arrow keys
	ldh ($00),a
	ldh a,($00)			; Read arrow keys
	ld b,a
; \\\\\\\ INIT AB ///////

; /////// CHECK AB \\\\\\\
	ld hl,global_.isaac.tears
	bit $0,b			; Test Oth bit (A)
	jr nz,@noA
	set $7,(hl)
	jr @Aset
@noA:
	res $7,(hl)
@Aset:

	bit $1,b			; Test 1th bit (B)
	jr nz,@noB
	set $6,(hl)
	jr @Bset
@noB:
	res $6,(hl)
@Bset:

; \\\\\\\ SET AB ///////

; \\\\\\\\ CHECK INPUTS ////////
