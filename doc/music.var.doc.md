# Music state struct content

|       name          | size | content                                                         |
|---------------------|------|-----------------------------------------------------------------|
| rest1               | 0x2  | the number of ticks (1/4096 s) until next note for channel 1    |
| curs1               | 0x2  | the address of current note for channel 1                       |
| max1                | 0x2  | the boundary address of the track for channel 1                 |
| scale1              | 0x2  | pointer to the scale array of channel 1 as described in wiki    |
| timing1             | 0x2  | pointer to the timing array of channel 1                        |
| rest2               | 0x2  | the number of ticks (1/4096 s) until next note for channel 2    |
| curs2               | 0x2  | the address of current note for channel 2                       |
| max2                | 0x2  | the boundary address of the track for channel 2                 |
| scale2              | 0x2  | pointer to the scale array of channel 2 as described in wiki    |
| timing2             | 0x2  | pointer to the timing array of channel 2                        | 
| part                | 0x1  | selects the part number in the file (groups of 2 tracks)        |

the funtion music_start initializes all of those values for the music pointed at by HL.