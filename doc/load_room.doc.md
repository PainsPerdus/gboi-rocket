# Map loading function

## Parameter

| Label | Type | Size/Struct |  Description  |
| ------------- | ------------- | ---------- | ----------- |
| load_room_.room_address | fixed address | 2 bytes | address of the map file |
| load_room_.room_info | fixed address | 1 byte | info as described in the room structure |

## Reserved memory

| Label | Size/Struct |  Description  |
| ------------- | ---------- | ----------- |
| load_room_.room_address | 2 bytes | address of the map file |
| load_room_.room_info | fixed address | 1 byte | info as described in the room structure |
| load_room_.next_blocking | 2 bytes | address of the next blocking element to use |
| load_room_.next_enemy | 2 bytes | address of the next enemy to use |
| load_room_.next_object | 2 bytes | address of the next object to use |
| load_room_.next_to_load | 2 bytes | address of the next enemy to load |

## Pseudo Code

~~~C
load_room(char[] room_address) {
    for (b = 0, b < global_.n_blockings - 4, b ++){
        // load void
    }

    for (b = 0, b < global_.n_enemies, b ++){
        // load void enemy
    }
    
    for (b = 0, b < global_.n_objects, b ++) {
        // load void object
    }

    // add doors
    if (room_address[0] and 0b10000000)
        //load top door
    if (room_address[0] and 0b01000000)
        //load bottom door
    // ...
    
    // add map content
    index = 0
    for (b = 32, b < 144, b = b + 16) {
        for (c = 24, c < 152, c = c + 16) {
            switch((room_address[3 + index] and 0b11110000)/16) {
                case 0:
                    break;
                case 1:
                    // load pit in (c,b)
                    blockings_written ++
                    break;
                // ...
            }
            c = c + 16
            switch(room_address[3 + index] and 0b00001111) {
                case 0:
                    break;
                case 1:
                    // load pit in (c,b)
                    blockings_written ++
                    break;
                // ...
            }
            index ++
        }
    }
}
~~~
