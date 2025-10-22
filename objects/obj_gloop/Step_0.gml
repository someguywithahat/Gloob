var controller = global.controller;
var controller_current_player = controller.current_player
move_speed = controller.slime_speed


if ismoving==0
	idletime++
	
if idletime>sleeptime and alive=1{
	issleep=1
	sprite_index = s_sleep;	
	image_speed=1
}



if alive=0
{
	sprite_index = s_death;	
	if (image_index >= image_number - 1) {
	    image_speed = 0;        // Stop animation
	    image_index = image_number - 1; // Lock on last frame
	}	
	
}

if isjumping=1{
	//if (image_index >= 11)
	//	image_index=4
	//else if (image_index < 4)
	//	image_index=4
	sprite_index=s_jump
	image_speed = 0; 
	//if debug_int<>scr_get_jump_sprite(gridNumberX,x,gridNumberPrevX,8)
	//{
	//	debug_int=scr_get_jump_sprite(gridNumberX,x,gridNumberPrevX,8)
	//	show_debug_message("next_frame: "+string(debug_int) + " gridNumberX " +string(gridNumberX) + " X " +string(x) + " prevX " + string(gridNumberPrevX))
	//}
	image_index = 4 + scr_get_jump_sprite(gridNumberX,x,gridNumberPrevX,8)
	
} 
//else 
//if ismoving=1 and abs(derX)=1{
//	sprite_index=s_slurp
//	image_speed = 0; 
//	image_index = 3 + scr_get_jump_sprite(gridNumberX,x,gridNumberPrevX,2)
//	if derX=-1
//		image_xscale = -1;
//	else image_xscale = 1;
	
//}


gloop_score_obj.gloop_color_index = gloop_color_index

if sprite_index=s_sleep and (image_index > 50) and issleep=1 {
    image_index = 20;
}
else if sprite_index=s_sleep and (image_index >=61) and issleep=2 {
    sprite_index=s_idol
	image_speed=1
}
else if sprite_index=s_sleep and issleep=2 and (image_index <=53) 
	image_index=54
if sprite_index=s_sleep and (image_index =10) {
	var snd = audio_play_sound(snd_yawn, 1, false);
	audio_sound_pitch(snd, random_range(0.9, 1.2));
}



if player_number <> controller_current_player
	return
if alive=0
	return
//Everything below only runs when it's your turn




//if (mouse_check_button_pressed(mb_left)=fales and ismoving=0) 
if (ismoving=0) 
{
	var targeting = global.obj_targeting
    var mx = mouse_x;  // mouse X position
    var my = mouse_y;  // mouse Y position

    var dx = mx - x;   // horizontal distance from object to mouse
    var dy = my - y;   // vertical distance from object to mouse

	var checkx = x
	var checky = y
	var angle_deg = point_direction(x+16, y+16, mx, my);
	
    // Determine the direction.  
	//Remove checkx and checky
    var direct;
    if (angle_deg >= 337.5 || angle_deg < 22.5) {
		//right
		targeting.grid_x=grid_x+1
		targeting.grid_y=grid_y		
    } else if (angle_deg >= 22.5 && angle_deg < 67.5) {
		//up right
		targeting.grid_x=grid_x+1
		targeting.grid_y=grid_y-1
    } else if (angle_deg >= 67.5 && angle_deg < 112.5) {
		//up
		targeting.grid_x=grid_x
		targeting.grid_y=grid_y-1
    } else if (angle_deg >= 112.5 && angle_deg < 157.5) {
		//up left
		targeting.grid_x=grid_x-1
		targeting.grid_y=grid_y-1
    } else if (angle_deg >= 157.5 && angle_deg < 202.5) {
		//left
		targeting.grid_x=grid_x-1
		targeting.grid_y=grid_y
    } else if (angle_deg >= 202.5 && angle_deg < 247.5) {
		//down left
		targeting.grid_x=grid_x-1
		targeting.grid_y=grid_y+1
    } else if (angle_deg >= 247.5 && angle_deg < 292.5) {
		//down 
		targeting.grid_x=grid_x
		targeting.grid_y=grid_y+1
    } else if (angle_deg >= 292.5 && angle_deg < 337.5) {
		//down right
		targeting.grid_x=grid_x+1
		targeting.grid_y=grid_y+1		
    }	
	
}


if (keyboard_check_pressed(vk_space) and ismoving=0) {

	//ismoving=1
	idletime=0
	sprite_index = Slm_Grn_Jump;	
	image_speed=1
	image_index=0
	y=y-64
	grid_y=grid_y-2
	if image_index>8
		image_speed=0
	//{
	//	sprite_index=Bluep_Idol
	//	ismoving=0
	//}
}

if sprite_index=Slm_Grn_Jump and image_index>12
{
	sprite_index=s_idol
	var squishy = scr_get_grid_id(grid_x, grid_y)
	squishy.activeNumber=0	
}








