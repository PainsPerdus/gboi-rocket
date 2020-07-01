; //// Knockback function \\\\
knockback:
  push bc

  ; /// load Isaac true position and hitbox \\\
	ld a, (global_.isaac.x)
	ld (collision_.p.1.x), a
	ld a, (global_.isaac.y)
	ld (collision_.p.1.y), a
	ld a, ISAAC_HITBOX
	ld (collision_.hitbox1), a
	; \\\ load Isaac true position and hitbox ///

  ld c,DIST_KNOCK_BACK
@knockback_loop:

  ; /// y += dy \\\
  ld a,b
  and %00001111
  bit $3,a
  jr z,@@posit_y
  or %11110000
  @@posit_y:
  ld hl,collision_.p.1.y
  add (hl)
  ld (hl),a
  ; \\\ y += dy ///

  ; /// x += dx \\\
  ld a,b
  swap a
  and %00001111
  bit $3,a
  jr z,@@posit_x
  or %11110000
@@posit_x:
  ld hl,collision_.p.1.x
  add (hl)
  ld (hl),a
  ; \\\ x += dx ///

  call collision_obstacles
  and a
  jp nz,@knockback_break
  ; /// Update Isaac pos \\\
  ld a, (collision_.p.1.x)
  ld (global_.isaac.x), a
  ld a, (collision_.p.1.y)
  ld (global_.isaac.y), a
  ; \\\ Update Isaac pos ///
  dec c
  jp nz,@knockback_loop
  pop bc
  ret

@knockback_break:
  ; /// load Isaac true position \\\
  ld a, (global_.isaac.x)
  ld (collision_.p.1.x), a
  ld a, (global_.isaac.y)
  ld (collision_.p.1.y), a
  ; \\\ load Isaac true position ///
  pop bc
  ret
; \\\\ Knockback function ////
