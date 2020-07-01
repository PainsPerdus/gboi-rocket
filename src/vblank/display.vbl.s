; ########## START DISPLAY CRITICAL SECTION ##########
display_vbl:

; /// Isaac Mouth Pixel \\\
ld hl, ISAAC_MOUTH_PIXEL_1
ld a, (hl)
or %00000001
ld (hl), a
ld hl, ISAAC_MOUTH_PIXEL_2
ld a, (hl)
or %00000001
ld (hl), a

ld a, (global_.isaac.direction)
cp %00000010
jp nz, @face_left

ld hl, ISAAC_MOUTH_PIXEL_1
ld a, (hl)
and %11111110
ld (hl), a
ld hl, ISAAC_MOUTH_PIXEL_2
ld a, (hl)
and %11111110
ld (hl), a

@face_left:
; \\\ Isaac Mouth Pixel ///

//Quick fix to avoid isaac HP being <0...
ld a,(global_.isaac.hp)
bit 7,a
jr z,@noreset
ld a,ISAAC_MAX_HP
ld (global_.isaac.hp),a
@noreset

; ///// Hearts \\\\\
	ld d, HEARTS_SPRITESHEET  ; set sprite to empty heart
	ld e, ISAAC_MAX_HP
	ld hl, $9800
@loopEmptyHearts:
	ld (hl), d                ; draw an empty heart
	inc hl
	dec e
	dec e
	jr nz, @loopEmptyHearts
	ld a,(global_.isaac.hp)   ;hp
	and a
	jr z, @EndHearts
	ld hl, $9800
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


; ////// Start DMA \\\\\\

call HRAM_DMA_PROCEDURE

; \\\\\\ Start DMA //////

; ########## END DISPLAY CRITICAL SECTION ##########
