# Play the turn of the enemies

## Description

Call the AI function for all the ennemies

~~~C
for (i=global_.enemies; i++; i<n_enemies)
  AI(i);
  if (! (enemies[i].lagFrame--)){
    enemies[i].lagFrame = enemies[i].speedFreq;
    (enemies[i].x,enemies[i].y) += enemies[i].speed
  }
~~~
