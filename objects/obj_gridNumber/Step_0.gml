
//if activeNumber == 0
//	visible = false;

if has_powerUP>0 and activeNumber>0 and wall=0
{
	switch(my_number)
	{
		case 1: sprite_index=Spr_PU_N1 break
		case 2: sprite_index=Spr_PU_N2 break
		case 3: sprite_index=Spr_PU_N3 break
		case 4: sprite_index=Spr_PU_N4 break
		case 5: sprite_index=Spr_PU_N5 break
		case 6: sprite_index=Spr_PU_N6 break
		case 7: sprite_index=Spr_PU_N7 break
		case 8: sprite_index=Spr_PU_N8 break
		case 9: sprite_index=Spr_PU_N9 break
	}
	
	if(has_powerUP=1)
		gloop_color_index=7
	else if(has_powerUP=2)
		gloop_color_index=1
	else 
		gloop_color_index=0
		
}