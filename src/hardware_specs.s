.ROMDMG ;This is a Gameboy ROM
.NAME "PONGDEMO" ;ROM name (11 char max)
.CARTRIDGETYPE 0 ;Normal cartridge with 32ko of ROM
.RAMSIZE 0 ;No save RAM (0ko)
.COMPUTEGBCHECKSUM ;Won't boot without it
.COMPUTEGBCOMPLEMENTCHECK ;Won't boot without it
.LICENSEECODENEW "00" ;Dev license number (we don't have any)
.EMPTYFILL $00 ;Fill unused ROM space with 0


.MEMORYMAP ;We have two slots of 16ko, total 32ko
SLOTSIZE $4000
DEFAULTSLOT 0
SLOT 0 $0000
SLOT 1 $4000
.ENDME

.ROMBANKSIZE $4000
.ROMBANKS 2
.BANK 0 SLOT 0 ;Default slot at slot 0 (first 16 ko of ROM)
