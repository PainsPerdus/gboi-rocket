# Play the turn of the enemies

## Description

Call the AI function for all the ennemies

~~~C
for (i=global_.enemies; i++; i<n_enemies)
  AI(i);
  if (! (enemies[i].lagFrame--)){
    enemies[i].lagFrame = enemies[i].speedFreq;
    if (enemies[i].speed.x != 0 and enemies[i].speed.y != 0)
      enemies[i].lagCounter += int(enemies[i].speedFreq/2 +0.5);

    (enemies[i].x,enemies[i].y) += enemies[i].speed
  }
~~~
