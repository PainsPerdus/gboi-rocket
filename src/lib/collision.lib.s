; //// Collision function \\\\
collision:
; /// INIT \\\
; // INIT, line 1 \\
  ld a,(collision_.hitbox1)
  ld hl,global_.hitboxes_width
  add l
  ld l,a  ; hl = hitboxs_width + collision_hitbox1
  ld a,(hl) ; a = hitboxs_width[collision_hitbox1]
  ld hl,collision_.p.1.x
  add (hl)  ; a = collision_p.1.x + hitboxs_width[collision_hitbox1]
  ld (collision_.p_RD.1.x),a ; collision_p_RD.1.x = collision_p.1.x + hitboxs_width[collision_hitbox1];
; \\ INIT, line 1 //
; // INIT, line 2 \\
  ld a,(collision_.hitbox1)
  ld hl,global_.hitboxes_height
  add l
  ld l,a  ; hl = hitboxs_height + collision_hitbox1
  ld a,(hl) ; a = hitboxs_height[collision_hitbox1]
  ld hl,collision_.p.1.y
  add (hl)  ; a = collision_p.1.y + hitboxs_height[collision_hitbox1]
  ld (collision_.p_RD.1.y),a ; collision_p_RD.1.y = collision_p.1.y + hitboxs_height[collision_hitbox1];
; \\ INIT, line 2 //
; // INIT, line 3 \\
  ld a,(collision_.hitbox2)
  ld hl,global_.hitboxes_width
  add l
  ld l,a  ; hl = hitboxs_width + collision_hitbox2
  ld a,(hl) ; a = hitboxs_width[collision_hitbox2]
  ld hl,collision_.p.2.x
  add (hl)  ; a = collision_p.2.x + hitboxs_width[collision_hitbox2]
  ld (collision_.p_RD.2.x),a ; collision_p_RD.2.x = collision_p.2.x + hitboxs_width[collision_hitbox2];
; \\ INIT, line 3 //
; // INIT, line 4 \\
  ld a,(collision_.hitbox2)
  ld hl,global_.hitboxes_height
  add l
  ld l,a  ; hl = hitboxs_width + collision_hitbox2
  ld a,(hl) ; a = hitboxs_height[collision_hitbox2]
  ld hl,collision_.p.2.y
  add (hl)  ; a = collision_p.2.y + hitboxs_width[collision_hitbox2]
  ld (collision_.p_RD.2.y),a ; collision_p_RD.2.y = collision_p.2.y + hitboxs_width[collision_hitbox2];
; \\ INIT, line 4 //
; \\\ INIT ///
; /// COMPARE \\\
; // COMPARE, line 1\\
  ld a,(collision_.p_RD.2.x)
  ld h,a  ; h = collision_p_RD.2.x
  ld a,(collision_.p.1.x) ; a = collision_p.1.x
  cp h
  jp nc,@ret_false ; (if collision_p.1.x > collision_p_RD.2.x) return 0
; \\ COMPARE, line 1 //
; // COMPARE, line 2\\
  ld a,(collision_.p_RD.1.x)
  ld h,a  ; h = collision_p_RD.1.x
  ld a,(collision_.p.2.x) ; a = collision_p.2.x
  cp h
  jp nc,@ret_false ; (if collision_p.2.x > collision_p_RD.1.x) return 0
; \\ COMPARE, line 2 //
; // COMPARE, line 3\\
  ld a,(collision_.p_RD.1.y)
  ld h,a  ; h = collision_p.2.y
  ld a,(collision_.p.2.y) ; a = collision_p_RD.1.y
  cp h
  jp nc,@ret_false ; (if collision_p.2.y > collision_p_RD.1.y) return 0
; \\ COMPARE, line 3 //
; // COMPARE, line 4\\
  ld a,(collision_.p_RD.2.y)
  ld h,a  ; h = collision_p_RD.2.y
  ld a,(collision_.p.1.y) ; a = collision_p.1.y
  cp h
  jp nc,@ret_false ; (if collision_p.1.y > collision_p_RD.2.y) return 0
; \\ COMPARE, line 4 //
  ld a,1
  ret
@ret_false:
  ld a,0
  ret
; \\\ COMPARE ///
; \\\\ Collision function ////