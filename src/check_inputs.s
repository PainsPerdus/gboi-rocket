
; //////// CHECK INPUTS \\\\\\\\

;NOTE: for arrow keys, bits (3 to 0) are Down, Up, Left, Right

check_input:

	ld a,(check_inputs_)
	ld b,a

; /////// CHECK ARROWS \\\\\\\
	ld a,(global_.isaac.lagCounter) ; Avoid glitchy behavior with display and collisions
	cp 1
	jp nz,@no_refresh_speed

	ld a,(global_.isaac.direction)
	and MASK_2_LSB
	ld c,a
	xor a 				; speed_x = 0; speed_y = 0;
	bit DW_KEY,b		 	; Test third bit (down)
	jr nz,@nod
	or VALUE_4LSB_1 	; a [3:0] = 1
	ld c,ORIENTATION_DW; orientation = %11;
	jr @nou
@nod:
	bit UP_KEY,b			; Test second bit (up)
	jr nz,@nou
	or VALUE_4LSB_minus_1 	; a [3:0] = -1
	ld c,ORIENTATION_UP; orientation = %00;
@nou:
	bit RG_KEY,b			; Test Oth bit (right)
	jr nz,@nor
	or VALUE_4MSB_1	; a [7:4] = 1
	ld c,ORIENTATION_RG; orientation = %01;
	jr @nol
@nor:
	bit LF_KEY,b			; Test 1th bit (left arrow)
	jr nz,@nol
	or VALUE_4MSB_minus_1 	; a [7:4] = -1
	ld c,ORIENTATION_LF; orientation = %10;
@nol:
	ld (global_.isaac.speed),a
	ld a,(global_.isaac.direction)
	and MASK_6_MSB
	or c
	ld (global_.isaac.direction),a
@no_refresh_speed:
; \\\\\\\ CHECK ARROWS ///////

; /////// CHECK AB \\\\\\\
	ld hl,global_.isaac.tears
	bit A_KEY,b			; Test 4th bit (A)
	jr nz,@noA
	set ISAAC_A_FLAG,(hl)
	jr @Aset
@noA:
	res ISAAC_A_FLAG,(hl)
@Aset:

	bit B_KEY,b			; Test 5th bit (B)
	jr nz,@noB
	set ISAAC_B_FLAG,(hl)
	jr @Bset
@noB:
	res ISAAC_B_FLAG,(hl)
@Bset:

; \\\\\\\ SET AB ///////

; \\\\\\\\ CHECK INPUTS ////////
