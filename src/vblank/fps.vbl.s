; ########## FPS Counter Section ##########
	
; /// FPS Update Timer (runs every VBlank) \\\
; Convert FPS skip counter to digit tiles 
ld a, (display_.fps_skip_counter)
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

; ///// Render FPS Counter \\\\\
ld hl, $9800 + 18                   ; top-right position (right side of screen - 1)
ld a, NUMBERS_SPRITESHEET ; 0 sprite
add a, b ; tens digit
ld (hl), a
inc hl
ld a, NUMBERS_SPRITESHEET ; 0 sprite
add a, c ; ones digit
ld (hl), a
; \\\\\ Render FPS Counter /////

