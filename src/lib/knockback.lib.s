; //// Knockback function \\\\
knockback: ; B = Direction of the knockback
  push de

  ; /// load Isaac true position and hitbox \\\
  ld a,(global_.isaac.y)
	add ISAAC_OFFSET_Y
	ld (collision_.p.1.y),a
	add ISAAC_HITBOX_Y
	ld (collision_.p_RD.1.y),a
	ld a,(global_.isaac.x)
	add ISAAC_OFFSET_X
	ld (collision_.p.1.x),a
	add ISAAC_HITBOX_X
	ld (collision_.p_RD.1.x),a
	; \\\ load Isaac true position and hitbox ///

  ld e,DIST_KNOCK_BACK
@knockback_loop:

  ; /// y += dy \\\
  ld a,b
  and %00001111
  bit $3,a
  jr z,@@posit_y
  or %11110000
  @@posit_y:
  ld d,a
  ld hl,collision_.p.1.y
  add (hl)
  ld (hl),a
  ld hl,collision_.p_RD.1.y
  ld a,d
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
  ld d,a
  ld hl,collision_.p.1.x
  add (hl)
  ld (hl),a
  ld a,d
  ld hl,collision_.p_RD.1.x
  add (hl)
  ld (hl),a
  ; \\\ x += dx ///

  call preloaded_collision_obstacles
  and a
  jp nz,@knockback_break
  ; /// Update Isaac pos \\\
  ld a, (collision_.p.1.x)
  sub ISAAC_OFFSET_X
  ld (global_.isaac.x), a
  ld a, (collision_.p.1.y)
  sub ISAAC_OFFSET_Y_FEET
  ld (global_.isaac.y), a
  ; \\\ Update Isaac pos ///
  dec e
  jp nz,@knockback_loop
  pop bc
  ret

@knockback_break:
  ; /// load Isaac true position \\\
  ld a,(global_.isaac.y)
	add ISAAC_OFFSET_Y
	ld (collision_.p.1.y),a
	add ISAAC_HITBOX_Y
	ld (collision_.p_RD.1.y),a
	ld a,(global_.isaac.x)
	add ISAAC_OFFSET_X
	ld (collision_.p.1.x),a
	add ISAAC_HITBOX_X
	ld (collision_.p_RD.1.x),a
  ; \\\ load Isaac true position ///
  pop de
  ret
; \\\\ Knockback function ////
