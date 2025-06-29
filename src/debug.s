; ///// Debug Functions like FPS counter \\\\\
; check if select key was pressed the released to toggle fps debug mode
ld a,(check_inputs_)
ld b,a
ld a,(global_.debug)
bit SEL_KEY, b
jr z, @noSelectKey
    set DEBUG_SEL_KEY, a ; set bit 2 (sel key press)
    ld (global_.debug), a
    jr @end
@noSelectKey:
bit DEBUG_SEL_KEY, a
jr z, @end
    xor 3 ; flip LSB and bit 2 (debug mode fps and sel key press)
    ld (global_.debug), a
@end:
; \\\\\ Debug Functions like FPS counter /////
