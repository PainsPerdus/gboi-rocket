enemys_turn:
	ld de,global_.enemies
	ld c,n_enemies
@loop:

; //// IA \\\\
	ld h,d
	ld l,e
	ld a,(hl)	
	bit ALIVE_FLAG,a ;Jump if ennemy is dead
	jp z, @@no_move
	cp HURTING_ROCK_INFO ;Jump if ennemy is a spike
	jp z, @@no_move
	call AI
; \\\\ IA ////

; //// Move the enemy \\\\

; /// Check lagcounter \\\
	ld hl,$0006
	add hl,de
	dec (hl)
	jp nz,@@no_move
	inc hl
	ld a,(hl)
	dec hl
	ld (hl),a

; // If move is diag, increase lag counter \\
	ld hl,$0004 ; B = V
	add hl,de
	ld b,(hl)


	ld a,b
	and MASK_4_LSB
	jr z,@@no_diag_move
	ld a,b
	and MASK_4_MSB
	jr z,@@no_diag_move

	ld hl,$0007
	add hl,de
	ld a,(hl)
	bit 1,a
	jp nz,@@multiple_of_2
	inc a
@@multiple_of_2:
	srl a
	add (hl)
	dec hl
	ld (hl),a
; \\ If move is diag, increase lag counter //
@@no_diag_move:
; \\\ Check lagcounter ///
;
; /// y += dy \\\
	ld hl,$0001
	add hl,de

  ld a,b
  and %00001111
  bit $3,a
  jr z,@@posit_y
  or %11110000
@@posit_y:
  add (hl)
  ldi (hl),a
; \\\ y += dy ///

; /// x += dx \\\
	ld a,b
	swap a
	and %00001111
	bit $3,a
	jr z,@@posit_x
	or %11110000
@@posit_x:
	add (hl)
	ld (hl),a
; \\\ x += dx ///
; \\\\ Move the enemy ////
@@no_move:

	ld hl,_sizeof_enemy
	add hl,de
	ld d,h
	ld e,l
	dec c
	jp nz,@loop
