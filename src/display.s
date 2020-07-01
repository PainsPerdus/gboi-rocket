display:
; ////// UPDATE SHADOW OAM \\\\\\


updateShadowOAM:

//TODO : only clear what's not used, quick for to avoid dead sprites
; ////// Clear shadow OAM \\\\\\\
    ld hl, SHADOW_OAM_START
    ld b,40*4 ; Shadow OAM size (= OAM size)
@loopClearShadowOAM:
    ld (hl),$00
    inc l
    dec b       ; b --
    jr nz,@loopClearShadowOAM   ; end while
; \\\\\\ Clear shadow OAM ///////

; // Init OAM pointer \\
		xor a
		ld (display_.OAM_pointer), a
; \\ Init OAM pointer //

; ///// Isaac \\\\\

ld a, (global_.isaac.recover)
bit 2,a
jp nz, @no_isaac ;If isaac is recovering and should be in the hidden state, we don't need to show it.

; //// Top Tiles \\\\
; /// Left \\\\
		ld hl, SHADOW_OAM_START
		ld a,(display_.OAM_pointer)
		ld l,a 
		ld a, (global_.isaac.y)
		ld (hl), a ;posY
		inc l
		ld a, (global_.isaac.x)
		ld (hl), a ; posX
		inc l
		ld a, (global_.isaac.direction)
		and %00000010                  ;get second last bit
		rrca
		ld d, a                     ; d <= bit0(position)
		ld a, (display_.isaac.shoot_timer)                      ; a <= (shoot_timer >0)
		and d
		ld e, a                     ; e <= ((shoot_timer >0) & position)
		ld a, ISAAC_TOP_LEFT
		add d
		add e
		ld (hl), a
; \\\ Left ///
		inc l
		inc l ;next sprite in OAM
; /// Right \\\
		ld a,(global_.isaac.y)
		ld (hl),a ;posY
		inc l
		ld a,(global_.isaac.x)
		add 8
		ld (hl),a ;posX
		inc l
		ld a, (global_.isaac.direction)
		and %00000001                     ;get last bit
		ld d, a                     ; d <= bit1(position)
		ld a, (display_.isaac.shoot_timer)     ; a <= (shoot_timer >0)
		and d
		ld e, a                     ; e <= ((shoot_timer >0) & position)
		ld a, ISAAC_TOP_RIGHT
		add d
		add e
		ld (hl), a
; \\\ Right ///
		inc l
		inc l ; next isaac sprite

; \\\\ Top Tiles ////

; //// Bottom Tiles \\\\

; /// Setup sprite ids \\\
		ld a, (global_.isaac.speed)
		and a ; update Z flag with value of a
		jp z, @notMoving ; Isaac is not moving if its speed is 0
; // Moving \\
		ld a, (display_.isaac.frame)
		sla a ;a=a*2 (shift left)
		ld e,a //will store right_sprite_id
	//Left sprite id
		ld a, (global_.isaac.direction)
		and %00000010 ; bit1((global_.isaac.direction))
		rrca ;rotate right accumulator
		add ISAAC_BOTTOM_LEFT_WALK
		add e
		ld d,a ;left_sprite_id
	//Right sprite id
		ld a, (global_.isaac.direction)
		and %00000001 ; bit0((global_.isaac.direction))
		add ISAAC_BOTTOM_RIGHT_WALK
		add e
		ld e, a ;right_sprite_id
		jr @endMoving
; \\ Moving //

; // Not Moving \\
@notMoving:
	//Left sprite id
		ld a, (global_.isaac.direction)
		and %00000010
		rrca
		add ISAAC_BOTTOM_LEFT_STAND
		ld d, a
	//Right sprite id
		ld a, (global_.isaac.direction)
		and %00000001
		add ISAAC_BOTTOM_RIGHT_STAND
		ld e, a
; \\ Not Moving //
@endMoving:
; \\\Setup sprite ids///

; /// Update OAM \\\

//bottom left
		ld a, (global_.isaac.y)
		add 8
		ld (hl), a ;posY
		inc l
		ld a, (global_.isaac.x)
		ld (hl), a ;posX
		inc l
		ld (hl), d ;Chosen bottom left sprite

		inc l
		inc l ;next sprite
//bottom right
		ld a, (global_.isaac.y)
		add 8
		ld (hl), a ;posY
		inc l
		ld a, (global_.isaac.x)
		add 8
		ld (hl), a ;posX
		inc l
		ld (hl), e ;Chosen bottom right sprite
		inc l
		inc l; next sprite


; \\\ Update OAM ///

; \\\\ Bottom Tiles ////

	ld a,l
	ld (display_.OAM_pointer), a

@no_isaac

; \\\\\ Isaac /////

; //// ENNEMIES \\\\


	ld e, n_enemies      ; loop iterator
	ld hl, global_.enemies      ; address of first ennemy strucs
	ld a, (display_.OAM_pointer)
	ld bc, SHADOW_OAM_START
	ld c, a                   ; OAM address of the first ennemy
