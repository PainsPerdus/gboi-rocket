display:
; ////// UPDATE SPRITES POSITION \\\\\\


	ld hl, ISAAC_SPRITESHEET

; ///// Isaac \\\\\
		ld a, (global_.isaac.y)
		ld b,a
		ld a, (global_.isaac.x)
		ld c,a
//top left
		ld hl,$FE00
		ld a, b
		ld (hl), a ;posY
		inc l
		ld a, c
		ld (hl), a ; posX
		;inc l
		;ld a, global_.isaac.position
		
		;jp nc 
		;ISAAC_TOP_LEFT + 1;First isaac standing sprite
		;@top_done :
		;ld (hl), 
		inc l
		ld (hl), ISAAC_TOP_LEFT + 1 ;First isaac standing sprite
		
//top right
		ld hl,$FE04
		ld a,b
		ld (hl),a ;posY
		inc l
		ld a,c
		add 8
		ld (hl),a ;posX
		inc l
		ld (hl), ISAAC_TOP_RIGHT + 1 ;First isaac standing sprite

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
		xor a
		add ISAAC_BOTTOM_LEFT_WALK
		add e
		ld d,a ;left_sprite_id
	//Right sprite id
		ld a, (global_.isaac.direction)
		and %00000001 ; bit0((global_.isaac.direction))
		add ISAAC_BOTTOM_RIGHT_WALK
		add e
		ld e, a ;right_sprite_id
	//Update Timer
		ld a,(display_.isaac.walk_timer)
  		and a
  		jp nz,@end_timer
  		ld a,11
@end_timer:
		dec a
  		ld (display_.isaac.walk_timer), a
		jp @endBottom ;jump to the end of the else
; \\ Moving //

; // Not Moving \\
@notMoving: 
	//Left sprite id
		ld d, ISAAC_BOTTOM_LEFT_STAND
	//Right sprite id
		ld e, ISAAC_BOTTOM_RIGHT_STAND
	//Update Timer
		xor a
		ld (display_.isaac.walk_timer), a ;reset walk_timer
; \\ Not Moving //
@endBottom:
; \\\Setup sprite ids///

; /// Update OAM \\\

//bottom left
		ld hl,$FE08
		ld a, (global_.isaac.y)
		add 8
		ld (hl), a ;posY
		inc l
		ld a, (global_.isaac.x)
		ld (hl), a ;posX
		inc l
		ld a,(display_.isaac.walk_timer) ;if walk timer is 0, we update the bottom sprite
		and a ;update Z
		jr nz, @noUpdateLeft
		ld (hl), d ;Chosen bottom left sprite 
@noUpdateLeft
		
//bottom right
		ld hl,$FE0C
		ld a, (global_.isaac.y)
		add 8
		ld (hl), a ;posY
		inc l
		ld a, (global_.isaac.x)
		add 8
		ld (hl), a ;posX
		inc l
		ld a,(display_.isaac.walk_timer) ;if walk timer is 0, we update the bottom sprite
		and a ;update Z
		jr nz, @noUpdateRight
		ld (hl), e ;Chosen bottom right sprite
@noUpdateRight

; \\\ Update OAM ///
; \\\\ Bottom Tiles ////
; \\\\\ Isaac /////
; \\\\\\ UPDATE SPRITES POSITION //////


; ////// UPDATE ANIMATION FRAMES AND TIMERS \\\\\\
	
	ld a,(display_.isaac.walk_timer) ;if walk timer is 0, we update the frames
	and a ;update Z
	jr nz, @noUpdateFrames
	ld a, (display_.isaac.frame)
	xor %00000001 ;bit0(a)=!bit0(a)
	ld (display_.isaac.frame),a
@noUpdateFrames

; \\\\\\ UPDATE ANIMATION FRAMES AND TIMERS //////
