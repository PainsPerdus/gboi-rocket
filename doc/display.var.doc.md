# Display structs:

## Isaac

| Label       | Size/Struct | Description                                                      |
| ----------- | ----------- | ---------------------------------------------------------------- |
| frame       | 1 byte      | Animation frame number                                           |
| shoot_timer | 1 byte      | Number of game frames before the end of shooting animation       |
| walk_timer  | 1 byte      | Number of game frames before the next frame of walking animation |

# Display vars

| Label          | Size/Struct | Description                  |
| -------------- | ----------- | ---------------------------- |
| display_.isaac | isaac       | Isaac's animation properties |
