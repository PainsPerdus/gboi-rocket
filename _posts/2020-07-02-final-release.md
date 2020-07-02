---
title: "Final release ?"
date: 2020-07-02
author: Dorian
header:
  teaser: /assets/images/first_release.png
categories: 
 - Blog
tags:
 - milestone
 - release
---

Hey everyone,

Wondered what we did during the last few days when we didn't post anything ? We worked hard, very hard to finish what we wanted for our deadline.

Now this deadline has passed and we wanted to share what we achieved. To sum up, we have :
- Annimations
- Music
- Sound FX
- Levels
- Ennemies
- Title screen
- Game over screen
- Working tears

Now, how does it look ? How does it sound ?

Well, let's see ...

## Annimations
Thanks to the wonderful work of Pascal and Virgile, we have working annimations !

Isaac walking :

![walking](../../assets/images/gboi_walking.gif)

Flies :

![flies](../../assets/images/gboi_flies.gif)

## Music
Melissa did the wonderful and tiresome work of transcribing the score made by Noel, our piano teacher, of the "Sacrificial" music, to our own custom format. I designed the sound driver and programmed most of it though the core code is still Melissa's.
Listen yourself :

<audio controls>
  <source src="../../assets/gameboy_of_isaac_soundtrack.mp3" type="audio/mpeg">
  <p>Link to the audio file as your browser doesn't support audio embeddings : <a href="../../assets/gameboy_of_isaac_soundtrack.mp3">link</a> .</p>
</audio>

## Sound FX
Melissa found some intersting Sound FX, and I tweaked and ported them to the game and made it work with our preexisting music driver.

Start effect :

<audio controls>
  <source src="../../assets/gboi_start.mp3" type="audio/mpeg">
  <p>Link to the audio file as your browser doesn't support audio embeddings : <a href="../../assets/gboi_start.mp3">link</a> .</p>
</audio>

Hit by ennemy :

<audio controls>
  <source src="../../assets/gboi_hurt.mp3" type="audio/mpeg">
  <p>Link to the audio file as your browser doesn't support audio embeddings : <a href="../../assets/gboi_hurt.mp3">link</a> .</p>
</audio>

Ennemy hit :

<audio controls>
  <source src="../../assets/gboi_tear.mp3" type="audio/mpeg">
  <p>Link to the audio file as your browser doesn't support audio embeddings : <a href="../../assets/gboi_tear.mp3">link</a> .</p>
</audio>

## Levels
If you go through the trapdoor, you end up in another level (in which the only thing you can do is die, but shhhhhht). Thanks to Thomas for the amazing work he did on level loading and Melissa for her work on the level generation algorithm.
I also implemented the RNG for this feature, though it ended up being used mostly elsewhere.

### Rooms
But what are levels if you cannot switch between rooms ? Thanks to Thomas's work for room loading and Melissa for writing the room files.

![rooms](../../assets/images/gboi_rooms2.gif)

## Ennemies
Now, the game would be quite boring without something to do, some challenge to accomplish. Well, the ennemies (only flies for now) are here to help you out on that one. Thanks for Jean-Marie for his work on collisions and ennemy movement !

Flies are actively trying to hug you, and as you don't like hugs, it hurts you.

![hurt](../../assets/images/gboi_hurt.gif)

## Title screen
Thanks to Virgile for his state machine and Pascal for his work on graphics, we have a title screen !

See for yourself :

![start](../../assets/images/gboi_start.gif)

### Game over screen
Not happy with just a title screen, they implemented a "game over" screen ! Take a look :

![death](../../assets/images/gboi_death.gif)

## Tears
Last but not least : tears. What fun would be the game if the only thing you could do to prevent the mean flies from hugging you was to just stand there ? You can cry and shoot your tears to kill them !

![tears](../../assets/images/gboi_tears.gif)

## And now ?
For now, we rest. Those last few weeks have been really tiresome and we have other things to do and other things to worry about. But be assured this isn't the last time you'll hear about us. We do want to continue this game, at a slower pace, as it was an incredible experience, and we want to keep on messing with the gameboy.

These are our goals for the future :
- Transition from WLA-DX to RGBDS : WLA-DX is very obscure and we've been fighting against it a lot. RGBDS is more open, more documented and we should have less fighting with the assembler, and more fighting against the hardware itself.
- More musics for the title screen and game over screen, more sound effects, etc ...
- More ennemies, as flies are cool, but variety is necessary to prevent the game from being boring. Bosses also are something we think about implementing in the future.
- Make the level generation happen at run-time instead of preloading generated maps in the ROM.
- ITEMS : isaac needs items to help him fight against his hug-loving foes !

As you can see, we are far from finished ! These features will take time to implement, but we're still stoked about working on this game and we can say with absolute certainty this isn't the last blog post about this project.

A huge shout out to our friends at team kirby, check out their Pineapple of Doom there : https://github.com/PainsPerdus/gboi-kirby with their blog here : https://painsperdus.github.io/gboi-kirby/

See you !

Dorian, for the team Rocket



