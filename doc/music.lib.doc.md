# Music functions

## Timer interrupt handler

Saves all registers, then reads from the state structure to know if it has to play a new note.
It stops its sound output.
If it does, it reads it and decodes it by reading the content of the scale and timing array, of which there are pointers in the state structure.
It sets its state to wait the correct amount of time and to the correct note.
It sets the registers to play the correct note, then reenable the sound channel
If it arrived at the end of the music it calls the end of part manager.
And then restores registers.

## End of part manager

The music file is interpreted as having tracks grouped by 2 (chan 1 and 2), the end of part basically offsets music pointer so that the music_start function thinks the 2n and 2n+1 tracks are the 2 tracks of the music.
Then it restores registers.

## Music start

Arguments : HL : music pointer

Uses : A, B, C, D, E, H, L

Clobber : A, F, H, L

Loads music file info in the state.