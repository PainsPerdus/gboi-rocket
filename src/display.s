display:
; ////// UPDATE SHADOW OAM \\\\\\


updateShadowOAM:

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

ld a,0 ;Display not reversed
call displayIsaacTears

/*; ///// Tears \\\\\


	//Show the OAM_ISAAC_TEARS_SIZE first active tears
	
	ld d, n_isaac_tears ;loop counter
	ld bc, OAM_ISAAC_TEARS ;Pointer to the start of the tears in OAM
	ld hl, global_.isaac_tears ;Pointer to the start of the tears
@loopUpdateTears: //do {
	ldi a, (hl) ;tear posY
	and a
	jr z, @disabledTear ;if a==0 then tear is disabled
	ld (bc), a ;tear pos Y in OAM
	inc c
	ld a, (hl) ;tear posX
	ld (bc), a ;tear pos X in OAM
	ld a,c
	cp OAM_ISAAC_TEARS-OAM_ISAAC+4*(OAM_ISAAC_TEARS_SIZE-1)+1 ;check if c is last tear sprite pos X in OAM
	jr z, @endTears
	inc c
	inc c
	inc c ;next tear address in OAM
@disabledTear:
	//Get pointer to next tear Y position in hl
	ld a,d ;Save d
	ld de,_sizeof_tear-1
	add hl, de ;Next tear Y
	ld d,a ;Restore d
	dec d ;loop counter --
	jr nz, @loopUpdateTears //} while((--d)!=0)
@endTears:


; \\\\\ Tears ///// */

; //// ENNEMIES \\\\

	ld e, n_enemies      ; loop iterator
	ld hl, global_.enemies      ; address of first ennemy strucs
	ld bc, SHADOW_OAM_START
	ld a, (display_.OAM_pointer)  
	ld c, a                   ; OAM address of the first ennemy
@next_ennemy:
	ldi a, (hl)                  ; charge info byte
	bit ALIVE_FLAG, a            ; "alive" bit
	jp z, @dead
	and ENEMY_ID_MASK
	cp  %00010000
	jr z, @fly
	; cp %00110000...

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
	and %00000010
	sra a
	add h
	pop hl
	ld (bc), a
	inc c
	inc c

	jp @ennemy_updated


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

; \\\\\\ UPDATE SHADOW OAM \\\\\\

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
