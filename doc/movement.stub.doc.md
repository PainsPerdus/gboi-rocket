# Stub for movements

## Description

A temporary code to implement Isaac's movement and collisions

## Struct used

### reserved memory

| Label | Size/Struct | Description |
| ----- | ---- | ----------- |
| next_coll | 2 bytes | address of the next position to read in the collisions array |
| collisions | n_elements * 1 byte | for each element the b argument for the collisionSolverIsaac function |

### global structs

#### Isaac

| Label | Size/Struct | Description |
| ----- | ---- | ----------- |
| x | 1 byte | abscissa of Isaac |
| y | 1 byte | ordinate of Isaac |
| speed | 1 byte | Isaac speed (split in 2 x 4bits, x speed (pos 7:4) and y speed (pos 3:0)) |

#### Element

| Label | Size/Struct | Description |
| ----- | ---- | ----------- |
| x | 1 byte | position of the element |
| y | 1 byte | position of the element |
| speed | 1 byte | Element's speed (split in 2 x 4bits, x speed (pos 7:4) and y speed (pos 3:0)) |
| sheet | 1 byte | second byte of the address of the element's description sheet. (the first can be retrieved with the first byte of gobal_.sheets ) |
| hp | 1 byte | the element's health |
| state | 2 bytes | address to the state of the element |

#### Sheet

| Label | Size | Description |
| ----- | ---- | ----------- |
| size | 1 byte | 3 bit for the size (index in a table to be defined) (pos 2:0), 5 flags (blocks (pos 7), hurts (pos 6), reacts to touch (pos 5), can be hurt by bombs (pos 4), can be hurt by Isaac's tears (pos 3)) |

#### Defines

| Label | Value | Description |
| ----- | ----- | ----------- |
| n_elements | 10 | number of element in the array `global_.element` |

#### Global reserved memory:

| Label | Size/Struct |  Description  |
| ------------- | ---------- | ----------- |
| global_.sheets[n_sheets]         | sheet * n_sheets   | Element sheets.           |
| gobal_.isaac                   | isaac               | Isaac, the main caracter. |
| global_.elements[n_elements]    | element * n_elements | Elements in the room, except for tears and isaac. |

### from collision

#### point

| Label | Size |  Description  |
| ------------- | ---------- | ----------- |
| x | 1 byte | abscissa of the point |
| y | 1 byte | ordinate of the point |

#### Reserved memory:

| Label | Size/Struct |  Description  |
| ------------- | ---------- | ----------- |
| collision_.p.1 | point | Left Top corner of the first element checked |
| collision_.p.2 | point | Left Top corner of the second element checked |
| collision_.hitbox1| 1 bytes| Id of the hitbox of the first element checked |
| collision_.hitbox2| 1 bytes| Id of the hitbox of the second element checked |

## Pseudo Code

~~~C
isaac.y = isaac.y + isaac.speed.y

b = 0

collision_.p.1.x = isaac.x
collision_.p.1.y = isaac.y
collision_.hitbox1 = ISAACHITBOX

for (c=0, c<n_elements, c++) {
    movement_stub_.collisions[c] = 0
    collision_.p.2.x = elements[c].x
    collision_.p.2.y = elements[c].y
    collision_.hitbox2 = (*elements[c].sheet).size and 0b00000111
    a = collision()
    if (!a)
        movement_stub_.collisions[c] = movement_stub_.collisions or 0b01000000
}

isaac.x = isaac.x + isaac.speed.x

collision_.p.1.x = isaac.x
collision_.p.1.y = isaac.y
collision_.hitbox1 = ISAACHITBOX

for (c=0, c<n_elements, c++) {
    collision_.p.2.x = elements[c].x
    collision_.p.2.y = elements[c].y
    collision_.hitbox2 = (*elements[c].sheet).size and 0b00000111
    a = collision()
    if (!a)
        movement_stub_.collisions[c] = movement_stub_.collisions[c] or 0b10000000
}

for (c=0, c<n_elements, c++) {
    if (movement_stub_.collisions[c])
        collisionSolver(movement_stub_.collisions[c], elements[c].sheet)
}
~~~

## NOTE

* introduces a slight glitch : when Isaac goes to an angle, he is pushed away a few pixels too far

## TODO

* correct the glitch above