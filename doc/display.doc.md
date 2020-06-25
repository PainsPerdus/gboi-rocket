# Documentation for graphics.s

TODO: This section needs improvement. 

Needed Information:
- Isaac posX
- Isaac posY
- Isaac orientation
- Is isaac moving? 
- Has isaac shot during last frame?
- frameCount

Constants :
- isaac spritesheet
- Left eye start
- Right eye start
- Left standing start
- Right standing start
- Left walking start
- Right walking start
- 

## Update sprites position

We start by updating sprite positions in OAM because we need to do it before the end of VBlank. After, the OAM will be locked. 

### Isaac

TODO : add constants for sprite position in OAM  
We update each sprite posX and posY according to isaac pos x and y.
For that we start by copying the positions in registers to save time, then we update the sprites in the following order:  
- top left
- top right
- bottom left
- bottom right

### Isaac States and Animations ###

In this part we are going to update Isaac sprites in OAM to select the correct sprites for current state and animation frame.  
Isaac sprite is divided into 4 8x8 tiles, 2 top tiles for the head and eyes, 2 bottom tiles for the legs and tears.

### Top tiles

Isaac both eyes can be hidden if he turns his back (facing UP), one can be hidden if he faces LEFT or RIGHT. 
The shown eyes must close for one frame if he is shooting. 

Here is how we compute the sprite_id that will be stored in OAM for the first two sprites of isaac: 
(Reminder : orientation is as follows : 
      11 
      TOP
10 LEFT RIGHT 01
    BOTTOM
      00
)	
~~~C
//Left
offset = bit1(orientation) + (bit1(!orientation) && has_shot)
sprite_id=LEFT_EYE_START + offset
//Right
offset = bit2(orientation) + (bit0(!orientation) && has_shot)
sprite_id=RIGHT_EYE_START + offset
~~~

### Bottom tiles

Isaac's legs are always facing front and his head moves independently.
But a part of his face is displayed in the bottom sprites and has to move accordingly.
~~~C
if (moving)
{
	//Left
	sprite_id = LEFT_WALKING_START + 2*frameCount+ bit1(orientation)
	//Right
	sprite_id = RIGHT_WALKING_START + 2*frameCount+ bit0(orientation)
}else
{
	//Left
	sprite_id = LEFT_STANDING_START  + bit1(orientation)
	//Right
	sprite_id = RIGHT_STANDING_START + bit0(orientation)
}
~~~

When isaac is facing left (orientation 10), we need to hide the mouth pixel

~~~C
if(orientation==10) {
	MOUTH_PIXEL = $01 //Light gray
}
else {
	MOUTH_PIXEL = $11 //Black
}
~~~
