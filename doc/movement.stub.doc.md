# Stub for movements

## Description

A temporary code to implement Isaac's movement and collisions

## Pseudo Code

~~~C
isaac.y = isaac.y + isaac.speed.y

b = 0

collision_.p.1.x = isaac.x
collision_.p.1.y = isaac.y
collision_.hitbox1 = ISAACHITBOX

for (c=0, c<n_elements, c++) {
    collision_.p.2.x = elements[c].x
    collision_.p.2.y = elements[c].y
    collision_.hitbox2 = (*elements[c].sheet).size and 0b00000111
    a = collision()
    if (!a)
        b = 0b01000000
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
        b = b or 0b10000000
}

if (b)
    collisionSolver(b, sheets[0])

~~~