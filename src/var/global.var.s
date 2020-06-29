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

.DEFINE n_elements $0E
.DEFINE n_sheets $04
.DEFINE n_states $0A
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

.STRUCT element
	hp DB
	x DB
	y DB
	sheet DB
	speed DB
	state DW
.ENDST

.STRUCT sheet
	size DB
	dmg DB
	function DW
	speed DB
	hp DB
.ENDST

.STRUCT state
	empty DB
.ENDST

.STRUCT tear
	x DB
	y DB
	direction DB
.ENDST

.STRUCT global_var
	sheets INSTANCEOF sheet n_sheets
	isaac INSTANCEOF isaac
	elements INSTANCEOF element n_elements
	issac_tear_pointer DB
	isaac_tears INSTANCEOF tear n_isaac_tears
	ennemy_tear_pointer DB
	ennemy_tears INSTANCEOF tear n_ennemy_tears
	states INSTANCEOF state n_states
	hitboxes_width DSB 4
 	hitboxes_height DSB 4
.ENDST
