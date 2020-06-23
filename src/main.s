.INCLUDE "../GBDefs/defs.s"
.INCLUDE "hardware_specs.s"
.INCLUDE "memory_map.s"
.INCLUDE "init.s"


main: //Gets called after init

loop: //Main loop
	jp loop

VBlank: //On VBlank interupt
	call Graphics


