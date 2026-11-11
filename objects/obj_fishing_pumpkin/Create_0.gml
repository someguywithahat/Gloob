/*
	Pumpkin, the orange slime, fishing from the shore in the right fishing room (rm_fishingRight).
	Just fishes (Spr_Slm_Fish, animated), in her own color.
	Faces right, with the rod out to the right.  Set the instance's X scale to -1 in the room editor to face left.
*/
color_index = global.ORANGE
image_index = irandom(sprite_get_number(sprite_index)-1) //So the two of them don't bob in step
