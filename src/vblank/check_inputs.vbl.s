
; //////// CHECK INPUTS \\\\\\\\

;NOTE: for arrow keys, bits (3 to 0) are Down, Up, Left, Right

check_input_vlb:

; /////// INIT ARROW \\\\\\\
	ld a,P1F_5	; Select arrow keys
	ld (rP1),a
	ld a,(rP1)			; Read arrow keys
	and %00001111
	ld b,a
; \\\\\\\ INIT ARROW ///////

; /////// INIT AB \\\\\\\
	ld a,%00010000	; Select arrow keys
	ld (rP1),a
	ld a,(rP1)			; Read arrow keys
	and %00001111
	swap a
	or b
	ld b,a
; \\\\\\\ INIT AB ///////

ld (check_inputs_.keys_values),a

; \\\\\\\\ CHECK INPUTS ////////
