.DEFINE ISAAC_SPRITESHEET $01
.DEFINE ISAAC_TOP_LEFT ISAAC_SPRITESHEET 
.DEFINE ISAAC_TOP_RIGHT ISAAC_SPRITESHEET + $03
.DEFINE ISAAC_BOTTOM_LEFT_STAND ISAAC_SPRITESHEET + $06
.DEFINE ISAAC_BOTTOM_RIGHT_STAND ISAAC_SPRITESHEET  + $0C
.DEFINE ISAAC_BOTTOM_LEFT_WALK ISAAC_BOTTOM_LEFT_STAND
.DEFINE ISAAC_BOTTOM_RIGHT_WALK ISAAC_BOTTOM_LEFT_STAND - $02
.DEFINE ISAAC_MOUTH_PIXEL_1 $8000 + (ISAAC_BOTTOM_LEFT_WALK+$01)*$10+$01
.DEFINE ISAAC_MOUTH_PIXEL_2 ISAAC_MOUTH_PIXEL_1 + $20
; 8th and 10th tiles need a cache