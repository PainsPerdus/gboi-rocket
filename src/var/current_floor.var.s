.STRUCT room
    coordinates DB
    id DB
    info DB
    mask DSB 7
.ENDST

.STRUCT current_floor_var
    number_rooms DB
    rooms INSTANCEOF room 10
    current_room DW
.ENDST