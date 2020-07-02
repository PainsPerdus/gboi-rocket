# start_dma_in_ROM

This contains the code to launch the Direct Memory Access to copy the shadow OAM into OAM. 
This will be copied in HRAM (ROM cannot be accessed during DMA) and launched during HBlank.

Please never call this procedure as it is.
