display:
; ////// INIT DIRECTION \\\\\\

/*
ld a, (global_.isaac.speed)
ld b,a
and %11110000
jp nz, @horizontal
bit 3, b
jp nz, @bas
ld a, 0
@bas:
ld a, 3
jp @end
@horizontal:
bit 7, b
jp nz, @droite
ld a, 2
@droite:
ld a, 1
@end:
ld (global_.isaac.direction), a
*/

ld a, 3
ld (global_.isaac.direction), a ; TODO determine position (now hard coded)
ld a, 0
ld (display_.isaac.shoot_timer), a ; TODO hard coded


; ////// UPDATE SPRITES POSITION \\\\\\


; // Isaac \\
		ld a, (global_.isaac.y)
		ld b,a
		ld a, (global_.isaac.x)
		ld c,a
;/ top tiles \
;left
		ld hl,$FE00
		ld a, b
		ld (hl), a ;posY
		inc l
		ld a, c
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
		
;right
		ld hl,$FE04
		ld a,b
		ld (hl),a ;posY
		inc l
		ld a,c
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
;\ top tiles /

//bottom left
		ld hl,$FE08
		ld a,b
		add 8
		ld (hl), a ;posY
		inc l
		ld a,c
		ld (hl), a ;posX
		inc l
		ld (hl), ISAAC_BOTTOM_LEFT_STAND + 1 ;Third isaac standing sprite
//bottom right
		ld hl,$FE0C
		ld a,b
		add 8
		ld (hl), a ;posY
		inc l
		ld a,c
		add 8
		ld (hl), a ;posX
		inc l
		ld (hl), ISAAC_BOTTOM_RIGHT_STAND +1 ;Fourth isaac standing sprite



; \\ Isaac //
; \\\\\\ UPDATE SPRITES POSITION //////

