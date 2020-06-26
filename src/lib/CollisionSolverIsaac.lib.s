.DEFINE RECOVERYTIME 30

; //// Collision Solver for Isaac \\\\
collisionSolverIsaac:
	push bc
	push de
	
	ld c, (hl) ;get element's size and flags
	
	;/// Blocking Collision \\\
	bit 7, c
	jp z, @noBlockCollision

	;// Touch Horizontally \\
	bit 7, b
	jr z, @noHorizontalCollision
	ld a, (global_.isaac.speed)
	and %11110000
	swap a
	bit $3,a
	jp z,@signComplXSpeed
	or %11110000
@signComplXSpeed:
	ld d, a
	ld a, (global_.isaac.x)
	sub d
	ld (global_.isaac.x), a

	ld a, 100
	ld (global_.isaac.x), a
	ld (global_.isaac.y), a
	;\\ Touch Horizontally //
@noHorizontalCollision:

	; // Touch Vertically \\
	bit 6, b
	jr z, @noVerticalCollision
	ld a, (global_.isaac.speed)
	and %00001111
	bit $3,a
	jp z,@signComplYSpeed
	or %11110000
@signComplYSpeed:
	ld d, a
	ld a, (global_.isaac.y)
	sub d
	ld (global_.isaac.y), a

	ld a, 100
	ld (global_.isaac.x), a
	ld (global_.isaac.y), a
	; \\ Touch Vertically //
@noVerticalCollision:
	;\\\ Blocking Collision ///
@noBlockCollision:
	
	; ld d, h
	; ld e, l ;saving sheet address
	
; 	;/// Hurting Collision \\\
; 	bit 6, c
; 	jr z, @noHurtCollision
; 	ld a, (global_.isaac.recover)
; 	cp 0
; 	jr z, @noHurtCollision
	
; 	;hurting Isaac
; 	inc hl
; 	ld a, (global_.isaac.hp)
; 	sub (hl)
; 	ld (global_.isaac.hp), a
	
; 	;starting recovery
; 	ld a, RECOVERYTIME
; 	ld (global_.isaac.recover), a
; 	;\\\ Hurting Collision ///
; @noHurtCollision:
	
; 	; /// Activation Collision \\\
; 	bit 5, c
; 	jr z, @noReactCollision
	
; 	;getting function address
; 	ld h, d
; 	ld l, e
; 	inc hl
; 	inc hl
; ;	call (hl)
; 	; \\\ Activation Collision ///
; @noReactCollision:
	
	pop de
	pop bc
	ret
; \\\\ Collision Solver for Isaac ////
