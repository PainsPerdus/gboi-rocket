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
.ENDST

.STRUCT element
	x DB
	y DB
	speed DB
	sheet DB
	state DW
.ENDST

.STRUCT sheet
	size DB
	dmg DB
	function DW
	speed DB
.ENDST

.STRUCT state
	hp DB
.ENDST

.STRUCT tear
	x DB
	y DB
	direction DB
.ENDST

.STRUCT global_var
	void DB ; empty struct are forbidden :(
.ENDST
