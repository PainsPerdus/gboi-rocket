.NINTENDOLOGO ;put nitendo logo in memory at the right spot

 ;$C000 is the start of the RAM
.ENUM $C000 ;Declare variables
.DB posX //X Position of Isaac
.DB posY //Y Posiiton of Isaac
.ENDE




.ORG $800
Tiles:
.INCLUDE "back.sprite"
.INCLUDE "isaac.sprite"
