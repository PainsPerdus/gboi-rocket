# Move the tears

## Description

Move the tears and kill them if they collide with an obstacle
~~~C
for (i=global_.isaac_tears; i++; i<n_isaac_tears)
  AI(i);
  if (! (isaac_tears[i].lagFrame--)){
    isaac_tears[i].lagFrame = isaac_tears[i].speedFreq;
    if (isaac_tears[i].speed.x != 0 and isaac_tears[i].speed.y != 0)
      isaac_tears[i].lagCounter += int(isaac_tears[i].speedFreq/2 +0.5);

    (isaac_tears[i].x,isaac_tears[i].y) += isaac_tears[i].speed
  }
~~~
