.DEFINE OAM_ISAAC $FE00
.DEFINE OAM_ISAAC_SIZE 4

.DEFINE OAM_ISAAC_TEARS OAM_ISAAC+OAM_ISAAC_SIZE*4
.DEFINE OAM_ISAAC_TEARS_SIZE 5
.DEFINE OAM_ENNEMY_TEARS OAM_ISAAC_TEARS+OAM_ISAAC_TEARS_SIZE*4
.DEFINE OAM_ENNEMY_TEARS_SIZE 5

.DEFINE OAM_ENNEMIES OAM_ENNEMY_TEARS + OAM_ENNEMY_TEARS_SIZE*4

.DEFINE BACKGROUND_HEARTS_POS

// Setup stuff for DMA
.DEFINE SHADOW_OAM_START $C000

.DEFINE HRAM_DMA_PROCEDURE $FF80

.DEFINE DMA_PROCEDURE_SIZE 10



.STRUCT isaac_display
	frame DB
	shoot_timer DB
	walk_timer DB
.ENDST

.STRUCT fly_display
	frame DB
.ENDST

.STRUCT display_var
	isaac INSTANCEOF isaac_display
	fly INSTANCEOF fly_display
.ENDST


