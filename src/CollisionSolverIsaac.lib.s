.DEFINE RECOVERYTIME 30

; //// Collision Solver for Isaac \\\\
collisionSolverIsaac :
	push c
	push d
	push e
	
	ld c, (hl) ;get element's size and flags
	
	;/// Blocking Collision \\\
	bit 4, c
	jp z, @noBlockCollision

	;// Touch Horizontally \\
	bit 7, b
;	jr z, @noHorizontalCollision
	ld a, (global_.isaac_.speed)
	and %11110000
	swap a
	ld d, a
	ld a, (global_.isaac_.x)
	sub d
	ld (global_.isaac_.x), a
	;\\ Touch Horizontally //
;@noHorizontalCollision :

	; // Touch Vertically \\
	bit 6, b
;	jr z, @noVerticalCollision
	ld a, (global_.isaac_.speed)
	and %00001111
	ld d, a
	ld a, (global_.isaac_.y)
	sub d
	ld (global_.isaac_.y), a
	; \\ Touch Vertically //
;@noVerticalCollision :
	;\\\ Blocking Collision ///
@noBlockCollision :
	
	ld de, hl ;saving sheet address
	
	;/// Hurting Collision \\\
	bit 3, c
	jr z, @noHurtCollision
	ld a, (global_.isaac_.recover)
	cp 0
	jr z, @noHurtCollision
	
	;hurting Isaac
	inc hl
	ld a, (global_.isaac_.hp)
	sub (hl)
	ld (global_.isaac_.hp), a
	
	;starting recovery
	ld a, RECOVERYTIME
	ld (global_.isaac_.recover), a
	;\\\ Hurting Collision ///
@noHurtCollision :
	
	; /// Activation Collision \\\
	bit 2, c
	jr z, @noReactCollision
	
	;getting function address
	ld hl, de
	inc hl
	inc hl
	call (hl)
	; \\\ Activation Collision ///
@noReactCollision :
	
	pop e
	pop d
	pop c
	ret
; \\\\ Collision Solver for Isaac ////