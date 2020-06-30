; ////// Tears opcode injection preparation \\\\\\

;//Initialization

; BL = global_.isaac_tears
; RL = (blackmagic_.RL+blackmagic_.RL_counter)

xor a
ld (blackmagic_.RL_counter), a ;Initialize RL_counter
ld (blackmagic_.OAM_id_counter), a ;Initialize OAM_id_counter

ld b, 16+4 ;hline
;//Main loop
@mainLoop:

	;   First we look for a source bullet to recycle.
	;   We look from the top of the screen to hline-4. 

	ld hl, global_.isaac_tears ; BL (we make the assumption BL is between XX00 and XXFF)
	ld c, l ;min_index = 0
	ld a, (hl)
	ld d, a ;BL[min_index].posY
	;//First min searching loop
	ld b,b
@minLoop1
	ld a, (hl) ; BL[j].Y

	cp d 
	jp nc, @continueMinLoop1 ; if(BL[j].posY >= BL[min_index].posY)

	and a
	jp z, @continueMinLoop1 ; if(BL[j].posY == 0)
	
	sub 12
	sub b
	jp nc, @continueMinLoop1 ; if(BL[j].posY-16-hline+4 > 0)

	inc l ; BL[j].X
	inc l ; BL[j].id
	ld a, (hl)
	dec l
	dec l ; back to BL[j].Y
	bit 7, a
	jr nz, @continueMinLoop1 ; if(BL[j].recycled)


	ld c, l ;min_index = j	
	ld a, (hl) 
	ld d,a ;BL[min_index].posY

@continueMinLoop1
	ld a,l
	add _sizeof_tear ;j++
	ld l,a
	cp n_isaac_tears*_sizeof_tear
	jp nz, @minLoop1 ;j < len(BL)
	ld b,b




@continueMainLoop
inc b ; hline++
ld a,b
cp 144-16-5+1
//jp nz, @mainLoop ;hline < 144-16-5+1



; \\\\\\ Tears opcode injection preparation //////


