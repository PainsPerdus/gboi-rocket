.DEFINE MAP_PIXEL_SIZE $A0

.DEFINE LEFT_RIGHT_DOOR_X $54
.DEFINE TOP_BOTTOM_DOOR_Y $54

.DEFINE OPEN_DOOR_OFFSET $12

.STRUCT load_map_var
    map_address DW
    map_info DB
    current_address DW
    next_blocking DW
    next_enemy DW
    next_object DW
    next_to_load DW
    mob_number DB
.ENDST
