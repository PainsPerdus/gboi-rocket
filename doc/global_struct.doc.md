# Description of the structs

## Isaac

Content of the struct "isaac_var" :

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
| recover | 1 byte | recovery time |
| bombs | 1 byte | number of bombs Isaac has |

## Element

Content of the struct "element_var" :

| Label | Size | Description |
| ----- | ---- | ----------- |
| x | 1 byte | position of the element |
| y | 1 byte | position of the element |
| speed | 1 byte | Element's speed (split in 2 x 4bits, x speed and y speed) |
| sheet | 1 byte | address to the corresponding generic sheet for the element (relative, first sheet will have address $00) |
| state | 2 bytes | address to the state of the element |

## Sheet

Content of struct "sheet_var" :

| Label | Size | Description |
| ----- | ---- | ----------- |
| size | 1 byte | 3 bit for the size (index in a table to be defined), 5 flags (blocks, hurts, reacts to touch, can be hurt by bombs, can be hurt by Isaac's tears) |
| dmg | 1 byte | damage dealt by the ennemy |
| function | 2 bytes | address to the AI function for ennemies or the function triggered when touched |

## State

Content of struct "state_var" :

| Label | Size | Description |
| ----- | ---- | ----------- |
| hp | 1 byte | the element's health |
| | | this struct is almost empty, it is kept for later improvement (ex : content needed for the ennemie's AI) |

## Tear

Content of struct "tear_var" :

| Label | Size | Description |
| ----- | ---- | ----------- |
| x | 1 byte | abscissa of the tear |
| y | 1 byte | ordinate of the tear |
| direction | 1 byte | 2 x 3 bits (x and y) + 1 flag to know if the tear is alive + 1 flag to know if the tear is upgraded |