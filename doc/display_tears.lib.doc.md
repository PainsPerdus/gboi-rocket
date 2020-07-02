# Display Tears

## Display Isaac Tears

| Argument | Type | Description |
| -------- | ---- | ----------- |
| a | register | OAM load direction (bit(0)=0 : normal, bit(0)=1: reversed) |

We load the tears in OAM in normal order or reversed depending on a.
For now, a is ignored.

~~~C
char direction; //First argument
if(direction==0) {
	char d = n_isaac_tears
	char *hl = global_.isaac.tears //Pointer on struct array
	char *bc = OAM_pointer //OAM_pointer
	do {
    	if(*hl.Y != 0) {
       	 	(*bc).Y=(*hl).Y;
       	 	(*bc).X=(*hl).X;
			(*bc).tile=TEAR_SPRITESHEET
        	bc++;
        	if(bc==OAM_SIZE) {
            	break;
        	}
    	}
		hl+=1;
	} while(--d!=0)
}
else {

}

~~~
