.DEFINE MASK_4_LSB %00001111
.DEFINE MASK_2_LSB %00000011
.DEFINE MASK_6_MSB %11111100

.DEFINE VALUE_4LSB_1 %00000001
.DEFINE VALUE_4LSB_minus_1 %00001111
.DEFINE VALUE_4MSB_1 %00010000
.DEFINE VALUE_4MSB_minus_1 %11110000

.DEFINE ORIENTATION_UP %00000000
.DEFINE ORIENTATION_DW %00000011
.DEFINE ORIENTATION_LF %00000010
.DEFINE ORIENTATION_RG %00000001

.DEFINE ISAAC_A_FLAG $7
.DEFINE ISAAC_B_FLAG $6

.DEFINE n_blockings $20
.DEFINE n_enemies $0A
.DEFINE n_objects $0A
.DEFINE n_isaac_tears $0A
.DEFINE n_ennemy_tears $0A

.DEFINE ALIVE_FLAG 7
.DEFINE BOMB_FLAG 6
.DEFINE BLOCKING_ID_MASK %00111000
.DEFINE BLOCKING_ID_RIGHT_SHIFT 3
.DEFINE ENEMY_ID_MASK %01111000
.DEFINE ENEMY_ID_RIGHT_SHIFT 3
.DEFINE OBJECT_ID_MASK %01111100
.DEFINE OBJECT_ID_RIGHT_SHIFT 2
.DEFINE BLOCKING_SIZE_MASK %00000111
.DEFINE ENEMY_SIZE_MASK %00000111
.DEFINE OBJECT_SIZE_MASK %00000011
.DEFINE SHOOT_FLAG 7
.DEFINE DMG_MASK %01111111

.DEFINE ISAAC_MAX_HP 16
.DEFINE ISAAC_HITBOX 1
.DEFINE ISAAC_FEET_HITBOX 2
.DEFINE RECOVERY_TIME 30

.DEFINE 8_8_HB 0
.DEFINE 16_16_HB 1
.DEFINE 16_8_HB 2
.DEFINE 8_16_HB 3
.DEFINE H_WALL_HB 6
.DEFINE V_WALL_HB 7

.DEFINE ROCK_INFO %11000001 ; alive, hurt by bombs, ID 0, size 1
.DEFINE VOID_INFO %00001000	; not alive, not hurt by bombs, ID 1; size 0
.DEFINE HWALL_INFO %10010110 ; alive, not hurt by bombs, ID 2, size 6
.DEFINE VWALL_INFO %10011111 ; alive, not hurt by bombs, ID 3, size 7
.DEFINE PIT_INFO %10100001 ; alive, not hurt by bombs, ID 4, size 1

.DEFINE VOID_ENEMY_INFO %00000000 ; not alive, ID 0, size 0
.DEFINE VOID_ENEMY_HP $00
.DEFINE VOID_ENEMY_DMG $00
.DEFINE VOID_ENEMY_SPEED_FREQ $00

.DEFINE HURTING_ROCK_INFO %10001001 ; alive, ID 1, size 1
.DEFINE HURTING_ROCK_HP $01
.DEFINE HURTING_ROCK_DMG $02
.DEFINE HURTING_ROCK_SPEED_FREQ $00

.DEFINE FLY_INFO %10010000 ; alive, ID 2, size 0
.DEFINE FLY_HP $01
.DEFINE FLY_DMG $01
.DEFINE FLY_SPEED_FREQ $03

.DEFINE VOID_OBJECT_INFO %00000000 ; not alive, ID 0, size 0
.DEFINE HDOOR_INFO %00000110 ; alive, ID 1, size 2
.DEFINE VDOOR_INFO %00001011 ; alive, ID 2, size 3

.STRUCT isaac
	x DB
	y DB
	hp DB
	dmg DB
	upgrades DW
	range DB
	speed DB
	tears DB
	recover DB
	bombs DB
	direction DB
	lagCounter DB
	speedFreq DB
.ENDST

.STRUCT blocking
	info DB
	y DB
	x DB
.ENDST

.STRUCT blocking_init
	info DB
.ENDST

.STRUCT enemy
	info DB
	y DB
	x DB
	hp DB
	speed DB
	dmg DB
	lagCounter DB
	speedFreq DB
.ENDST

.STRUCT enemy_init
	info DB
	hp DB
	dmg DB
	speedFreq DB
.ENDST

.STRUCT object
	info DB
	y DB
	x DB
	function DW
.ENDST

.STRUCT object_init
	info DB
	function DW
.ENDST

.STRUCT tear
	x DB
	y DB
	id DB
	speed DB
	ttl DB
.ENDST

.STRUCT global_var
	blockings INSTANCEOF blocking n_blockings
	enemies INSTANCEOF enemy n_enemies
	isaac_tears INSTANCEOF tear n_isaac_tears
	ennemy_tears INSTANCEOF tear n_ennemy_tears
	objects INSTANCEOF object n_objects
	hitboxes_width DSB 8
 	hitboxes_height DSB 8
	blocking_inits INSTANCEOF blocking_init 8
	enemy_inits INSTANCEOF enemy_init 16
	object_inits INSTANCEOF object_init 32
	isaac INSTANCEOF isaac
	issac_tear_pointer DB
	ennemy_tear_pointer DB
.ENDST
