
.DEFINE VRAM   $8000 ; Vidéo RAM start address (tile data + other video related things)
.DEFINE WRAM   $C000 ; Work RAM start address (basically a manually managed heap)
.DEFINE ERAM   $E000 ; Echo RAM start address (using this memory range basically equates to using WRAM)
.DEFINE OAM    $FE00 ; Object Attribute Memory (VRAM for sprite definitions)
.DEFINE IOREGS $FF00 ; Memory mapped registers for the GPU, APU (audio), Joypad, etc ...
.DEFINE HRAM   $FF80 ; High RAM start address (stack should start at the TOP of the HRAM as it is descending) basically for stack
.DEFINE INTMSK $FFFF ; Interrupt mask register

.DEFINE STACK_START $FFF4 ; Advised stack start address

; LCD control registers

.DEFINE LCD_CONTROL_LOW $40 ; LCD control register address low byte
.DEFINE LCD_CONTROL IOREGS+LCD_CONTROL_LOW ; full address

.DEFINE LCD_STATUS_LOW $41 ; LCD status register address low byte
.DEFINE LCD_STATUS IOREGS+LCD_STATUS_LOW ; full address

.DEFINE LCDC LCD_CONTROL ; For Pandoc search and use
.DEFINE STAT LCD_STATUS

; Background scroll registers

.DEFINE LCD_SCR_BG_Y_LOW $42 ; LCD scroll background Y register address low byte
.DEFINE LCD_SCR_BG_Y IOREGS+LCD_SCR_BG_Y_LOW ; full address

.DEFINE LCD_SCR_BG_X_LOW $43 ; LCD scroll background X register address low byte
.DEFINE LCD_SCR_BG_X IOREGS+LCD_SCR_BG_X_LOW ; full address

.DEFINE SCY LCD_SCR_BG_Y ; For Pandoc search and use
.DEFINE SCX LCD_SCR_BG_X

; Scanline registers

.DEFINE LCD_SCANL_Y_RO_LOW $44 ; LCD current scanline Y read-only register (LY) address low byte
.DEFINE LCD_SCANL_Y_RO IOREGS+LCD_SCANL_Y_RO_LOW ; full address

.DEFINE LCD_SCANL_Y_CMP_LOW $45 ; LCD target scanline Y for compare register (LYC) address low byte
.DEFINE LCD_SCANL_Y_CMP IOREGS+LCD_SCANL_Y_CMP_LOW ; full address

.DEFINE LY LCD_SCANL_Y_RO ; For Pandoc search and use
.DEFINE LYC LCD_SCANL_Y_CMP

; Window scroll registers

.DEFINE LCD_SCR_WIN_Y_LOW $4A ; LCD scroll window Y register address low byte
.DEFINE LCD_SCR_WIN_Y IOREGS+LCD_SCR_WIN_Y_LOW ; full address

.DEFINE LCD_SCR_WIN_X_LOW $4B ; LCD scroll window X register address low byte
.DEFINE LCD_SCR_WIN_X IOREGS+LCD_SCR_WIN_X_LOW ; full address

.DEFINE WY LCD_SCR_WIN_Y ; For Pandoc search and use
.DEFINE WX LCD_SCR_WIN_X

; Palette registers

.DEFINE LCD_PALETTE_BG_LOW $47 ; LCD background palette register address low byte
.DEFINE LCD_PALETTE_BG IOREGS+LCD_PALETTE_BG_LOW ; full address

.DEFINE LCD_PALETTE_OBJ0_LOW $48 ; LCD background palette register address low byte
.DEFINE LCD_PALETTE_OBJ0 IOREGS+LCD_PALETTE_OBJ0_LOW ; full address

.DEFINE LCD_PALETTE_OBJ1_LOW $49 ; LCD background palette register address low byte
.DEFINE LCD_PALETTE_OBJ1 IOREGS+LCD_PALETTE_OBJ1_LOW ; full address

.DEFINE BGP LCD_PALETTE_BG ; For Pandoc search and use
.DEFINE OBP0 LCD_PALETTE_OBJ0
.DEFINE OBP1 LCD_PALETTE_OBJ1

