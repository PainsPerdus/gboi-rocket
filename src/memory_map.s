.NINTENDOLOGO ;put nitendo logo in memory at the right spot

 ;$C000 is the start of the RAM
.ENUM $C000 ;Declare variables
posX DB //X Position of Isaac
posY DB //Y Posiiton of Isaac
.ENDE




.ORG $800
Tiles:
.INCLUDE "sprites/back.sprite"
.INCLUDE "sprites/isaac.sprite"
.INCLUDE "sprites/test.sprite"
