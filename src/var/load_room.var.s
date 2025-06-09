.DEFINE ROOM_PIXEL_SIZE $A0

.DEFINE LEFT_RIGHT_DOOR_X $54
.DEFINE TOP_BOTTOM_DOOR_Y $54

; doors are objects, so Issac must overlap their hitboxes
; to enter them, which is why they must protrude out of the
; wall, thus the offset
.DEFINE OPEN_LEFT_RIGHT_DOOR_OFFSET $0A
.DEFINE OPEN_TOP_BOTTOM_DOOR_OFFSET $12

.STRUCT load_room_var
    room_address DW
    room_info DB
    current_address DW
    next_blocking DW
    next_enemy DW
    next_object DW
    next_to_load DW
    mob_number DB
.ENDST
