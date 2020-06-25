.STRUCT isaac_display
	frame DB
	shoot_timer DB
	walk_timer DB
.ENDST

.STRUCT display_var
	isaac INSTANCEOF isaac_display
.ENDST
