.DEFINE n_elements $0A
.DEFINE n_sheets $02
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
