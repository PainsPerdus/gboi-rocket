# Collision Solver for Isaac

## Label

'collision'

## Parameters

| Label | Type | Size/Struct | Description |
| ----- | ---- | ----------- | ----------- |
| b | register | 1 byte | the 4 left bits are flags which indicates which side of the element Isaac touched (right, left, lower, upper) |
| hl | register | 2 bytes | address to the caracter's sheet of the element |

## Return

None

## Pseudo Code

~~~C
// a function for when Isaac collides with any element
char void solve_collision_to_Isaac (
	char touched_from,
	element.sheet* s) {
	
	if (0b00010000 and s.size) // is the element blocking
		if (touched_from and 0b10000000) //Isaac touches the right side of the element
			Isaac.x = Isaac.x + ((Isaac.speed or 0b11110000)/16)
		if (touched_from and 0b01000000) //Isaac touches the left side of the element
			Isaac.x = Isaac.x - ((Isaac.speed or 0b11110000)/16)
		if (touched_from and 0b00100000) //Isaac touches the lower side of the element
			Isaac.y = Isaac.y + (Isaac.speed or 0b00001111)
		if (touched_from and 0b00010000) //Isaac touches the upper side of the element
			Isaac.y = Isaac.y - (Isaac.speed or 0b00001111)

	if (0b00001000 and s.size) // does the element hurt Isaac
		if (Isaac.recover == 0)
			Isaac.hp = Isaac.hp - s.dmg;
			Isaac.recover = RECOVERYTIME;

	if (0b00000100 and s.size) // does the element react to Isaac's touch
		s.function();

}
~~~

## Note

We mustn't forget to decrease the recover counter at each VBLank call

## TODO

* the rollback technic to manage collision with blocking elements is likely not to be the best, as it can cause lines of uncrossable pixels between Isaac and the element.