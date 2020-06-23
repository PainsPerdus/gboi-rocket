.INCLUDE "../GBDefs/defs.s"
.INCLUDE "hardware_specs.s"
.INCLUDE "memory_map.s"

.INCLUDE "init.s"
loop:
	jr loop

/* Module includes */
.INCLUDE "graphics.s"

VBlank: //On VBlank interupt
	push af
	push hl
	call Graphics
	pop hl
	pop af
	ret

