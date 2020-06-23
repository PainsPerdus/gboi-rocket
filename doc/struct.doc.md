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
| speed | 1 byte | Isaac speed (split in 2 x 4bits, x speed and y speed) |
| tears | 1 byte | 3 bits for horizontal speed of tears, 3 bits for vertical speed, 1 flag for "A was pressed the frame before", 1 flag for "B  was pressed" |

## Element

Content of the struct "element" :

| Label | Size | Description |
| ----- | ---- | ----------- |
| x | 1 byte | position of the element |
| y | 1 byte | position of the element |
| sheet | 1 byte | address to the corresponding generic sheet for the element (relative, first sheet will have address $00) |
| state | 2 bytes | address to the state of the element |

## Sheet

Content of struct "sheet" :

| Label | Size | Description |
| ----- | ---- | ----------- |
| size | 1 byte | 3 bit for the size (index in a table to be defined), 5 flags (blocks, hurts, reacts to touch, can be hurt by bombs, can be hurt by Isaac's tears) |
| function | 2 bytes | address to the AI function for ennemies or the function triggered when touched |

## State

Content of struct "state" :

| Label | Size | Description |
| ----- | ---- | ----------- |
| hp | 1 byte | the element's health |
| | | this struct is almost empty, it is kept for later improvement (ex : content needed for the ennemie's AI) |