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
| tears | 1 byte | 3 bits for horizontal speed of tears (pos 5:3), 3 bits for vertical speed (pos 2:0), 1 flag for "A was pressed the frame before" in postion (pos 7), 1 flag for "B  was pressed" (pos 6)|
| recover | 1 byte | recovery time |
| bombs | 1 byte | number of bombs Isaac has |
| direction | 1 byte | 2 bits indicate Isaac's direction (00 = up, 11 = down, 10 = right, 01 = left) (pos 1:0), 6 other bits are free |

## Blocking

Content of the struct "blocking" :

| Label | Size/Struct | Description |
| ----- | ---- | ----------- |
| info | 1 byte | 1 flag "the element is alive" (pos 7), 1 flag "can be destroyed by bombs" (pos 6), 3 bits for ID (pos 5:3), 3 bits for size (pos 2:0) |
| x | 1 byte | position of the element |
| y | 1 byte | position of the element |

## Blocking Init

Content of the struct "blocking_init" :

| Label | Size | Description |
| ----- | ---- | ----------- |
| info | 1 byte | 1 flag "the element is alive" (pos 7), 1 flag "can be destroyed by bombs" (pos 6), 3 bits for ID (pos 5:3), 3 bits for size (pos 2:0) |

## Enemy

Content of struct "enemy" :

| Label | Size | Description |
| ----- | ---- | ----------- |
| info | 1 byte | 1 flag "alive" (pos 7), 4 bits for ID (pos 6:3), 3 bit for the size (pos 2:0) |
| x | 1 byte | position of the enemy |
| y | 1 byte | position of the enemy |
| hp | 1 byte | health of the enemy |
| speed | 1 byte | 4 bits for x speed (pos 7:4), 4 bits for y speed (pos 3:0) |
| dmg | 1 byte | 1 flag "the enemy can shoot bullets" (pos 7), 7 bits for the amount of dmg (pos 6:0) |

## Enemy Init

Content of struct "enemy_init"

| Label | Size | Description |
| ----- | ---- | ----------- |
| info | 1 byte | 1 flag "alive" (pos 7), 4 bits for ID (pos 6:3), 3 bit for the size (pos 2:0) |
| hp | 1 byte | health of the enemy |
| dmg | 1 byte | 1 flag "the enemy can shoot bullets" (pos 7), 7 bits for the amount of dmg (pos 6:0) |

## Object

Content of struct "object" :

| Label | Size | Description |
| ----- | ---- | ----------- |
| info | 1 byte | 1 flag "alive" (pos 7), 5 bits for ID (pos 6:2), 2 bits for size (pos 1:0) |
| x | 1 byte | position of the object |
| y | 1 byte | position of the object |
| funtion | 2 bytes | address to the effect function |

## Object Init

Content of struct "object_init" :

| Label | Size | Description |
| ----- | ---- | ----------- |
| info | 1 byte | 1 flag "alive" (pos 7), 5 bits for ID (pos 6:2), 2 bits for size (pos 1:0) |
| funtion | 2 bytes | address to the effect function |

## Tear

Content of struct "tear" :

| Label | Size | Description |
| ----- | ---- | ----------- |
| y | 1 byte | position of the tear |
| x | 1 byte | position of the tear |
| id | 1 byte | 1 flag for "does it need to be recycled" (pos 7), 1 flag for "is it in the recycling chain" (pos 6), 1 flag for "is it the first in the recycling chain" (pos 5), 5 bits for OAM ID (pos 4:0) |
| speed | 1 byte | 4 bits for x speed (pos 7:4) and 4 bits for (pos 3:0) |

# Defines

| Label | Value | Description |
| ----- | ----- | ----------- |
| n_blockings | 14 | number of elements in the array `global_.blockings` |
| n_enemies | 10 | number of enemies in the array `global_.enemies` |
| n_objects | 10 | number of objects in the array `global_.objects` |
| n_isaac_tears | 10 | number max of issac'stears |
| n_ennemy_tears | 10 | number max of ennemy's tears |

Moreover, flag bits, masks and right shifts to apply to extract an info are given by the values : 
ALIVE_FLAG, BOMB_FLAG
BLOCKING_ID_MASK, BLOCKING_ID_RIGHT_SHIFT
ENEMY_ID_MASK, ENEMY_ID_RIGHT_SHIFT
OBJECT_ID_MASK, OBJECT_ID_RIGHT_SHIFT
BLOCKING_SIZE_MASK, ENEMY_SIZE_MASK, OBJECT_SIZE_MASK
SHOOT_FLAG, DMG_MASK

# Global reserved memory:


| Label | Size/Struct |  Description  |
| ------------- | ---------- | ----------- |
| global_.blockings[n_blockings] | blocking * n_blockings | Blocking elements in the room |
| gobal_.isaac | isaac | Isaac, the main caracter. |
| global_.enemies[n_enemies]    | enemy * n_enemies | Enemies in the room |
| global_.issac_tear_pointer | 1 byte | Index of next tear to generate |
| global_.isaac_tears[n_isaac_tears] | tear * n_isaac_tears  | tears of isaac |
| global_.ennemy_tear_pointer | 1 byte | Index of next tear to generate |
| global_.ennemy_tears[n_ennemy_tears]| tear * n_ennemy_tears | tears of the ennemys |
| global_.objects[n_objects] | object * n_objects | Objects in the room |
| global_.blocking_inits[8] | blocking_init * 8 | Initial values of blocking elements |
| global_.enemy_inits[16] | enemy_init * 16 | Initial values of enemies |
| global_.object_inits[32] | object_init * 32 | Initial values of objects |
| global_.speeds[n_enemies] | n_enemies | max speed of the enemies |

# Note

As objects have fewer bits to define their sizes, hitbox arrays should begin with the size of objects.

# TODO:
    define size tables