objects_collide:
; /////// implement item activations \\\\\\\
;   //// collision with objects loop \\\\
	ld de, global_.objects
	ld c, n_objects
	@loop:
; /// loop start \\\
	ld h,d
	ld l,e

; / set hitbox and position as parameter \
	ldi a, (hl)
	bit ALIVE_FLAG, a
	jr z,@noCollision ; check if element is alive
	and OBJECT_SIZE_MASK
	ld (collision_.hitbox2), a
	ldi a, (hl)
	ld (collision_.p.2.y), a
	ldi a, (hl)
	ld (collision_.p.2.x), a
; \ set hitbox and position as parameter /

; / test collision \
	push hl
	call collision
	pop hl
	and a
	jr z, @noCollision

	ld a, $50
	ld b, a
	push hl
	ld l, ROCKS_SPRITESHEET
	call displayBackgroundTile
	pop hl

	; push de
	; ld de, @object_ret
	; push de
	; ldi a, (hl)
	; ld d, a
	; ldi a, (hl)
	; ld e, a
	; push de
	; ret
	; pop de
@object_ret:

@noCollision:
; \ test collision /

@ending_loop:
	ld hl, _sizeof_object
	add hl, de
	ld d,h
	ld e,l
	dec c
	jr nz, @loop
;   \\\\ collision with objects loop ////
; \\\\\\\ implement item activations ///////