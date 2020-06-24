# Collision Solver for Entities other than Isaac

## Label

`collision`

## Parameters

| Label | Type | Size/Struct | Description |
| ----- | ---- | ----------- | ----------- |
| b | register | 1 byte | the 4 left bits are flags which indicates which side of the element the entity touched (right, left, lower, upper) |
| hl | register | 2 bytes | address to the caracter's sheet of the element |
| collidingEntity | fixed address | element pointer | address to the element representing the entity |

## Return

None

## Pseudo Code

~~~C
// a function for when an entity collides with any element
char void solve_collision_to_Isaac (
	element entity,
	char touched_from,
	element.sheet* s) {
	
	if (0b00010000 and s.size) // is the element blocking
		if (touched_from and 0b10000000) //Entity touches during horizontal movement
			Entity.x = Entity.x - ((Entity.speed and 0b11110000)/16)
		if (touched_from and 0b01000000) //Entity touches during vertical movement
			Entity.y = Entity.y - (Entity.speed and 0b00001111)

}
~~~

## Note

Same function as for Isaac, but with less cases here (other entities donc take contact damages, and can't activate anything

## TODO

* the rollback technique to manage collision with blocking elements is likely not to be the best, as it can cause lines of uncrossable pixels between Isaac and the element.