; DMA register

.DEFINE DMA_OAM_LOW $46 ; DMA request register address low byte
.DEFINE DMA_OAM IOREGS+DMA_OAM_LOW ; full address

.DEFINE DMA DMA_OAM ; For Pandoc search and use

; Tile banks

.DEFINE VRAM_TILE_BANK1 $8000 ; 1st bank of 128 tiles
.DEFINE VRAM_TILE_BANK2 $8800 ; 2nd bank
.DEFINE VRAM_TILE_BANK3 $9000 ; 3rd bank

; Tile maps

.DEFINE VRAM_TILE_MAP1 $9800 ; 1st tile map
.DEFINE VRAM_TILE_MAP2 $9C00 ; 2nd tile map

; Sound registers

; Channel 1

.DEFINE SND_CHAN1_SWEEP_LOW $10 ; Sound channel1 sweep register address low byte
.DEFINE SND_CHAN1_SWEEP IOREGS+SND_CHAN1_SWEEP_LOW ; full address

.DEFINE SND_CHAN1_LEN_DUTY_LOW $11 ; Sound channel1 length and duty cycle register address low byte
.DEFINE SND_CHAN1_LEN_DUTY IOREGS+SND_CHAN1_LEN_DUTY_LOW ; full address

.DEFINE SND_CHAN1_VOL_ENVEL_LOW $12 ; Sound channel1 volume envelope register address low byte
.DEFINE SND_CHAN1_VOL_ENVEL IOREGS+SND_CHAN1_VOL_ENVEL_LOW ; full address

.DEFINE SND_CHAN1_FREQ_LO_LOW $13 ; Sound channel1 frequency lower 8 bits register address low byte
.DEFINE SND_CHAN1_FREQ_LO IOREGS+SND_CHAN1_FREQ_LO_LOW ; full address

.DEFINE SND_CHAN1_FREQ_HI_FLAGS_LOW $14 ; Sound channel1 frequency higher 3 bits register plus control address low byte
.DEFINE SND_CHAN1_FREQ_HI_FLAGS IOREGS+SND_CHAN1_FREQ_HI_FLAGS_LOW ; full address

.DEFINE NR10 SND_CHAN1_SWEEP ; For Pandoc search and use
.DEFINE NR11 SND_CHAN1_LEN_DUTY
.DEFINE NR12 SND_CHAN1_VOL_ENVEL
.DEFINE NR13 SND_CHAN1_FREQ_LO
.DEFINE NR14 SND_CHAN1_FREQ_HI_FLAGS

; Channel 2

.DEFINE SND_CHAN2_LEN_DUTY_LOW $16 ; Sound channel2 length and duty cycle register address low byte
.DEFINE SND_CHAN2_LEN_DUTY IOREGS+SND_CHAN2_LEN_DUTY_LOW ; full address

.DEFINE SND_CHAN2_VOL_ENVEL_LOW $17 ; Sound channel2 volume envelope register address low byte
.DEFINE SND_CHAN2_VOL_ENVEL IOREGS+SND_CHAN2_VOL_ENVEL_LOW ; full address

.DEFINE SND_CHAN2_FREQ_LO_LOW $18 ; Sound channel2 frequency lower 8 bits register address low byte
.DEFINE SND_CHAN2_FREQ_LO IOREGS+SND_CHAN2_FREQ_LO_LOW ; full address

.DEFINE SND_CHAN2_FREQ_HI_FLAGS_LOW $19 ; Sound channel2 frequency higher 3 bits register plus control address low byte
.DEFINE SND_CHAN2_FREQ_HI_FLAGS IOREGS+SND_CHAN2_FREQ_HI_FLAGS_LOW ; full address

.DEFINE NR21 SND_CHAN2_LEN_DUTY ; For Pandoc search and use
.DEFINE NR22 SND_CHAN2_VOL_ENVEL
.DEFINE NR23 SND_CHAN2_FREQ_LO
.DEFINE NR24 SND_CHAN2_FREQ_HI_FLAGS