initHitBoxes:

; // init hitboxes
    ld hl, global_.hitboxes_width
    ld a, $08
    ldi (hl), a
	ld a, $00
    ldi (hl), a
    ld a, $08
    ldi (hl), a
	ld a, $10
    ldi (hl), a
	ldi (hl), a
	ld a, $08
	ldi (hl), a
	ld a, $A0
	ldi (hl), a
	ld a, $10
	ldi (hl), a
    ld hl, global_.hitboxes_height
    ld a, $08
    ldi (hl), a
    ldi (hl), a
	ld a, $00
    ldi (hl), a
	ld a, $10
    ldi (hl), a
	ld a, $08
	ldi (hl), a
	ld a, $10
	ldi (hl), a
	ldi (hl), a
	ld a, $90
	ldi (hl), a


global_init:

	ld hl,global_.blocking_inits

@rock:
; ////// ROCK \\\\\\
	ld a,ROCK_INFO
	ldi (hl),a
; \\\\\\ ROCK //////

@void:
; ////// VOID \\\\\\
	ld a, VOID_INFO
	ldi (hl),a
; \\\\\\ VOID //////

@hwall:
; ////// horizontal wall \\\\\\
	ld a, HWALL_INFO
	ldi (hl),a
; \\\\\\ horizontal wall //////

@vwall:
; ////// vertical wall \\\\\\
	ld a, VWALL_INFO
	ldi (hl),a
; \\\\\\ vertical wall //////

@isaac_init:
	ld hl, global_.isaac
	ld a,$20
	ldi (hl),a; x = 32
	ld a,$40
	ldi (hl),a; y = 64
	ld a,$7F
	ldi (hl),a; hp = $7F
	ld a,1
	ldi (hl),a; dmg = 1
	xor a
	ldi (hl),a
	ldi (hl),a; flags off
	ld a,$10
	ldi (hl),a; range = 16
	ld a,0
	ldi (hl),a; speed = 0
	ld a,%00010000
	ldi (hl),a; tear x=2, tear y=0, a_flag = 0, b_flag = 0
	xor a
	ldi (hl),a; recover=0
	ldi (hl),a; bombs=0
	ld a,%00000011
	ldi (hl),a ; direction : smiling to the camera
  ld a,1
  ldi (hl),a  ; lagCounter
  ldi (hl),a  ; speedFreq

	ld b,n_blockings
	ld hl, global_.blockings
@blocking_loop: ; they are no element for now
	ld a, (global_.blocking_inits.2.info)
	ldi (hl), a
	xor a
	ldi (hl), a
	ldi (hl), a
	dec b
	jp nz,@blocking_loop

	; tears
	ld hl, global_.issac_tear_pointer
	xor a
	ldi (hl),a	; issac_tear_pointer = 0
	ld hl, global_.isaac_tears
	ld b,n_isaac_tears
@isaac_tears_loop:
	ld a,30
	ldi (hl),a ; x = 30
	ldi (hl),a ; y = 30
	xor a
	ldi (hl),a ;id
	ldi (hl),a ;speed
	ldi (hl),a ;ttl
	dec b
	jp nz,@isaac_tears_loop

	ldi (hl),a	; ennemy_tear_pointer = 0
	ld b,n_ennemy_tears
@ennemy_tears_loop:
  xor a
  ldi (hl),a ; x = 30
  ldi (hl),a ; y = 30
  ldi (hl),a ;id
  ldi (hl),a ;speed
  ldi (hl),a ;ttl
	dec b
	jp nz,@ennemy_tears_loop

	ld hl, global_.enemy_inits

@void_enemy:
	; /// void enemy \\\
	ld a, VOID_ENEMY_INFO
	ldi (hl),a
	ld a,VOID_ENEMY_HP
	ldi (hl), a ; no hp
  ld a,VOID_ENEMY_DMG
	ldi (hl), a ; void enemy doesn't exist, it can't hurt you
	ld a,VOID_ENEMY_SPEED_FREQ
  ldi (hl),a
	; \\\ void enemy ///

@hurting_rock:
	; /// hurting rock \\\
	ld a, HURTING_ROCK_INFO
	ldi (hl), a
	ld a, HURTING_ROCK_HP
	ldi (hl), a
	ld a, HURTING_ROCK_DMG
	ldi (hl), a
  ld a,HURTING_ROCK_SPEED_FREQ
  ldi (hl),a
	; \\\ hurting rock ///

	ld hl, global_.enemies
	ld b, n_enemies
@enemy_loop:
	ld a, (global_.enemy_inits.1.info)
	ldi (hl), a
	xor a
	ldi (hl), a
	ldi (hl), a
	ld a, (global_.enemy_inits.1.hp)
	ldi (hl), a
	xor a
	ldi (hl), a
	ld a, (global_.enemy_inits.1.dmg)
	ldi (hl), a
  ld a, (global_.enemy_inits.1.speedFreq)
  ldi (hl), a
  ldi (hl), a
	dec b
	jp nz, @enemy_loop

	ld hl, global_.object_inits

@void_object:
	; /// void object \\\
	ld a, VOID_OBJECT_INFO
	ldi (hl),a
	xor a
	ldi (hl), a
	ldi (hl), a ; no function
	; \\\ void object ///

	ld hl, global_.objects
	ld b, n_objects
@object_loop:
	ld a, (global_.object_inits.1.info)
	ldi (hl), a
	xor a
	ldi (hl), a
	ldi (hl), a
	ld a, (global_.object_inits.1.function)
	ldi (hl), a
	ld a, (global_.object_inits.1.function + 1)
	ldi (hl), a
	dec b
	jp nz, @object_loop

@wall_inits
   ld hl, global_.blockings+(_sizeof_blocking * (n_blockings - 4))

; // init top wall
    ld a, (global_.blocking_inits.3.info)
    ldi (hl), a
    ld a, 16
    ldi (hl), a ; y = 16
    ld a, 8
    ldi (hl), a ; x = 8

; // init bottom wall
    ld a, (global_.blocking_inits.3.info)
    ldi (hl), a
    ld a, 144
    ldi (hl), a ; y = 144
    ld a, 8
    ldi (hl), a ; x = 8

; // init left wall
    ld a, (global_.blocking_inits.4.info)
    ldi (hl), a
    ld a, 16
    ldi (hl), a ; y = 16
    ld a, 8
    ldi (hl), a ; x = 8

; // init right wall
    ld a, (global_.blocking_inits.4.info)
    ldi (hl), a ; 1 hp
    ld a, 16
    ldi (hl), a ; y = 16
    ld a, 160-8
    ldi (hl), a ; x = 160-8


; load simple_room
	ld de, basic_room
	ld a, d
	ld (load_map_.map_address), a
	ld a, e
	ld (load_map_.map_address + 1), a
	call load_map