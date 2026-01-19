// Generate a random number from 1 to 8
my_number = 1
//my_number = irandom_range(1, 9);
my_number = scr_get_weighted_grid_number()
my_shade = c_white
activeNumber=1
wall=0
obs=0

highlighted=0 //Grid number is highlighted when it's an option for gloop to move


trail_rotation = 0
gloop_color_index=5
gloop_color_index_old=1
rainbow_delay=0

tooltip_counter=0


image_speed=0
image_index = my_number - 1

has_powerUP = 0
powerUpImageIndex=0
powerUpxx=0
powerUpyy=0

original_depth=depth

enterX=0
enterY=0
exitX=0
exitY=0
rot_x=0
rot_y=0
rotate=0


//sprite_index=Spr_PU_N1


//if (irandom_range(1,10)=1) then has_powerUP=1 else has_powerUP=0

//// Assign the sprite based on the number
//switch (my_number) {
	
//    case 1: sprite_index = spr_grid1; break;
//    case 2: sprite_index = spr_grid2; break;
//    case 3: sprite_index = spr_grid3; break;
//    case 4: sprite_index = spr_grid4; break;
//    case 5: sprite_index = spr_grid5; break;
//    case 6: sprite_index = spr_grid6; break;
//    case 7: sprite_index = spr_grid7; break;
//    case 8: sprite_index = spr_grid8; break;
//}

