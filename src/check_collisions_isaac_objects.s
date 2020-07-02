objects_collide:
; /////// implement item activations \\\\\\\
	; /// load Isaac true position and hitbox \\\
	ld a,(global_.isaac.y)
	add ISAAC_OFFSET_Y_FEET
	ld (collision_.p.1.y),a
	add ISAAC_HITBOX_Y_FEET
	ld (collision_.p_RD.1.y),a
	ld a,(global_.isaac.x)
	add ISAAC_OFFSET_X
	ld (collision_.p.1.x),a
	add ISAAC_HITBOX_X
	ld (collision_.p_RD.1.x),a
	; \\\ load Isaac true position and hitbox ///

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
	call preloaded_collision
	pop hl
	and a
	jr z, @noCollision

	push de ;save de
	ld de, @object_ret ;return address
	push de ;push return address
	ldi a, (hl)
	ld d, a
	ldi a, (hl)
	ld e, a
	push de ;push call address
	ret ;go to call address (== jp de)
@object_ret:
	pop de ; restore de

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
