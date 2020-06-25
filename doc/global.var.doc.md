# Global structs:

## Isaac

Content of the struct "isaac" :

| Label | Size/Struct | Description |
| ----- | ---- | ----------- |
| x | 1 byte | abscissa of Isaac |
| y | 1 byte | ordinate of Isaac |
| hp | 1 byte | health point of Isaac |
| dmg | 1 byte | damage dealt by Isaac |
| upgrades | 2 bytes | upgrades earned by Isaac (flags, to be defined) |
| range | 1 byte | 7 bits for range of Isaac's tears (pos 6:0), 1 flag that tells if a tear was shot during the previous image (pos 7)|
| speed | 1 byte | Isaac speed (split in 2 x 4bits, x speed (pos 7:4) and y speed (pos 3:0)) |
| tears | 1 byte | 3 bits for horizontal speed of tears (pos 5:3), 3 bits for vertical speed (pos 2:0), 1 flag for "A was pressed the frame before" in postion (pos 7), 1 flag for "B  was pressed" (pos 7)|
| recover | 1 byte | recovery time |
| bombs | 1 byte | number of bombs Isaac has |
| direction | 1 byte | 2 bits indicate Isaac's direction (11 = up, 00 = down, 01 = right, 10 = left) (pos 7:6), 6 other bits are free |

## Element

Content of the struct "element" :

| Label | Size/Struct | Description |
| ----- | ---- | ----------- |
| x | 1 byte | position of the element |
| y | 1 byte | position of the element |
| speed | 1 byte | Element's speed (split in 2 x 4bits, x speed (pos 7:4) and y speed (pos 3:0)) |
| sheet | 1 byte | address to the corresponding generic sheet for the element (relative, first sheet will have address $00) |
| hp | 1 byte | the element's health |
| state | 2 bytes | address to the state of the element |

## Sheet

Content of struct "sheet" :

| Label | Size | Description |
| ----- | ---- | ----------- |
| size | 1 byte | 3 bit for the size (index in a table to be defined) (pos 2:0), 5 flags (blocks (pos 7), hurts (pos 6), reacts to touch (pos 5), can be hurt by bombs (pos 4), can be hurt by Isaac's tears (pos 3)) |
| dmg | 1 byte | damage dealt by the ennemy |
| function | 2 bytes | address to the AI function for ennemies or the function triggered when touched |
| speed | 1 byte | max speed for this element |
| hp | 1 byte | max hp for this element |

## State

Content of struct "state" :

| Label | Size | Description |
| ----- | ---- | ----------- |
| empty | | this struct is almost empty, it is kept for later improvement (ex : content needed for the ennemie's AI) |

## Tear

Content of struct "tear" :

| Label | Size | Description |
| ----- | ---- | ----------- |
| x | 1 byte | abscissa of the tear |
| y | 1 byte | ordinate of the tear |
| direction | 1 byte | 2 x 3 bits (x (pos 5:3) and y (pos 2:0)) + 1 flag to know if the tear is alive (pos 7) + 1 flag to know if the tear is upgraded (pos 6)|

# Defines

| Label | Value | Description |
| ----- | ----- | ----------- |
| n_elements | 10 | number of element in the array `global_.element` |
| n_sheets | 1 | number of sheet |
| n_states | 10 | number max of states |
| n_isaac_tears | 10 | number max of issac'stears |
| n_ennemy_tears | 10 | number max of ennemy's tears |

# Global reserved memory:


| Label | Size/Struct |  Description  |
| ------------- | ---------- | ----------- |
| global_.sheets[n_sheets]         | sheet * n_sheets   | Element sheets.           |
| gobal_.isaac                   | isaac               | Isaac, the main caracter. |
| global_.elements[n_elements]    | element * n_elements | Elements in the room, except for tears and isaac. |
| global_.issac_tear_pointer     | 1 byte              | Index of next tear to generate |
| global_.isaac_tears[n_isaac_tears] | tear * n_isaac_tears  | tears of isaac |
| global_.ennemy_tear_pointer     | 1 byte              | Index of next tear to generate |
| global_.ennemy_tears[n_ennemy_tears]| tear * n_ennemy_tears | tears of the ennemys |
| global_.states[n_states]   | state * n_states      | States. |


TODO:
  define size tables.
