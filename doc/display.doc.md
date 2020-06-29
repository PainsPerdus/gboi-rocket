# Documentation for graphics.s

# Critical Section

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

# Non Critical Section

Here we can do everything that isn't touching the OAM. 

## Update Animation frames and timers

We're going to update the animations frame counters and the animation timers

### Isaac

Here is the code to update Isaac's walk animation timer and frame counter
When the timer reaches 0, we reset it to N, to wait for N VBlank frames before switching to the next animation frame. 
(N is a constant, currently N=20)

~~~C
if(global_.isaac.speed != 0) { //Moving
	if(display_.isaac.walk_timer==0) { //When the timer hits 0, we reset it
		display_.isaac.walk_timer=N 
		display_.isaac.frame = (display_.isaac.frame + 1) %2 //There are only two frames
	}
	display_.isaac.walk_timer--
}
else { //Not Moving
	//We reset the timer
	display_.isaac.walk_timer=0
	//We reset the walk frame counter
	display_.isaac.frame
}
~~~

## Bullets

We have 4 sprites for bullets in OAM. 
Get bullet list. Find the bullet with smallest y.
Look for the bullet that are at least y'=y+8 (bullets are only 4 pixels heigh, but there can we up to 4 sprites to recycle per line, and we can only recycle one. So that lets up 4 hblank lines to recycle those sprites) and has the smallest y'.
Continue: we create an ordered bullet list by y, and there is at least 8 pixels between each bullets. This is our first recycling chain.
Then, we do this again with remaining bullets, until all remaining bullets are less than 8 pixels appart.
This leads to 8 ordered list + bullets we cannot recycle because they overlap. 
We need to avoid having 2 recyclings in the same line!

We need to tell 3 infos to the HBlank procecure :
- Y address in OAM  (1 byte)
- new x pos (1 byte)
- new y pos (1 byte)
- hblank line for the recycling (1 byte)

These infos will be in an array that we will build during VBlank with our 8 ordered lists.
The array will be ordered by hblank line, more on that [here](display.doc.md).
When we have to recycle a sprite on one Y, we assign it to the hblank 4 y lower. And the next on the same y : 5 y lower, then 6, 7. We can do 4 recyling on the same line with that method

To read this array in RAM : we test if we are at the line. We manually load a pointer to the array in hl after the recyling code. If we are no the correponding line, we increament manually in opcode that pointer and we update the x, y and oam sprite number 

Here is the pseudo code to build the first list:
~~~C
BL = bullet list = [(PosY, PosX, visited=false), ...] ordered by PosY asc
PL = Prepared list number 1 = [(PosY, PosX), ...] ordered by PosY asc
int j=0;
last_element = 0 //Pointer to last added element
for (int i=0; i<len(BL); i++) {
	if (BL[i].visited)
		continue;
	if (last_element==0 || BL[i].Y > (last_element).Y+8) {
		last_element=(BL+i)
		PL[j].X=*(last_element.X)
		PL[j].Y=*(last_element.Y)
	}
}
~~~

Here is the new algorithm (better, more vanilla, less sugar) :
~~~C
BC = [(posY, posX, recycled, inChain, init, OAM_id), ...] //Bullet list
RL = [(hline, OAM_id, newX, newY), ... ] //Recycling List

char OAM_id = 0; //Current free OAM_id for initialization

//TODO : optimize hline start and end. 
for(char hline = 16*4; hline <= 144-16-5; hline++) { //We iterate over all screen lines, and look what sprite to recycle at each line

	/* First, we look for a source bullet to recycle.
	   We look from the top of the screen to hline-4. */  

	char min_index = 0; //Index in BL of the bullet with minimum Y that verifies the following conditions:  
	for(char j=1; j<len(BL); j++) {
		if(BL[j].posY >= BL[min_index.posY]) //We compute a minimum, this tests if posY is lower than what we currently found
			continue;
		if(BL(j).posY == 0) //If posY is 0, it means the bullet is not used (out of screen)
			continue;
		if(BL[j].posY-16 > hline-4) //The bullet must be above the hline-4 to be able to start recycling it. The +16 offset is due to GB screen offset. 
			continue;
		if(BL[j].recycled) //We won't recycle a bullet that's already been recycled, it doesn't make sense. (Reminder: we're building a chain) 
			continue;  

		min_index=j //We found a better candidate, so we update the min index
	}  

	//We need to double check the result, in case min_index didn't change from default value (0)
	if(BL[min_index].posY-16 > hline-4 || BL[min_index].recycled || BL[min_index].posY == 0)
		continue; //There is no bullet avaliable to recycle at this hline  

	char source = m_index; //We found the recycling source! 

	
	/* Then, we look for a target bullet to recycle to. 
	   We look from hline+1 to the bottom of the screen. */

	min_index=0;  //Index in BL of the bullet with minimum Y that verifies those new conditions: 
	for(char j=1; j<len(BL); j++) {
		if(BL[j].posY >= BL[min_index].posY) //We compute a minimum, this tests if posY is lower than what we currently found
			continue;
		if(BL[j].posY <= hline) //To be a valid recycling target, the bullet must be after hline
			continue;
		if(BL[j].inChain) //We won't recycle to a bullet that's already in a chain, so that's already being taken care of
			continue;  

		min_index=j; //We found a better candidate, so we update the min index
	}

	//We need to double check the result, in case min_index didn't change from the default value (0)
	if(BL[min_index].posY <= hline || BL[min_index].inChain)
		break; // There is no possible target below hline, so there is no more recycling needed/possible. 

	char target = m_index; //We found the recycling target!

	if(!BL[source].inChain) { //The source is the first in its recycling chain, so we need to manually add it to OAM in VBlank, so we choose an id
		BL[source].OAM_id=OAM_id++; //Set source's id in OAM and increase the current id
		BL[source].init=true; //Indicate that the source needs to be initialized manually into OAM in VBlank
	}  

	BL[source].inChain=true; BL[source].recycled=true; //The source is now already recycled, and so is in a chain

	BL[target].OAM_id=BL[source].OAM_id //We replace the source with the target, so the target takes the id of the source
	BL[target].inChain=true; //The target is in a recycling chain now.

	//Add corresponding recycling rule
	*(RL++) = (hline, BL[source].OAM_id, BL[target].posX, BL[target].posY); //During hline, the source bullet's position will be set to the target bullet position
}
~~~
