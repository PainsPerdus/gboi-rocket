# Display background doors

Function : displays 1 to 4 doors depending of room configuration. Doors can be all opened or all closed.

Modifies: A, HL  
Restores: BC, DE  
Arguments:  

| Label |   Type   | Size        | Description                                       |
| ----- | -------- | ----------- | --------------------------------------------------|
| A     | register | 1 byte      | doors to display (00001111 = all doors; 00001000 = up only))           |
| B     | register | 1 byte      | doors status ; 1 = doors closed, 0 = doors opened |
