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
  jr nc,@ret_false ; (if collision_p.1.x > collision_p_RD.2.x) return 0
; \\ COMPARE, line 1 //
; // COMPARE, line 2\\
  ld a,(collision_.p_RD.1.x)
  ld h,a  ; h = collision_p_RD.1.x
  ld a,(collision_.p.2.x) ; a = collision_p.2.x
  cp h
  jr nc,@ret_false ; (if collision_p.2.x > collision_p_RD.1.x) return 0
; \\ COMPARE, line 2 //
; // COMPARE, line 3\\
  ld a,(collision_.p_RD.1.y)
  ld h,a  ; h = collision_p.2.y
  ld a,(collision_.p.2.y) ; a = collision_p_RD.1.y
  cp h
  jr nc,@ret_false ; (if collision_p.2.y > collision_p_RD.1.y) return 0
; \\ COMPARE, line 3 //
; // COMPARE, line 4\\
  ld a,(collision_.p_RD.2.y)
  ld h,a  ; h = collision_p_RD.2.y
  ld a,(collision_.p.1.y) ; a = collision_p.1.y
  cp h
  jr nc,@ret_false ; (if collision_p.1.y > collision_p_RD.2.y) return 0
; \\ COMPARE, line 4 //
  ld a,1
  ret
@ret_false:
  ld a,0
  ret
; \\\ COMPARE ///
; \\\\ Collision function ////

; //// Collision function \\\\
collision_obstacles:
  ld b,b
  push de
  push bc

; PRELOAD ARG 1
; I HAVE NO FUCKING IDEA HOW TO DO A MACRO WITH WLA-DX, SO HERE IS A C-C
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
; END C-C

	ld de, global_.blockings
	ld c, n_blockings
	@@loop:
; /// loop start \\\
	ld h,d
	ld l,e

; / set hitbox and position as parameter \
	ldi a, (hl)
	bit ALIVE_FLAG, a
	jr z,@@noCollision ; check if element is alive
	and BLOCKING_SIZE_MASK
	ld (collision_.hitbox2), a
	ldi a, (hl)
	ld (collision_.p.2.y), a
	ld a, (hl)
	ld (collision_.p.2.x), a
; \ set hitbox and position as parameter /

; / test collision \

; STILL NO FUCKING IDEA HOW TO DO A MACRO WITH WLA-DX, SO HERE IS A C-C
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
  jr nc,@@ret_false ; (if collision_p.1.x > collision_p_RD.2.x) return 0
  ; \\ COMPARE, line 1 //
  ; // COMPARE, line 2\\
  ld a,(collision_.p_RD.1.x)
  ld h,a  ; h = collision_p_RD.1.x
  ld a,(collision_.p.2.x) ; a = collision_p.2.x
  cp h
  jr nc,@@ret_false ; (if collision_p.2.x > collision_p_RD.1.x) return 0
  ; \\ COMPARE, line 2 //
  ; // COMPARE, line 3\\
  ld a,(collision_.p_RD.1.y)
  ld h,a  ; h = collision_p.2.y
  ld a,(collision_.p.2.y) ; a = collision_p_RD.1.y
  cp h
  jr nc,@@ret_false ; (if collision_p.2.y > collision_p_RD.1.y) return 0
  ; \\ COMPARE, line 3 //
  ; // COMPARE, line 4\\
  ld a,(collision_.p_RD.2.y)
  ld h,a  ; h = collision_p_RD.2.y
  ld a,(collision_.p.1.y) ; a = collision_p.1.y
  cp h
  jr nc,@@ret_false ; (if collision_p.1.y > collision_p_RD.2.y) return 0
  ; \\ COMPARE, line 4 //
  ld a,1
  jr @@ret_true
@@ret_false:
  xor a
; END C-C
@@ret_true:



	and a
	jr z, @@noCollision
  pop bc
  pop de
  ld b,b
  ret
@@noCollision:
; \ test collision /

@@ending_loop:
	inc de
	inc de
	inc de
	dec c
	jr nz, @@loop
;   \\\\ collision Y  loop ////

  pop bc
  pop de
  ret
; \\\\ Collision function ////


preload_arg1: ; TAKES THES USUAL ARGUMENTS FOR THE FOR FIRST ELEMENT AND LOAD THEM
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
  ret

; //// Collision function \\\\
preloaded_collision:
; /// INIT \\\
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
  jr nc,@ret_false ; (if collision_p.1.x > collision_p_RD.2.x) return 0
; \\ COMPARE, line 1 //
; // COMPARE, line 2\\
  ld a,(collision_.p_RD.1.x)
  ld h,a  ; h = collision_p_RD.1.x
  ld a,(collision_.p.2.x) ; a = collision_p.2.x
  cp h
  jr nc,@ret_false ; (if collision_p.2.x > collision_p_RD.1.x) return 0
; \\ COMPARE, line 2 //
; // COMPARE, line 3\\
  ld a,(collision_.p_RD.1.y)
  ld h,a  ; h = collision_p.2.y
  ld a,(collision_.p.2.y) ; a = collision_p_RD.1.y
  cp h
  jr nc,@ret_false ; (if collision_p.2.y > collision_p_RD.1.y) return 0
; \\ COMPARE, line 3 //
; // COMPARE, line 4\\
  ld a,(collision_.p_RD.2.y)
  ld h,a  ; h = collision_p_RD.2.y
  ld a,(collision_.p.1.y) ; a = collision_p.1.y
  cp h
  jr nc,@ret_false ; (if collision_p.1.y > collision_p_RD.2.y) return 0
; \\ COMPARE, line 4 //
  ld a,1
  ret
@ret_false:
  ld a,0
  ret
; \\\ COMPARE ///
; \\\\ Collision function ////