@next_ennemy:
	ldi a, (hl)                  ; charge info byte
	bit ALIVE_FLAG, a            ; "alive" bit
	jp z, @dead
	and ENEMY_ID_MASK
	cp  %00010000
	jr z, @fly
	;cp %00011000
	;jr z, @wasp

	; MORE ENNEMIES OPTIONS HERE
	jp @dead

@fly:
	ld a, (hl)
	ld (bc), a
	inc l
	inc c
	ld a, (hl)
	ld (bc), a
	inc c
	ld a, FLY_SPRITESHEET
	push hl
	ld h, a
	ld a, (display_.fly.frame)
	and %00000100                   ; checking animation frame
	sra a
	sra a
	add h
	pop hl
	ld (bc), a
	inc c
	inc c

	jp @ennemy_updated
/*
@wasp:
	ld a, (hl)
	ld (bc), a
	inc l
	inc c
	ld a, (hl)
	ld (bc), a
	inc c
	ld a, WASP_SPRITESHEET
	push hl
	ld h, a
	ld a, (display_.fly.frame)
	and %00000100
	sra a
	sra a
	add h
	pop hl
	ld (bc), a
	inc c
	inc c

	jp @ennemy_updated
*/
	;...
	; MORE ENNEMIES LABELS HERE

@dead:
	push bc				; 48 cycles, less than 7 inc hl...
	ld bc,_sizeof_enemy-1
	add hl,bc
	pop bc

	dec e
	jp nz, @next_ennemy
	jp @end_loop

@ennemy_updated:
	push bc				; 48 cycles, same as 6 inc hl...
	ld bc,_sizeof_enemy-2
	add hl,bc
	pop bc

	dec e
	jp nz, @next_ennemy

@end_loop:
	ld a, c
	ld (display_.OAM_pointer), a

; \\\\ ENNEMIES ////

; ///// Tears \\\\\
	ld a,0 ;Display not reversed
	call displayIsaacTears
; \\\\\ Tears /////

; \\\\\\ UPDATE SHADOW OAM \\\\\\

@endennemies

; ///// Hearts \\\\\
//Quick fix to avoid isaac HP being <0...
ld a,(global_.isaac.hp)
bit 7,a
jr z,@noreset
ld a,ISAAC_MAX_HP
ld (global_.isaac.hp),a
@noreset

	ld d, HEARTS_SPRITESHEET  ; set sprite to empty heart
	ld e, ISAAC_MAX_HP
	ld hl, display_.Heart_shadow
@loopEmptyHearts:
	ld (hl), d                ; draw an empty heart
	inc hl
	dec e
	dec e
	jr nz, @loopEmptyHearts
	ld a,(global_.isaac.hp)   ;hp
	and a
	jr z, @EndHearts
	ld hl, display_.Heart_shadow
	inc d                     ; set sprite to full heart
@loopFullHearts:
	dec a
	jr z, @HalfHeart
	ld (hl), d                ; draw a full heart
	inc hl
	dec a
	jr z, @EndHearts
	jr @loopFullHearts
@HalfHeart:
	inc d                       ; now sprite half heart
	ld (hl), d
@EndHearts:
; \\\\\ Hearts /////



; ////// UPDATE ANIMATION FRAMES AND TIMERS \\\\\\

;//Do pascal's useless stupid stuff
updateAnimaton:
xor a
ld (display_.isaac.shoot_timer), a ; TODO hard coded

; // Update fly animation frame \\
ld a, (display_.fly.frame)
inc a
ld (display_.fly.frame), a
; \\ Update fly animation frame //

; ///// Isaac \\\\\
        ld a, (global_.isaac.speed)
        and a ; update Z flag with value of a
        jp z, @notMoving ; Isaac is not moving if its speed is 0
; //// Moving \\\\
; /// Update Timer \\\
        ld a,(display_.isaac.walk_timer)
        and a
        jr nz,@end_timer ;Reset timer and update frame when timer is 0
; // Update animation frame \\
        ld a, (display_.isaac.frame)
        xor %00000001 ;bit0(a)=!bit0(a)
        ld (display_.isaac.frame),a
; \\ Update animation frame //
        //Timer is 0 so we reset the timer
        ld a,20
@end_timer:
        //We decrease the timer
        dec a
        ld (display_.isaac.walk_timer), a
; \\\ Update Timer ///
        jr @endMoving
; \\\\ Moving ////
; //// Not Moving \\\\
@notMoving
        xor a
    //Reset the timer
        ld (display_.isaac.walk_timer), a
    //Reset walking animation frame
        ld (display_.isaac.frame), a
@endMoving
; \\\\ Not Moving ////
; \\\\\ Isaac /////
; \\\\\\ UPDATE ANIMATION FRAMES AND TIMERS //////
