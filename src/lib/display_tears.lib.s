displayIsaacTears:
	push bc 
	push de ;save callee saved registers

;	bit 0,a
;	jr nz, @reverseOrder

	ld d, n_isaac_tears ;loop counter
	ld hl, global_.isaac_tears
	ld bc, SHADOW_OAM_START
	ld a, (display_.OAM_pointer)
	ld c,a ;start at OAM_pointer
@loopFillTears:
	ldi a, (hl) ;tear posY
	and a
	jr z, @continueLoopFillTears
	ld (bc), a ;tear posY in OAM
	inc bc
	ld a, (hl) ;tear posX
	ld (bc), a ;tear posX in OAM
	inc bc
	ld a, TEAR_SPRITESHEET
	ld (bc), a ;set spritesheet number
	inc bc ;palette
	inc bc ;next tile Y
	;ld a,c
	;cp OAM_SIZE ;break if c==OAM_SIZE
	;jp z, @endLoopFillTears
@continueLoopFillTears:
	;//Get next tear Y position in hl	
	ld a,d ;save d
	ld de,_sizeof_tear-1
	add hl, de ;Next tear Y
	ld d,a ;Restore d
	dec d
	jr nz, @loopFillTears
@endLoopFillTears:
	jr @endTears

@reverseOrder:


@endTears:

	;//Update the OAM_pointer
	ld a, c
	ld (display_.OAM_pointer), a

	pop de
	pop bc ;pop callee saved registers
	ret

displayEnnemyTears:


	ret
