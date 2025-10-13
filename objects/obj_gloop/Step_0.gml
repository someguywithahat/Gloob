

//

var controller = global.controller;
var controller_current_player = controller.current_player



if ismoving==0
	idletime++
	
if idletime>sleeptime and alive=1{
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

gloop_score_obj.parent_sprite = s_idol

if sprite_index=s_sleep and (image_index > 50) {
    image_index = 20;
}
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
		
		sprite_index = s_idol;	
		image_speed=1
		
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
	
	var gridNumberX=next_inst.x
	var gridNumberY=next_inst.y
	

	// Move X toward target
	if (x < gridNumberX) {
	    x += move_speed;
	    if (x > gridNumberX) x = gridNumberX; // prevent overshoot
	}
	if (x > gridNumberX) {
	    x -= move_speed;
	    if (x < gridNumberX) x = gridNumberX;
	}

	// Move Y toward target
	if (y < gridNumberY) {
	    y += move_speed;
	    if (y > gridNumberY) y = gridNumberY;
	}
	if (y > gridNumberY) {
	    y -= move_speed;
	    if (y < gridNumberY) y = gridNumberY;
	}
	
	//part_type_color2(trail_particle, color, color);
	//part_particles_create(ps, x+16 +(8*derX*-1), y+16+(8*derY*-1), trail_particle, 2);
	
	if x==gridNumberX and y==gridNumberY
	{
		prev_derX=derX
		prev_derY=derY
		next_inst.activeNumber=0		
		//next_inst.sprite_index=trail
		
		current_grid_number = next_inst
		

		

		//change to spawn a flower
		scr_spawn_flower(x,y,gloop_color)
		
		grid_x=next_inst.grid_x
		grid_y=next_inst.grid_y
		gloop_score++;
		
		gloop_score_obj.gloop_score++
		
		//scr_draw_score(260,20,100)
		
		if grid_x=target_x and grid_y=target_y
		{
			ismoving=0	
			idletime=0
			derX=0
			derY=0		
			scr_set_slime_trail(next_inst, derX, derY, prev_derX, prev_derY, 1, gloop_color)
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
				alive=0
				ismoving=0
				scr_end_turn()
				
			}
		}
		
		
	}

}



