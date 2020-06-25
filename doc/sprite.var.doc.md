# Global reserved memory:

## Isaac_spritesheet

sprite order are written between ()
fn = frame n° n

|        Label             |     Value    |                         Description                                          |
| ------------------------ | ------------ | ---------------------------------------------------------------------------- |
| ISAAC_SPRITESHEET        |    2 bytes   | address of the first issaac's sprite                                         |
| ISAAC_TOP_LEFT           |    2 bytes   | top left sprite (empty - eye - closed eye)                                   |
| ISAAC_TOP_RIGHT          |    2 bytes   | top rigth sprite (empty - eye - closed eye)                                  |
| ISAAC_BOTTOM_LEFT_STAND  |    2 bytes   | bottom left sprite for isaac standing                                        |
| ISAAC_BOTTOM_RIGHT_STAND |    2 bytes   | bottom right sprite for isaac standing                                       |
| ISAAC_BOTTOM_LEFT_WALK   |    2 bytes   | first sprite of walk animation (f1 no tear - f1 tear - f2 no tear - f2 tear) |
| ISAAC_BOTTOM_RIGHT_WALK  |    2 bytes   | first sprite of walk animation (f1 no tear - f1 tear - f2 no tear - f2 tear) |
| ISAAC_MOUTH_PIXEL_1      |    2 bytes   | position of the first byte encoding isaac's mouth pixel                      |
| ISAAC_MOUTH_PIXEL_2      |    2 bytes   | position of the second byte encoding isaac's mouth pixel                     |