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

; ///// Hearts \\\\\
ld hl, $9800                     ; start of background
ld b, ISAAC_MAX_HP/2               ; loop iterator
ld de, display_.Heart_shadow     ; stored hearts data
@display_hearts:
ld a, (de)
ld (hl), a
inc hl
inc de
dec b
jr nz, @display_hearts

; \\\\\ Hearts /////


; ////// Start DMA \\\\\\

call HRAM_DMA_PROCEDURE

; \\\\\\ Start DMA //////

; ########## END DISPLAY CRITICAL SECTION ##########
