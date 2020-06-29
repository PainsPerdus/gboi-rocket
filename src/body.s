.INCLUDE "check_inputs.s"
.INCLUDE "movement_and_collide.s"
call rng


ld a, (global_.enemies.2.x)
add 2
ld (global_.enemies.2.x), a

ld a, (global_.enemies.3.x)
sub 1
ld (global_.enemies.3.x), a

ld a, (global_.enemies.4.x)
add 1
ld (global_.enemies.4.x), a
ld a, (global_.enemies.4.y)
sub 1
ld (global_.enemies.4.y), a

ld a, (global_.enemies.5.x)
sub 2
ld (global_.enemies.5.x), a
ld a, (global_.enemies.5.y)
add 2
ld (global_.enemies.5.y), a
