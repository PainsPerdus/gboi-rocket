# Handle the collisions with monsters.

## Description

Deals with the collisions between Isaac and the enemies. Isaac has a recovery timer that prevent him from being hit during a short time. 

## Pseudo Code

~~~C

if (!isaac.recover) {
    for (c=0, c<n_enemies, c++) {
      if (!elements.alive)
        continue;

      collision_.p.2.x = enemies[c].x
      collision_.p.2.y = enemies[c].y
      collision_.hitbox2 = enemies[c].info and ENEMY_SIZE_MASK
      a = collision()
      if (a){
          isaac.recover = RECOVERY_TIME
          isaac.hp -= enemies[c].dmg and DMG_MASK
          if (isaac.hp < 0)
            // isaac dies
          break;
      }
    }
} else
    isaac.recover -= 1;

~~~
