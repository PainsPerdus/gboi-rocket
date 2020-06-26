; //// point struct \\\\
.STRUCT point
    x DB
    y DB
.ENDST
; \\\\ point struct ////

; //// Collision function variables \\\\
.STRUCT collision_var
	p INSTANCEOF point 2
  hitbox1 DB
  hitbox2 DB
	p_RD INSTANCEOF point 2
.ENDST
; \\\\ Collision function variables ////