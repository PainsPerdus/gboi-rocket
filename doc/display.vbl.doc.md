# Documentation for display critical section (VBlank)

In the critical section we must update the OAM and the VRAM as quickly as possible before we're out of VBlank. 

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

In this part we are going to update Isaac sprites in OAM to select the correct sprites for current state and animation frame.  
Isaac sprite is divided into 4 8x8 tiles, 2 top tiles for the head and eyes, 2 bottom tiles for the legs and tears.
At the same time, we're going to update Isaac's position in the OAM. 

#### Top tiles

Isaac both eyes can be hidden if he turns his back (facing UP), one can be hidden if he faces LEFT or RIGHT. 
The shown eyes must close for one frame if he is shooting. 

Here is how we compute the sprite_id that will be stored in OAM for the first two sprites of isaac: 
(Reminder : orientation is as follows : 
      00 
      TOP
10 LEFT RIGHT 01
    BOTTOM
      11
)	
~~~C
//Left
offset = bit1(global_.isaac.direction) + (bit1(global_.isaac.direction) && (display_.shoot_timer > 0))
sprite_id= ISAAC_TOP_LEFT  + offset
//Right
offset = bit0(global_.isaac.direction) + (bit0(global_.isaac.direction) && (display_.shoot_timer > 0))
sprite_id= ISAAC_TOP_RIGHT + offset
~~~

#### Bottom tiles

Isaac's legs are always facing front and his head moves independently.
But a part of his face is displayed in the bottom sprites and has to move accordingly.

Also, we set a timer to change isaac's sprites only each N frames (constant) to slow down the animation.

##### Setup sprite ids
Here how we calculate the left and right sprite_id for this frame: 
~~~C
if (global_.isaac.speed != 0) // Moving 
{
	//Left
	left_sprite_id = ISAAC_BOTTOM_LEFT_WALK + 2*display_.isaac.frame+ bit1(global_.isaac.direction)
	//Right
	right_sprite_id = ISAAC_BOTTOM_RIGHT_WALK + 2*display_.isaac.frame+ bit0(global_.isaac.direction)
}else //Not Moving
{
	//Left
	left_sprite_id = ISAAC_BOTTOM_LEFT_STAND  + bit1(global_.isaac.direction)
	//Right
	right_sprite_id = ISAAC_BOTTOM_RIGHT_STAND + bit0(global_.isaac.direction)
	//Update Timer
	display_.isaac.walk_timer=0 //Not walking, so timer = 0 (we update the sprites all the time)
}
~~~

##### Update OAM

These sprite_id will be then placed in the OAM at the same time as the updated positions.

To make isaac blink after taking damage, isaac's sprites are hidden every 8 frames, corresponding to the 3rd bit of the "recover" timer
~~~C
if (bit2(global_.isaac.recover))
{
hideIsaac()
}
~~~

#### Mouth pixel

When isaac is facing left (orientation 10), we need to hide the mouth pixel

~~~C
if(global_.isaac.direction==10) {
	ISAAC_MOUTH_PIXEL_1 = $00 // black => Light gray ($11 => $01)
	ISAAC_MOUTH_PIXEL_2 = $00
}
else {
	ISAAC_MOUTH_PIXEL_1 = $01 //Light gray => black
	ISAAC_MOUTH_PIXEL_2 = $01
}
~~~

#### Tears

We show the first `OAM_ISAAC_TEARS_SIZE` first active tears listed in `global_.isaac_tears`  
~~~C
char d = n_isaac_tears+1
char *hl = global_.isaac.tears //Pointer on struct array
char *bc = OAM_ISAAC_TEARS //Pointer in OAM
do {
	if(*hl.Y != 0) {
		(*bc).Y=(*hl).Y;
		(*bc).X=(*hl).X;
		bc++;
		if(bc>End address of tears in OAM) {
			break;
		}
	}
	bc++;
} while(--d!=0)

#### Hearts

We show the hearts on the background, in the upper left corner.

~~~C
char *BACKGROUND_HEARTS_POS = $9800 //Background first heart pos in background map
char hp=0;
do {
	heart_sprite = HEARTS_SPRITESHEET //Sprite id in VRAM
	if(global_.isaac.hp>hp) {
		heart_sprite++;
	}
	if(global_.isaac.hp>hp+1) {
		heart_sprite++;
	}
	
	*(BACKGROUND_HEARTS_POS+hp/2)=heart_sprite
	hp+=2;

} while(hp<ISAAC_MAX_HP)
~~~C
