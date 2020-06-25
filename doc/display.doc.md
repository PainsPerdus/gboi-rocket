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
We also update the sprite shown for each Isaac's part

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
offset = bit1(display_.isaac.direction) + (bit1(display_.isaac.direction) && (shoot_timer > 0))
sprite_id= ISAAC_TOP_LEFT  + offset
//Right
offset = bit0(display_.isaac.direction) + (bit0(display_.isaac.direction) && (shoot_timer > 0))
sprite_id= ISAAC_TOP_RIGHT + offset
~~~

### Bottom tiles

Isaac's legs are always facing front and his head moves independently.
But a part of his face is displayed in the bottom sprites and has to move accordingly.
~~~C
if (global_.isaac.speed != 0)
{
	//Left
	sprite_id = ISAAC_TOP_LEFT + 2*display_.isaac.frame+ bit1(display_.isaac.direction)
	//Right
	sprite_id = ISAAC_TOP_RIGHT + 2*display_.isaac.frame+ bit0(display_.isaac.direction)
}else
{
	//Left
	sprite_id = ISAAC_BOTTOM_LEFT_STAND  + bit1(display_.isaac.direction)
	//Right
	sprite_id = ISAAC_BOTTOM_RIGHT_STAND + bit0(display_.isaac.direction)
}
~~~

When isaac is facing left (orientation 10), we need to hide the mouth pixel

~~~C
if(display_.isaac.direction==10) {
	ISAAC_MOUTH_PIXEL_1 = $00 // black => Light gray ($11 => $01)
	ISAAC_MOUTH_PIXEL_2 = $00
}
else {
	ISAAC_MOUTH_PIXEL_1 = $01 //Light gray => black
	ISAAC_MOUTH_PIXEL_2 = $01
}
~~~
