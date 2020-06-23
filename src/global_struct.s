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
.ENDST

.STRUCT element
	x DB
	y DB
	sheet DB
	state DW
.ENDST

.STRUCT sheet
	size DB
	dmg DB
	function DW
.ENDST

.STRUCT state
	hp DB
.ENDST