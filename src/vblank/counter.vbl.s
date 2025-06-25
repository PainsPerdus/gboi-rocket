; ########## Score (or FPS counter) Section ##########

ld a, (display_.counter)
; Extract tens digit  
ld b, 0
@tensLoop:
	cp 10
	jr c, @tensDigitDone
	sub 10
	inc b
	jr @tensLoop
@tensDigitDone:
	ld c, a
; b = tens, c = ones

; ///// Render Counter \\\\\
ld hl, $9800 + 18                   ; top-right position (right side of screen - 2)
ld a, NUMBERS_SPRITESHEET ; 0 sprite
add a, b ; tens digit
ld (hl), a
inc hl
ld a, NUMBERS_SPRITESHEET ; 0 sprite
add a, c ; ones digit
ld (hl), a
; \\\\\ Render Counter /////
