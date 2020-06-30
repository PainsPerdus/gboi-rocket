.STRUCT RL_blackmagic
	hline DB
	OAM_id DB
	newX DB
	newY DB
.ENDST


.STRUCT blackmagic_var
	OAM_id_counter DB
	source DB
	target DB
	RL INSTANCEOF RL_blackmagic n_isaac_tears*2
.ENDST
