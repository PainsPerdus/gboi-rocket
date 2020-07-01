; /// all the door functions \\\
top_door_fun:
    ld a, $10
    ld (global_.isaac.recover), a
    ret

bot_door_fun:
    ld a, $10
    ld (global_.isaac.recover), a
    ret

left_door_fun:
    ld a, $10
    ld (global_.isaac.recover), a
    ret

right_door_fun:
    ld a, $10
    ld (global_.isaac.recover), a
    ret
; \\\ all the door functions ///