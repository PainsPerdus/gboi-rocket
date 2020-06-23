# Description of the structs

## Isaac

Content of the struct "isaac" :

| Label | Size | Description |
| ----- | ---- | ----------- |
| x | 1 byte | abscissa of Isaac |
| y | 1 byte | ordinate of Isaac |
| hp | 1 byte | health point of Isaac |
| dmg | 1 byte | damage dealt by Isaac |
| upgrades | 2 bytes | upgrades earned by Isaac (flags, to be defined) |
| range | 1 byte | range of Isaac's tears |
| speed | 1 byte | Isaac speed (split in 2 x 4bits, use to be precised) |
| tears | 1 byte | 3 bits for horizontal speed of tears, 3 bits for vertical speed, 1 flag for "A was pressed the frame before", 1 flag for "B  was pressed" |

Content of the struct "element" :

| Label | Size | Description |
| ----- | ---- | ----------- |
| x | 1 byte | position of the element |
| y | 1 byte | position of the element |
| sheet | 1 byte | address to the corresponding generic sheet for the element (relative, first sheet will have address $00) |
| state | 2 bytes | address to the state of the element |
