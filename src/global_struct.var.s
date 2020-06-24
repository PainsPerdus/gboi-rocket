.STRUCT isaac_var
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
.ENDST

.STRUCT element_var
	x DB
	y DB
	speed DB
	sheet DB
	state DW
.ENDST

.STRUCT sheet_var
	size DB
	dmg DB
	function DW
.ENDST

.STRUCT state_var
	hp DB
.ENDST

.STRUCT tear_var
	x DB
	y DB
	direction DB
.ENDST