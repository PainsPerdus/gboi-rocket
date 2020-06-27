.DEFINE ISAAC_HITBOX 1

move_and_collide:

@y:
; //////// MOVE ISAAC  Y \\\\\\\
	ld a,(global_.isaac.speed)
	and %00001111
	bit $3,a
	jp z,@@posit
	or %11110000
@@posit:
	ld b,a									; B = SPEED Y
	ld hl,global_.isaac.y
	add (hl)
	ld (hl),a								; y += speed y


;   //// collision Y  init \\\\
	ld a, (global_.isaac.x)
	ld (collision_.p.1.x), a
	ld a, (global_.isaac.y)
	ld (collision_.p.1.y), a
	ld a, ISAAC_HITBOX
	ld (collision_.hitbox1), a
;   \\\\ collision Y  init ////

;   //// collision Y  loop \\\\
	ld de, global_.elements
	ld c, n_elements
	@@loop:
; /// loop start \\\
	ld h,d
	ld l,e

; / set position as parameter \
	inc hl
	ldi a, (hl)
	ld (collision_.p.2.x), a
	ldi a, (hl)
	ld (collision_.p.2.y), a
; \ set position as parameter /

; / set hitbox as parameter \
	ld a, (hl)
	ld hl, global_.sheets
	ld l,a
	ld a, (hl)	; a = (*element.sheet).size)
	bit $7,a
	jp z, @@ending_loop	; if non block : continue
	and %00000111
	ld (collision_.hitbox2), a
; \ set hitbox as parameter /

; / test collision \
	call collision
	and a
	jr z, @@noCollision
	ld a,(global_.isaac.y)
	sub b
	ld (global_.isaac.y),a ; isaac.y -= speed y
	ld (collision_.p.1.y),a
	ld a,(global_.isaac.speed)
	and %11110000
	ld b,0
	ld (global_.isaac.speed),a ; speed y = 0
@@noCollision:
; \ test collision /

@@ending_loop:
	ld hl, $0007
	add hl, de
	ld d,h
	ld e,l
	dec c
	jr nz, @@loop
;   \\\\ collision Y  loop ////
; \\\\\\\ MOVE ISAAC  Y ////////



@x:
; //////// MOVE ISAAC  X \\\\\\\
	ld a,(global_.isaac.speed)
	and %11110000
	swap a
	bit $3,a
	jp z,@@posit
	or %11110000
@@posit:
	ld b,a									; B = SPEED X
	ld hl,global_.isaac.x
	add (hl)
	ld (hl),a								; x += speed x

;   //// collision X  init \\\\
	ld a, (global_.isaac.x)
	ld (collision_.p.1.x), a
;   \\\\ collision X  init ////

;   //// collision X  loop \\\\
	ld de, global_.elements
	ld c, n_elements
	@@loop:
; /// loop start \\\
	ld h,d
	ld l,e

; / set position as parameter \
	inc hl
	ldi a, (hl)
	ld (collision_.p.2.x), a
	ldi a, (hl)
	ld (collision_.p.2.y), a
; \ set position as parameter /

; / set hitbox as parameter \
	ld a, (hl)
	ld hl, global_.sheets
	ld l,a
	ld a, (hl)	; a = (*element.sheet).size)
	bit $7,a
	jp z, @@ending_loop	; if non block : continue
	and %00000111
	ld (collision_.hitbox2), a
; \ set hitbox as parameter /

; / test collision \
	call collision
	and a
	jr z, @@noCollision
	ld a,(global_.isaac.x)
	sub b
	ld (global_.isaac.x),a ; isaac.x -= speed x
	ld (collision_.p.1.x),a
	ld a,(global_.isaac.speed)
	and %00001111
	ld b,0
	ld (global_.isaac.speed),a ; speed x = 0
@@noCollision:
; \ test collision /

@@ending_loop:
	ld hl, $0007
	add hl, de
	ld d,h
	ld e,l
	dec c
	jr nz, @@loop
;   \\\\ collision X  loop ////
; \\\\\\\ MOVE ISAAC  X ////////






; //////// TEST A B \\\\\\\
; if A / B are pressed
;	ld hl, global_.isaac.tears
;	bit $7,(hl); flag A set
;	jr z,@Aset
;	ld a,$10
;	ld (global_.isaac.x),a
;	ld (global_.isaac.y),a
;@Aset:
;
;	bit $6,(hl); flag B set
;	jr z,@Bset
;	ld a,$90
;	ld (global_.isaac.x),a
;	ld (global_.isaac.y),a
;@Bset:
; \\\\\\\ TEST A B ////////
