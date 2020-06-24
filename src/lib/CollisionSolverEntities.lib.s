; //// Collision Solver for Entities other than Isaac \\\\
collisionSolverEntities :
	push c
	push d
	
	ld c, (hl) ;get element's size and flags
	ld hl, (collidingEntity)
	inc hl
	inc hl ;hl leads to entity's speed
	
	;/// Blocking Collision \\\
	bit 4, c
	jp z, @noEBlockCollision

	;// Touch Horizontally \\
;	bit 7, b
;	jr z, @noEHorizontalCollision
	ld a, (hl)
	and %11110000
	swap a
	ld d, a
	ld a, (collidingEntity)
	sub d
	ld (collidingEntity), a
	;\\ Touch Horizontally //
;@noEHorizontalCollision :

	; // Touch Vertically \\
;	bit 6, b
;	jr z, @noEVerticalCollision
	ld a, (hl)
	and %00001111
	ld d, a
	dec hl ;hl leads to  entity's y coordinate
	ld a, (hl)
	sub d
	ld (hl), a
	; \\ Touch Vertically //
;@noEVerticalCollision :
	;\\\ Blocking Collision ///
@noEBlockCollision :

	pop d
	pop c
	ret
; \\\\ Collision Solver for Entities other than Isaac ////