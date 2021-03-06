# Collision Solver for Isaac

## Label

`collisionSolverIsaac`

## Parameters

| Label | Type | Size/Struct | Description |
| ----- | ---- | ----------- | ----------- |
| b | register | 1 byte | the 2 left bits tell whether the collision happens during (respectively) horizontal or vertical movement |
| hl | register | 2 bytes | address to the caracter's sheet of the element |

## Return

None

## Pseudo Code

~~~C
// a function for when Isaac collides with any element
char void solve_collision_to_Isaac (
	char touched_from, // b register
	element.sheet* s) { // hl register
	
	if (0b10000000 and s.size) // is the element blocking
		if (touched_from and 0b10000000) //Isaac touches during horizontal movement
			Isaac.x = Isaac.x - ((Isaac.speed and 0b11110000)/16)
		if (touched_from and 0b01000000) //Isaac touches during vertical movement
			Isaac.y = Isaac.y - (Isaac.speed and 0b00001111)

/*	if (0b01000000 and s.size) // does the element hurt Isaac
		if (Isaac.recover == 0)
			Isaac.hp = Isaac.hp - s.dmg;
			Isaac.recover = RECOVERYTIME;

	if (0b00100000 and s.size) // does the element react to Isaac's touch
		s.function();
*/
}
~~~

## Note

We mustn't forget to decrease the recover counter at each VBLank call.

For now, the informations given in the b register is not used in the actual implementation, as the collision function isn't able to detect direction of the impact. The code simply reverse the movement.

## TODO

* the rollback technique to manage collision with blocking elements is likely not to be the best, as it can cause lines of uncrossable pixels between Isaac and the element.
