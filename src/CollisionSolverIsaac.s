.DEFINE RECOVERYTIME 30

; //// Collision Solver for Isaac \\\\
collisionSolverIsaac :
	push c
	push d
	push e
	
	ld c, hl ;get element's size and flags
	
	;/// Blocking Collision \\\
	bit 4, c
	jp z, noBlockCollision

	;// Touch Horizontally \\
	bit 1, b
	jr z, noHorizontalCollision
	ld a, (isaac.speed)
	and %11110000
	srl a
	srl a
	srl a
	srl a
	ld d, a
	ld a, (isaac.x)
	sub d
	ld (isaac.x), a
	;\\ Touch Horizontally //
noHorizontalCollision :

	; // Touch Vertically \\
	bit 2, b
	jr z, noVerticalCollision
	ld a, (isaac.speed)
	and %00001111
	ld d, a
	ld a, (isaac.y)
	sub d
	ld (isaac.y), a
	; \\ Touch Vertically //
noVerticalCollision :
	;\\\ Blocking Collision ///
noBlockCollision :
	
	ld de, hl ;saving sheet address
	
	;/// Hurting Collision \\\
	bit 5, c
	jr z, noHurtCollision
	ld a, (isaac.recover)
	cp 0
	jr z, noHurtCollision
	
	;hurting Isaac
	inc hl
	ld a, (isaac.hp)
	sub (hl)
	ld (isaac.hp), a
	
	;starting recovery
	ld a, RECOVERYTIME
	ld (isaac.recover), a
	;\\\ Hurting Collision ///
noHurtCollision :
	
	; /// Activation Collision \\\
	bit 6, c
	jr z, noReactCollision
	
	;getting function address
	ld hl, de
	inc hl
	inc hl
	call (hl)
	; \\\ Activation Collision ///
noReactCollision :
	
	pop e
	pop d
	pop c
	ret
; \\\\ Collision Solver for Isaac ////