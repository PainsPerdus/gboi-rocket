# Stub for movements

## Description

## Struct used

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
| hp | 1 byte | the element's health |
| x | 1 byte | position of the element |
| y | 1 byte | position of the element |
| speed | 1 byte | Element's speed (split in 2 x 4bits, x speed (pos 7:4) and y speed (pos 3:0)) |
| sheet | 1 byte | second byte of the address of the element's description sheet. (the first can be retrieved with the first byte of gobal_.sheets ) |
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

 //////// MOVE ISAAC  Y \\\\\\\

isaac.y += isaac.speed.y

   //// collision Y  init \\\\
collision_.p.1.x = isaac.x
collision_.p.1.y = isaac.y
collision_.hitbox1 = ISAAC_HITBOX
// \\\\ collision Y  init ////

   //// collision Y  loop \\\\
for (c=0, c<n_elements, c++) {
  if !(elements[c].hp)
    continue;
  collision_.p.2.x = elements[c].x
  collision_.p.2.y = elements[c].y
  if !(block(elements[c].sheet)
    continue;
  collision_.hitbox2 = (*elements[c].sheet).size and 0b00000111
  if (!(*elements[c].sheet).block_flag)
    continue;
  a = collision()
  if (!a){
      isaac.y -= isaac.speed.y
      collision_.p.1.y = isaac.y
      isaac.speed.y = 0
  }
}
// \\\\ collision Y  loop ////

// \\\\\\\ MOVE ISAAC  Y ////////

isaac.x += isaac.speed.x
collision_.p.1.x = isaac.x

for (c=0, c<n_elements, c++) {
  if (!elements.hp)
    continue;

  collision_.p.2.x = elements[c].x
  collision_.p.2.y = elements[c].y
  collision_.hitbox2 = (*elements[c].sheet).size and 0b00000111
  if (!(*elements[c].sheet).block_flag)
    continue;
  a = collision()
  if (!a){
      isaac.x -= isaac.speed.x
      collision_.p.1.x = isaac.x
      isaac.speed.x = 0
  }
}

if (!isaac.recover) {
    for (c=0, c<n_enemies, c++) {
      if (!elements.alive)
        continue;
    
      collision_.p.2.x = enemies[c].x
      collision_.p.2.y = enemies[c].y
      collision_.hitbox2 = enemies[c].info and ENEMY_SIZE_MASK
      a = collision()
      if (!a){
          isaac.recover = RECOVERY_TIME
          isaac.hp -= enemies[c].dmg and DMG_MASK
          if (isaac.hp < 0)
            // isaac dies
          break;
      }
    }
} else
    isaac.recover -= 1

~~~
