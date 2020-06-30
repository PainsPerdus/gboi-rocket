# Move Isaac

## Description

  Move Isaac and deals with collisions.

  Isaac only move once in a while (it easier to deal with the speed this way). It the lagCounter is null, we move isaac, else we skip the movement and reset the lagCounter to the speedFreq value.

## Pseudo Code

~~~C

isaac.lagCounter --;
  if (!isaac.lagCounter){
    isaac.lagCounter = isaac.speedFreq
    if (isaac.speed.x != 0 and isaac.speed.y != 0)
      isaac.lagCounter += int(isaac.speedFreq/2 +0.5);

   //////// MOVE ISAAC  Y \\\\\\\
  isaac.y += isaac.speed.y

  collision_.p.1.x = isaac.x
  collision_.p.1.y = isaac.y
  collision_.hitbox1 = ISAAC_HITBOX
  a = collision_with_obstacle()
  if (!a){
      isaac.y -= isaac.speed.y
      collision_.p.1.y = isaac.y
      isaac.speed.y = 0
  }
  // \\\\ collision X  loop ////

  // \\\\\\\ MOVE ISAAC  X ////////

  //////// MOVE ISAAC  X \\\\\\\
  isaac.x += isaac.speed.x

  collision_.p.1.x = isaac.x
  a = collision_with_obstacle()
  if (!a){
     isaac.x -= isaac.speed.x
     collision_.p.1.x = isaac.x
     isaac.speed.x = 0
  }
  // \\\\\\\ MOVE ISAAC  X ////////
}else{
  isaac.speed = 0; // Avoid gltychy behaviour with display
}
~~~
