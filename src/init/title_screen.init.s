; /////// ENABLE SCREEN \\\\\\\
ld a,%10000011  ; screen on, bg on, tiles at $8000
ldh ($40),a
; \\\\\\\ ENABLE SCREEN ///////
