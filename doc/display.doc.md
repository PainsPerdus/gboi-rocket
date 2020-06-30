# Documentation for non critical display  

Here we can do everything related to display that isn't touching the OAM. 

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

