
//if activeNumber == 0
//	visible = false;

if has_powerUP>-1 and activeNumber>0 and wall=0
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
	image_speed=1
	if(has_powerUP=global.YELLOW)
		gloop_color_index=global.YELLOW
	else if(has_powerUP=global.BLUE)
		gloop_color_index=global.BLUE
	//else if(has_powerUP=global.RAINBOW)
	//	gloop_color_index=global.BLUE //rainbow
	else if(has_powerUP=global.PURPLE)
		gloop_color_index=global.PURPLE
	else if(has_powerUP=global.RED)
		gloop_color_index=global.RED
	else if(has_powerUP=global.WHITE)
		gloop_color_index=global.WHITE //bubble
	else if(has_powerUP=global.YELLOW)
		gloop_color_index=global.YELLOW
	else if(has_powerUP=global.BLACK)
		gloop_color_index=global.BLACK
	else if(has_powerUP=global.GREEN)
		gloop_color_index=global.GREEN
	//else if gloop_color_index=global.RAINBOW
	//	gloop_color_index=global.BLUE
	//else if(has_powerUP <> 3)
	//	gloop_color_index=global.BLACK
		
}
/*
	global.BLACK=0
	global.BLUE=1
	global.GREEN=2
	global.ORANGE=3
	global.PURPLE=4
	global.RED=5
	global.WHITE=6
	global.YELLOW=7
*/

else if has_powerUP=-1 and activeNumber>0 and wall=0 and highlighted=1
{
	if (mouse_x > x && mouse_x < x+sprite_width &&
		mouse_y > y && mouse_y < y+sprite_width)
		sprite_index=Numbers_Color
	else
		sprite_index=Numbers_Outline
}
else if has_powerUP=-1 and activeNumber>0 and wall=0 and highlighted=0
{
	sprite_index=Numbers
}




if activeNumber=0 and obs=0 and wall=0
{
	rotate=0
	//Straight
	if exitY=0 and enterY=0 and exitX<>0 and enterX<>0
		rotate=90
		
	//Corner
	else if enterX=0 and enterY=-1 and exitX=1 and exitY=0
		rotate=0
	else if enterX=-1 and enterY=0 and exitX=0 and exitY=-1
		rotate=90
	else if enterX=0 and enterY=1 and exitX=-1 and exitY=0
		rotate=180
	else if enterX=1 and enterY=0 and exitX=0 and exitY=1
		rotate=270
	else if exitX=0 and exitY=-1 and enterX=1 and enterY=0
		rotate=0
	else if exitX=-1 and exitY=0 and enterX=0 and enterY=-1
		rotate=90
	else if exitX=0 and exitY=1 and enterX=-1 and enterY=0
		rotate=180
	else if exitX=1 and exitY=0 and enterX=0 and enterY=1
		rotate=270
		
	else if abs(enterX+enterY) mod 2 = 0 and exitX=-1 and exitY=0
		rotate=270
	else if abs(enterX+enterY) mod 2 = 0 and exitX=0 and exitY=-1
		rotate=180
	else if abs(enterX+enterY) mod 2 = 0 and exitX=1 and exitY=0
		rotate=90
		
		
	else if abs(exitX+exitY) mod 2 = 0 and enterX=-1 and enterY=0
		rotate=270
	else if abs(exitX+exitY) mod 2 = 0 and enterX=0 and enterY=-1
		rotate=180
	else if abs(exitX+exitY) mod 2 = 0 and enterX=1 and enterY=0
		rotate=90
	
		
	//else if 
		
		

}