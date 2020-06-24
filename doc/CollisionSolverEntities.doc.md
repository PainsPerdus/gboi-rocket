# Collision Solver for Entities other than Isaac

## Label

`collisionSolverEntities`

## Parameters

| Label | Type | Size/Struct | Description |
| ----- | ---- | ----------- | ----------- |
| b | register | 1 byte | the 2 left bits tell whether the collision happens during (respectively) horizontal or vertical movement |
| hl | register | 2 bytes | address to the caracter's sheet of the element |
| collisionSolver_.collidingEntity | fixed address | element pointer | address to the element representing the entity |

## Struct

Description of the collisionSolver_var struct in the CollisionSolverEntities.var.s file

| Label | Size/Struct | Description |
| ----- | ----------- | ----------- |
| collidingEntity | element pointer | address to the element representing the entity |

## Return

None

## Pseudo Code

~~~C
// a function for when an entity collides with any element
char void solve_collision_to_Isaac (
	char touched_from, // b register
	element.sheet* s, // hl register
	element entity) { // collisionSolver_.collidingEntitty
	
	if (0b00010000 and s.size) // is the element blocking
		if (touched_from and 0b10000000) //Entity touches during horizontal movement
			Entity.x = Entity.x - ((Entity.speed and 0b11110000)/16)
		if (touched_from and 0b01000000) //Entity touches during vertical movement
			Entity.y = Entity.y - (Entity.speed and 0b00001111)

}
~~~

## Note

Same function as for Isaac, but with less cases here (other entities donc take contact damages, and can't activate anything.

For now, the informations given in the b register is not used in the actual implementation, as the collision function isn't able to detect direction of the impact. The code simply reverse the movement.

## TODO

* the rollback technique to manage collision with blocking elements is likely not to be the best, as it can cause lines of uncrossable pixels between Isaac and the element.