displayRoom:
	push bc
	push de ;Save callee saved registers
	
; /////// DRAWING WALLS \\\\\\\
;    ///// UPPER WALL \\\\\
	
	ld de,20       ; loop iterator
	ld hl,$9800
	@wall_up_line1:			; while de != 0
	ld a, FLAT_BACKGROUND_WALL
	ldi (hl),a	 
	dec de		; de --
	ld a,e
	or d
	jr nz,@wall_up_line1	; end while
	ld bc, $000C   ; next line distance
	add hl, bc                      ;next line
	ld a, FLAT_BACKGROUND_WALL ;
	ldi (hl),a
	ld a, UP_RIGHT_CORNER ;
	ldi (hl),a
	ld de,16
	@wall_up_line2:			; while de != 0
	ld a, UP_BACKGROUND_WALL ;
	ldi (hl),a
	dec de	; de --
	ld a,e
	or d
	jr nz,@wall_up_line2	; end while
	ld a, UP_LEFT_CORNER ;
	ldi (hl),a
	ld a, FLAT_BACKGROUND_WALL ;
	ldi (hl),a
;    \\\\\ UPPER WALL /////

;    ///// SIDE WALLS \\\\\
	ld de,14
	@walls_sides:			; while de != 0
	ld bc, $000C   ; next line distance
	add hl, bc     ;next line
	ld a, FLAT_BACKGROUND_WALL ;
	ldi (hl),a	 
	ld a, LEFT_BACKGROUND_WALL ;
	ldi (hl), a
	ld bc, $0010
	add hl, bc
	ld a, RIGHT_BACKGROUND_WALL
	ldi (hl),a	
	ld a, FLAT_BACKGROUND_WALL
	ldi (hl), a
	dec de		; de --
	ld a,e
	or d
	jr nz,@walls_sides	; end while
;    \\\\\ SIDE WALLS /////
	ld bc, $000C   ; next line distance
	add hl, bc                      ;next line
;    ///// DOWN WALL \\\\\
	ld a, FLAT_BACKGROUND_WALL
	ldi (hl),a
	ld a, DOWN_LEFT_CORNER ;
	ldi (hl),a
	ld de,16       ; loop iterator
	@wall_down_line1:			; while de != 0
	ld a, DOWN_BACKGROUND_WALL 
	ldi (hl),a	; *hl <- 0; hl++
	dec de		; de --
	ld a,e
	or d
	jr nz,@wall_down_line1	; end while
	ld a, DOWN_RIGHT_CORNER
	ldi (hl),a
	ld a, FLAT_BACKGROUND_WALL
	ldi (hl),a

	ld bc, $000C   ; next line distance
	add hl, bc                      ;next line

	ld de,20
	@wall_down_line2:			; while de != 0
	ld a, FLAT_BACKGROUND_WALL ;
	ldi (hl),a	; *hl <- 0; hl++
	dec de		; de --
	ld a,e
	or d
	jr nz,@wall_down_line2	; end while
;    \\\\\ DOWN WALL /////

;    ///// DETAILING \\\\\

	ld a, FIRST_WALL_DETAIL
	ld hl, $9805
	ld (hl),a
	ld hl, $9A2F
	ld (hl),a
	inc a
	ld hl, $9810
	ld (hl),a
	ld hl, $9A24
	ld (hl),a
	inc a
	ld hl, $9880
	ld (hl),a
	ld hl, $99B3
	ld (hl),a
	inc a
	ld hl, $9980
	ld (hl),a
	ld hl, $9873
	ld (hl),a

	inc a
	ld hl, $9826
	ld (hl),a
	inc a
	ld hl, $982D
	ld (hl),a
	inc a
	ld hl, $98C1
	ld (hl),a
	inc a
	ld hl, $98D2
	ld (hl),a
	inc a
	ld hl, $9961
	ld (hl),a
	inc a
	ld hl, $9992
	ld (hl),a
	inc a
	ld hl, $9A06
	ld (hl),a
	inc a
	ld hl, $9A0D
	ld (hl),a
	

;    \\\\\ DETAILING /////

; \\\\\\\ DRAWING WALLS ///////

; ///// CLEAR ROOM \\\\\
	ld d, 14
	ld e, 16                ; loop iterators
	ld b, $00
	ld hl,$9842
@clear_line:			; while de != 0
	ld (hl),b	 
	inc hl
	dec e		        ; e --
	jr nz,@clear_line       ; end while
	ld a,d
	ld d,$00
	ld e, 16                ; loop iterator
	add hl, de
	dec a
	ld d,a                  ; d --
	jr nz,@clear_line
	
; \\\\\ CLEAR ROOM /////

; // Add rocks and pits
	ld de, global_.blockings
	ld c, n_blockings
@looptodisplayrocks:

	ld a,(de)
	cp ROCK_INFO		; test if the element is a living rock
	jp nz, @not_rock
	ld h,d
	ld l,e
	inc hl
	ld b, (hl) ;y position in pixels (must be a multiple of 8)
	inc hl
	ld a, (hl) ;x position in pixels (must be a multiple of 8)
	ld l,ROCKS_SPRITESHEET ;start tile id
	call displayBackgroundTile
@not_rock:

	ld a,(de)
	cp PIT_INFO		; test if the element is a living pit
	jp nz, @not_pit

	ld h,d
	ld l,e
	inc hl
	ld b, (hl) ;y position in pixels (must be a multiple of 8)
	inc hl
	ld a, (hl) ;x position in pixels (must be a multiple of 8)
	ld l,PIT_SPRITESHEET ;start tile id
	call displayBackgroundTile
@not_pit:

	inc de
	inc de
	inc de
	dec c
	jr nz, @looptodisplayrocks

	ld a, (load_map_.doors)
	bit 3, a
	jr nz, @closed
	xor a
	jr @endDoors
@closed:
	ld a, 1
@endDoors
	ld b, a
	ld a, (load_map_.doors)
	and %11110000
	call displayDoors

; // objects
	ld de, global_.objects
	ld c, n_objects
@looptodisplayObjects:

	ld a,(de)
	cp STAIRS_INFO		; test if the element is a living rock
	jp nz, @not_stairs

	ld h,d
	ld l,e
	inc hl
	ld b, (hl) ;y position in pixels (must be a multiple of 8)
	inc hl
	ld a, (hl) ;x position in pixels (must be a multiple of 8)
	ld l,TRAPDOOR_SPRITESHEET ;start tile id
	call displayBackgroundTile
@not_stairs:

	ld hl, _sizeof_object
	add hl, de
	ld d, h
	ld e, l
	dec c
	jr nz, @looptodisplayObjects

	pop de
	pop bc ;Restore callee saved registers
	ret
