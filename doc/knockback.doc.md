# knockback

## knockback function

A simple IA that follow Isaac.

### Label:

`knockback`

### Parameters:

| Label | Type | Size/Struct |  Description  |
| ------------- | ------------- | ---------- | ----------- |
| b | register | A bytes | Direction of the knock back. (dx = b[7:4], dy = b[3:0]) |
### Return:

### Modified values:

| Label | Type | Size/Struc |
| ------------- | ------------- | ---------- |
| a | register | 1 byte |
| b | register | 1 byte |
| global_.isaac.x | fixed address | 1 byte |
| global_.isaac.y | fixed address | 1 byte |
| collision_.p.1.x| fixed address | 1 byte |
| collision_.p.1.y | fixed address | 1 byte |

### Global variables used

| Label | Size |  Description  |
| ------------- | ---------- | ----------- |
| Isaac| isaac | Isaac |

### Pseudo code

~~~C
char knockback(
  direction)
  for (i = DIST_KNOCK_BACK; i ; i>0 ){
    isaac.x,isaac.y += direction;
    if (collision_obstacles(isaac)){
      isaac.x,isaac.y -= direction;
      return;
    }
  }

}
~~~

### Notes



### TODO

* Optimise the memory accesses (it's really messy right now)
