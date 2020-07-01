# Display structs:


## isaac_display

| Label       | Size/Struct | Description                                                      |
| ----------- | ----------- | ---------------------------------------------------------------- |
| frame       | 1 byte      | Animation frame number                                           |
| shoot_timer | 1 byte      | Number of game frames before the end of shooting animation       |
| walk_timer  | 1 byte      | Number of game frames before the next frame of walking animation |

## hblank_preloaded_opcode

| Label  | Size/Struct | Description |
| ------ | ----------- | ----------- |
| OAM_CACHE_START | 2 bytes | Cache of the OAM for DMA |
| HRAM_DMA_PROCEDURE | 2 bytes | Place in HRAM where DMA procedure will be copied |

# Display vars

| Label          | Size/Struct | Description                  |
| -------------- | ----------- | ---------------------------- |
| display_.isaac | isaac       | Isaac's animation properties |

# Display Constants
| Label          | Size        | Description |
| -------------- | ----------- | ----------- |
| OAM_ISAAC      | 2 bytes     | Address of Isaac's sprites in OAM |
| OAM_ISAAC_SIZE | 1 byte      | Number of sprites for Isaac in OAM |
| OAM_ISAAC_BULLETS | 2 bytes | Address of Isaac's bullets pool in the OAM |
| OAM_ISAAC_BULLETS_SIZE | 1 byte | Number of sprites for the ennemies bullets in the OAM |
| OAM_ENNEMY_BULLETS | 2 bytes | Address of Isaac's bullets pool in the OAM |
| OAM_ENNEMY_BULLETS_SIZE | 1 byte | Number of sprites for the ennemis bullets in the OAM |