if (mouse_check_button_pressed(mb_left) and ismoving=0) { // left mouse click
    var mx = mouse_x;  // mouse X position
    var my = mouse_y;  // mouse Y position

    var dx = mx - x;   // horizontal distance from object to mouse
    var dy = my - y;   // vertical distance from object to mouse
    // Calculate the angle from object to mouse in degrees
    var angle_deg = point_direction(x+16, y+16, mx, my);
	
	derX=0
	derY=0




    // Determine the direction.  
	//Remove checkx and checky
    var direct;
    if (angle_deg >= 337.5 || angle_deg < 22.5) {
        //direct = "Right";
		derX=1;
		derY=0;		
    } else if (angle_deg >= 22.5 && angle_deg < 67.5) {
        //direct = "Up-Right";
		derX=1;
		derY=-1;		
    } else if (angle_deg >= 67.5 && angle_deg < 112.5) {
        //direct = "Up";
		derX=0;
		derY=-1;		
    } else if (angle_deg >= 112.5 && angle_deg < 157.5) {
        //direct = "Up-Left";
		derX=-1;
		derY=-1;
    } else if (angle_deg >= 157.5 && angle_deg < 202.5) {
        //direct = "Left";
		derX=-1;
		derY=0;	
    } else if (angle_deg >= 202.5 && angle_deg < 247.5) {
        //direct = "Down-Left";		
		derX=-1;
		derY=+1;
    } else if (angle_deg >= 247.5 && angle_deg < 292.5) {
        //direct = "Down";
		derX=0;
		derY=1;
    } else if (angle_deg >= 292.5 && angle_deg < 337.5) {
        //direct = "Down-Right";
		derX=1;
		derY=1;
    }
	
	//var check_grid_inst = instance_place(checkx, checky, obj_gridNumber);
	var selected_grid = scr_get_grid_id(grid_x+derX, grid_y+derY)
	if selected_grid.wall = 0 and selected_grid.activeNumber=1 
	{
		var to_move = selected_grid.my_number;  // read the variable
	
		//set the target
		next_target_x = grid_x + derX
		next_target_y = grid_y + derY
	
		target_x = grid_x +(derX*to_move)
		target_y = grid_y +(derY*to_move)		
	
		//keep the target in bounds
		if target_x<0 target_x=0
		if target_x>=controller.cols-1 target_x=controller.cols-1
		if target_y<0 target_y=0
		if target_y>=controller.cols-1 target_y=controller.cols-1

		ismoving=1;
		idletime=0
		gridNumberPrevX=x
		gridNumberPrevY=y
		
		if(abs((derX+derY) mod 2) = 0){
			//show_debug_message("x "+string(derX) + " y "+string(derY)+ "   math: ", +string((derX+derX) mod 2))
			sprite_index=s_jump
			//image_index=2
			image_speed=0
			isjumping=1
		}
		else
		{
			sprite_index = s_idol;	
			image_speed=1
		}
		
		//Update the previous slime trail
		scr_set_slime_trail(current_grid_number, derX, derY, prev_derX, prev_derY, 0, gloop_color)
		
	}
	else if selected_grid.activeNumber=0
	{
		sprite_index=s_death 
		alive=0
		scr_end_turn()
	}
	
}



if ismoving=1 {
	
	var next_inst = scr_get_grid_id(grid_x+derX, grid_y+derY)
	
	
	gridNumberX=next_inst.x
	gridNumberY=next_inst.y
	
	
	if isjumping=1{
		sprite_index=s_jump
	}
	
	var gloop_speed =1
	if ((derX+derY) mod 2) = 0
		gloop_speed = scr_get_jump_speed2(scr_get_jump_sprite(gridNumberX,x,gridNumberPrevX,8))*move_speed*0.75
	else
		gloop_speed=move_speed


	// Move X toward target
	if (x < gridNumberX) {
	    x += gloop_speed;
	    if (x > gridNumberX) x = gridNumberX; // prevent overshoot
	}
	if (x > gridNumberX) {
	    x -= gloop_speed;
	    if (x < gridNumberX) x = gridNumberX;
	}

	// Move Y toward target
	if (y < gridNumberY) {
	    y += gloop_speed;
	    if (y > gridNumberY) y = gridNumberY;
	}
	if (y > gridNumberY) {
	    y -= gloop_speed;
	    if (y < gridNumberY) y = gridNumberY;
	}
	
	//part_type_color2(trail_particle, color, color);
	//part_particles_create(ps, x+16 +(8*derX*-1), y+16+(8*derY*-1), trail_particle, 2);
	
	if x==gridNumberX and y==gridNumberY
	{
		prev_derX=derX
		prev_derY=derY
		
		gridNumberPrevX=x
		gridNumberPrevY=y
		
		next_inst.activeNumber=0		
		//next_inst.sprite_index=trail
		
		current_grid_number = next_inst
		

		

		//change to spawn a flower
		scr_spawn_flower(x,y,gloop_color)
		
		grid_x=next_inst.grid_x
		grid_y=next_inst.grid_y
		gloop_score++;
		
		var snd = audio_play_sound(snd_slime_move, 1, false);
		audio_sound_pitch(snd, random_range(0.9, 1.2));
		audio_sound_gain(snd, random_range(0.8, 1.0), 0);
		
		gloop_score_obj.gloop_score++
		
		//scr_draw_score(260,20,100)
		
		if grid_x=target_x and grid_y=target_y
		{
			sprite_index=s_idol
			image_speed=1
			ismoving=0	
			isjumping=0
			idletime=0
			derX=0
			derY=0		
			scr_set_slime_trail(next_inst, derX, derY, prev_derX, prev_derY, 1, gloop_color)
			
			with(obj_gridFlower){
				image_index++	
			}
			
			scr_end_turn()
		}
		else
		{
			scr_set_slime_trail(next_inst, derX, derY, prev_derX, prev_derY, 1, gloop_color)
			next_target_x = grid_x + derX
			next_target_y = grid_y + derY
			
			next_inst = scr_get_grid_id(next_target_x, next_target_y)
			if next_inst.activeNumber=0 or next_inst.wall=1
			{
				sprite_index=s_death 
				image_speed=1
				audio_play_sound(snd_bonk, 1, false);
				alive=0
				ismoving=0
				isjumping=0
				scr_end_turn()
				
			}
		}
		
		
	}

}



