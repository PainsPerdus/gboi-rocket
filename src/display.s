; ########## START DISPLAY CRITICAL SECTION ##########
display:

; ////// UPDATE SPRITES POSITION \\\\\\



; ///// Isaac \\\\\
		ld hl, ISAAC_SPRITESHEET

; //// Top Tiles \\\\
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
ld d,0
ld e,0
		ld hl,$FE04
		ld a,b
		ld (hl),a ;posY
		inc l
		ld a,c
		add 8
		ld (hl),a ;posX
		inc l
		ld (hl), ISAAC_TOP_RIGHT + 1 ;First isaac standing sprite

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
		jr @endMoving
; \\ Moving //

; // Not Moving \\
@notMoving: 
	//Left sprite id
		ld d, ISAAC_BOTTOM_LEFT_STAND
	//Right sprite id
		ld e, ISAAC_BOTTOM_RIGHT_STAND
; \\ Not Moving //
@endMoving:
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
		ld (hl), d ;Chosen bottom left sprite 

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
		ld (hl), e ;Chosen bottom right sprite

; \\\ Update OAM ///
; \\\\ Bottom Tiles ////
; \\\\\ Isaac /////
; \\\\\\ UPDATE SPRITES POSITION //////


; ########## END DISPLAY CRITICAL SECTION ##########
displayNonCritical: 


; ////// UPDATE ANIMATION FRAMES AND TIMERS \\\\\\

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
