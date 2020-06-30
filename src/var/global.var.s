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

.DEFINE n_blockings $0E
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
.ENDST

.STRUCT enemy_init
	info DB
	hp DB
	dmg DB
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
	y DB
	x DB
	id DB
	speed DB
	ttl DB
.ENDST

.STRUCT global_var
	isaac_tears INSTANCEOF tear n_isaac_tears
	blockings INSTANCEOF blocking n_blockings
	isaac INSTANCEOF isaac
	enemies INSTANCEOF enemy n_enemies
	issac_tear_pointer DB
	ennemy_tear_pointer DB
	ennemy_tears INSTANCEOF tear n_ennemy_tears
	objects INSTANCEOF object n_objects
	hitboxes_width DSB 8
 	hitboxes_height DSB 8
	blocking_inits INSTANCEOF blocking_init 8
	enemy_inits INSTANCEOF enemy_init 16
	object_inits INSTANCEOF object_init 32
	speeds DSB n_enemies
.ENDST
