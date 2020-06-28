.DEFINE n_blockings $0E
.DEFINE n_enemies $0A
.DEFINE n_objects $0A
.DEFINE n_isaac_tears $0A
.DEFINE n_ennemy_tears $0A

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
	x DB
	y DB
.ENDST

.STRUCT blocking_init
	info DB
.ENDST

.STRUCT enemy
	info DB
	x DB
	y DB
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
	x DB
	y DB
	function DW
.ENDST

.STRUCT object_init
	info DB
	function DW
.ENDST

.STRUCT tear
	x DB
	y DB
	direction DB
.ENDST

.STRUCT global_var
	blockings INSTANCEOF blocking n_blockings
	isaac INSTANCEOF isaac
	enemies INSTANCEOF enemy n_enemies
	issac_tear_pointer DB
	isaac_tears INSTANCEOF tear n_isaac_tears
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
