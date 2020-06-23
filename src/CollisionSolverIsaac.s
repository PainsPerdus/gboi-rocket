.DEFINE RECOVERYTIME 30

; //// Collision Solver for Isaac \\\\
collisionSolverIsaac :
	push c
	push d
	push e
	
	ld c, hl ;get element's size and flags
	
	;/// Blocking Collision \\\
	bit 4, c
	jr z, noBlockCollision
	
	;// Touch right \\
	bit 1, b
	jr z, noRightCollision
	ld a, (isaac.speed)
	and %11110000
	srl a
	srl a
	srl a
	srl a
	ld d, a
	ld a, (isaac.x)
	add d
	ld (isaac.x), a
	;\\ Touch right //
noRightCollision :

	;// Touch left \\
	bit 2, b
	jp z, noLefttCollision
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
	;\\ Touch left //
noLefttCollision :

	;// Touch down \\
	bit 3, b
	jr z, noDownCollision
	ld a, (isaac.speed)
	and %00001111
	ld d, a
	ld a, (isaac.y)
	add d
	ld (isaac.y), a
	;\\ Touch down //
noDownCollision :

	; // Touch up \\
	bit 4, b
	jr z, noUpCollision
	ld a, (isaac.speed)
	and %00001111
	ld d, a
	ld a, (isaac.y)
	sub d
	ld (isaac.y), a
	; \\ Touch up //
noUpCollision :
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
	xor a
	inc l
	adc h
	ld h, a ;now hl is sheet.dmg
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
	xor a
	inc l
	adc h
	inc l
	adc 0
	ld h, a
	call (hl)
	; \\\ Activation Collision ///
noReactCollision :
	
	pop e
	pop d
	pop c
	ret
; \\\\ Collision Solver for Isaac ////