display:
; ////// UPDATE ANIMATION FRAMES AND TIMERS \\\\\\

//Do pascal's useless stupid stuff
xor a
ld (display_.isaac.shoot_timer), a ; TODO hard coded
; // Update fly animation frame \\
ld a, (display_.fly.frame)
inc a
ld (display_.fly.frame), a
; \\ Update fly animation frame //

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
