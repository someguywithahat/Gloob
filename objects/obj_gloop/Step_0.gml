var controller = global.controller;
var controller_current_player = controller.current_player
move_speed = controller.slime_speed
gloop_score_obj.gloop_color_index = gloop_color_index



if keyboard_check_pressed(ord("Z"))
{
	var friend_gloop = instance_create_layer(x, y, "Instances", obj_gloop);
	instance_destroy(friend_gloop.gloop_score_obj)
	friend_gloop.gloop_color_index=gloop_color_index
	friend_gloop.current_grid_number=current_grid_number
	friend_gloop.gloop_score_obj=gloop_score_obj
	
	controller.number_of_players++
	controller.player_color[controller.number_of_players-1]=friend_gloop
	friend_gloop.player_number=controller.number_of_players-1
	friend_gloop.grid_x=grid_x
	friend_gloop.grid_y=grid_y
	
}






if player_number <> controller_current_player
	return
if alive=0
	return
//Everything below only runs when it's your turn

//selected_grid=noone
//if selected_grid<>noone show_debug_message("Why here5?" + string(selected_grid.activeNumber))

//if (mouse_check_button_pressed(mb_left)=fales and ismoving=0) 
if (ismoving=0) 
{
	var targeting = global.obj_targeting
	
	var movement_array=[]
	movement_array[0] = scr_get_grid_id(grid_x-1,grid_y-1)
	movement_array[1] = scr_get_grid_id(grid_x,grid_y-1)
	movement_array[2] = scr_get_grid_id(grid_x+1,grid_y-1)
	movement_array[3] = scr_get_grid_id(grid_x-1,grid_y)
	movement_array[4] = scr_get_grid_id(grid_x+1,grid_y)
	movement_array[5] = scr_get_grid_id(grid_x-1,grid_y+1)
	movement_array[6] = scr_get_grid_id(grid_x,grid_y+1)
	movement_array[7] = scr_get_grid_id(grid_x+1,grid_y+1)
	
	
	//var tst_id = scr_get_grid_id(grid_x-3,grid_y)
	//if tst_id<>noone
	//	show_debug_message(string(grid_x-3))
	
	/*jump power*/
	///*
	if powerUp1=5 or powerUp2=5 or powerUp3=5  
	{
		movement_array[8] = scr_get_grid_id(grid_x-2,grid_y-2)
		movement_array[9] = scr_get_grid_id(grid_x,grid_y-2)
		movement_array[10] = scr_get_grid_id(grid_x+2,grid_y-2)
		movement_array[11] = scr_get_grid_id(grid_x-2,grid_y)
		movement_array[12] = scr_get_grid_id(grid_x+2,grid_y)
		movement_array[13] = scr_get_grid_id(grid_x-2,grid_y+2)
		movement_array[14] = scr_get_grid_id(grid_x,grid_y+2)
		movement_array[15] = scr_get_grid_id(grid_x+2,grid_y+2)
	}
	//*/
	for(var a=0;a<array_length(movement_array);a++)
	{
		if movement_array[a]<>noone
		{
			movement_array[a].highlighted=1
			//if a>=8
			//{
			//	movement_array[a].drawMushroom=1
			//}
			
			
			///*
			if movement_array[a].activeNumber>0 then movement_array[a].gloop_color_index=gloop_color_index
			{
				if (mouse_x > movement_array[a].x && mouse_x < movement_array[a].x+movement_array[a].sprite_width &&
				    mouse_y > movement_array[a].y && mouse_y < movement_array[a].y+movement_array[a].sprite_width 
				)	
				{
					targeting.grid_x=movement_array[a].grid_x
					targeting.grid_y=movement_array[a].grid_y
					if (mouse_check_button_pressed(mb_left) and ismoving=0)
					{
						if movement_array[a].grid_x<grid_x
							derX=-1
						else if movement_array[a].grid_x>grid_x
							derX=1
						else
							derX=0
					
						if movement_array[a].grid_y<grid_y
							derY=-1
						else if movement_array[a].grid_y>grid_y
							derY=1
						else
							derY=0
							
						//selected_grid = scr_get_grid_id(grid_x+derX, grid_y+derY)
						selected_grid = scr_get_grid_id(movement_array[a].grid_x, movement_array[a].grid_y)
						//if a>=8
							
						if selected_grid.wall = 0 and selected_grid.activeNumber=1 
							ismoving=1
					}
					//else {
					//	selected_grid=noone
					//}
				}
			}
			//*/
		}
	}
	
	
	/*
		If the slime is moving, we record how far.  Set it's animation
	*/
	if ismoving=1
	{
		//if selected_grid.wall = 0 and selected_grid.activeNumber=1 
		//{

				
			//var to_move = selected_grid.my_number; 
	
			//set the target
			next_target_x = grid_x + derX
			next_target_y = grid_y + derY
	
			target_x = grid_x +(derX*selected_grid.my_number)
			target_y = grid_y +(derY*selected_grid.my_number)		
	
			///*
			//keep the target in bounds
			if target_x<0 target_x=0
			if target_x>=controller.cols-1 target_x=controller.cols-1
			if target_y<0 target_y=0
			if target_y>=controller.cols-1 target_y=controller.cols-1

			//ismoving=1;
			//*/	
		
			idletime=0

			if(abs((derX+derY) mod 2) = 0){
				isjumping=1
			}
			else if selected_grid.my_number<=3 and derY=0
				isslurp=1
			else 
				isrolling=1
				
			with (obj_gridNumber)
			{
			    highlighted=0
			}
			
			//trail variables
			gridNumberPrevX=x
			gridNumberPrevY=y
			//Update the previous slime trail
			current_grid_number.exitX=derX
			current_grid_number.exitY=derY
			scr_set_slime_trail(current_grid_number, derX, derY, prev_derX, prev_derY, 0, gloop_color_index)		
		//}
		/*
		else if selected_grid.activeNumber=0
		{
			if puBonk>0
			{
				puBonk--
				audio_play_sound(snd_bonk, 1, false);
				if powerUp3 =1
					powerUp3=0
				else if powerUp2=1
					powerUp2=0
				else if powerUp1 = 1
					powerUp1=0
				scr_powerup_update(id)
			
				var oops = instance_create_layer(x+16, y, "Instances", obj_effect_dropped_hat);
				if derX<>0
					oops.xx*=derX
				else 
					oops.xx*=0.25
			}
			else {
				audio_play_sound(snd_bonk, 1, false);
				alive=0
			}
			ismoving=0
			isjumping=0
			isrolling=0
			has_targeting_cursor=0
			selected_grid=noone
			scr_end_turn()	
		}//*/
	}
}
	//*/
	
	
	/*
    var mx = mouse_x;  // mouse X position
    var my = mouse_y;  // mouse Y position

    var dx = mx - x;   // horizontal distance from object to mouse
    var dy = my - y;   // vertical distance from object to mouse

	var checkx = x
	var checky = y
	var angle_deg = point_direction(x+16, y+16, mx, my);

    // Determine the direction.  
	//Remove checkx and checky
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
	//*/



if (keyboard_check_pressed(vk_space) and (powerUp1=2 or powerUp2=2 or powerUp3=2) and ismoving=0) {

	if powerUp3=2
		powerUp3=0
	else if powerUp2=2
		powerUp2=0
	else if powerUp1=2
		powerUp1=0
	isteleporting=1
	ismoving=1
	sprite_index=s_teleport
	image_index=0	
}






/*

if (mouse_check_button_pressed(mb_left) and ismoving=0
and mouse_x>controller.start_x+controller.spacing
and mouse_x<controller.start_x+(controller.spacing*(controller.cols-1))
and mouse_y>controller.start_y+controller.spacing
and mouse_y<controller.start_y+(controller.spacing*(controller.rows-1))

) { // left mouse click
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
    if (angle_deg >= 337.5 || angle_deg < 22.5) {
		derX=1;
		derY=0;		
    } else if (angle_deg >= 22.5 && angle_deg < 67.5) {
		derX=1;
		derY=-1;		
    } else if (angle_deg >= 67.5 && angle_deg < 112.5) {
		derX=0;
		derY=-1;		
    } else if (angle_deg >= 112.5 && angle_deg < 157.5) {
		derX=-1;
		derY=-1;
    } else if (angle_deg >= 157.5 && angle_deg < 202.5) {
		derX=-1;
		derY=0;	
    } else if (angle_deg >= 202.5 && angle_deg < 247.5) {
		derX=-1;
		derY=+1;
    } else if (angle_deg >= 247.5 && angle_deg < 292.5) {
		derX=0;
		derY=1;
    } else if (angle_deg >= 292.5 && angle_deg < 337.5) {
		derX=1;
		derY=1;
    }
	
	//var check_grid_inst = instance_place(checkx, checky, obj_gridNumber);
	selected_grid = scr_get_grid_id(grid_x+derX, grid_y+derY)
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
		with (obj_gridNumber)
		{
		    highlighted=0
		}
		idletime=0
		gridNumberPrevX=x
		gridNumberPrevY=y
		
		if(abs((derX+derY) mod 2) = 0){
			//sprite_index=s_jump
			isjumping=1
		}
		else 
			isrolling=1
		
		//Update the previous slime trail
		current_grid_number.exitX=derX
		current_grid_number.exitY=derY
		scr_set_slime_trail(current_grid_number, derX, derY, prev_derX, prev_derY, 0, gloop_color_index)		
	}
	else if selected_grid.activeNumber=0
	{
		if puBonk>0
		{
			puBonk--
			audio_play_sound(snd_bonk, 1, false);
			if powerUp3 =1
				powerUp3=0
			else if powerUp2=1
				powerUp2=0
			else if powerUp1 = 1
				powerUp1=0
			scr_powerup_update(id)
			
			var oops = instance_create_layer(x+16, y, "Instances", obj_effect_dropped_hat);
			if derX<>0
				oops.xx*=derX
			else 
				oops.xx*=0.25
		}
		else {
			audio_play_sound(snd_bonk, 1, false);
			alive=0
		}
		ismoving=0
		isjumping=0
		isrolling=0
		has_targeting_cursor=0
		scr_end_turn()	
	}
}

//*/


if ismoving=1 {
	
	var next_inst = scr_get_grid_id(grid_x+derX, grid_y+derY)
	
	
	gridNumberX=next_inst.x
	gridNumberY=next_inst.y
	

//test_trail_index = scr_get_jump_sprite(gridNumberX,x,gridNumberPrevX,10)

//if round(test_trail_index)=0
//	test_trail_index = scr_get_jump_sprite(gridNumberY,y,gridNumberPrevY,10)
////test_trail_index=test_trail_index/2 
//draw_sprite(Spr_Trl_Corner, test_trail_index,1200,500 )
//draw_sprite(Spr_Trl_End, test_trail_index,1200,540 )
//draw_sprite(Spr_Trl_Mid, test_trail_index,1200,580 )


//if test_trail_index>5
//	draw_sprite(Spr_Trl_End, test_trail_index,1200,400 )
//if test_trail_index<=5
//	draw_sprite(Spr_Trl_Mid, test_trail_index,1200,432 )
//else 
//	draw_sprite(Spr_Trl_Mid, 5,1200,432 )


	

	var trail_index = scr_get_jump_sprite(gridNumberX,x,gridNumberPrevX,10)
	if trail_index>5
		scr_set_slime_trail(next_inst, derX, derY, prev_derX, prev_derY, 1, gloop_color_index)
	
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
	

	
	if x==gridNumberX and y==gridNumberY
	{
		prev_derX=derX
		prev_derY=derY
		
		gridNumberPrevX=x
		gridNumberPrevY=y
		
		next_inst.activeNumber=0		
		if next_inst.has_powerUP>0
		{
			var powerUpCheck=0
			if powerUp1=0 and next_inst.has_powerUP<>4
			{
				powerUp1=next_inst.has_powerUP
				powerUpCheck=1
			}
			else if powerUp2=0 and next_inst.has_powerUP<>4
			{
				powerUp2=next_inst.has_powerUP
				powerUpCheck=2
			}
			else if next_inst.has_powerUP<>4
			{
				powerUp3=next_inst.has_powerUP
				powerUpCheck=3
			}	
			
			if next_inst.has_powerUP=4
			{
				has_crown=1
				var friend_gloop = instance_create_layer(x, y, "Instances", obj_gloop);
				instance_destroy(friend_gloop.gloop_score_obj)
				friend_gloop.gloop_color_index=gloop_color_index
				friend_gloop.current_grid_number=next_inst
				friend_gloop.gloop_score_obj=gloop_score_obj
				friend_gloop.has_accessory=has_accessory
	
				controller.number_of_players++
				controller.player_color[controller.number_of_players-1]=friend_gloop
				friend_gloop.player_number=controller.number_of_players-1
				friend_gloop.grid_x=next_inst.grid_x
				friend_gloop.grid_y=next_inst.grid_y
			}
			
			if next_inst.has_powerUP=2{
				var fairy = instance_create_layer(x+16, y, "Instances", obj_effect_fairy);
				fairy.parent_gloop=id		
				fairy.gloop_powerUp_check = powerUpCheck
				show_debug_message("Picked UP fairy")
			}
			next_inst.has_powerUP=0
			audio_play_sound(snd_slm_chomp, 1, false);	
			
			puBonk=0
			if powerUp1=1
				puBonk+=1
			if powerUp2=1
				puBonk+=1
			if powerUp3=1
				puBonk+=1				
		}
		
		
		current_grid_number.exitX=derX
		current_grid_number.exitY=derY
		current_grid_number = next_inst
		current_grid_number.enterX=derX*-1
		current_grid_number.enterY=derY*-1
		

		

		//change to spawn a flower
		scr_spawn_flower(x,y,gloop_color_index)
		
		grid_x=next_inst.grid_x
		grid_y=next_inst.grid_y
		
		//Add gloop score and remaining grid value
		//controller.remaining_grid--
		controller.season_goal--
		gloop_score_obj.gloop_score++
		
		var snd = audio_play_sound(snd_slime_move, 1, false);
		audio_sound_pitch(snd, random_range(0.9, 1.2));
		audio_sound_gain(snd, random_range(0.8, 1.0), 0);
		
		if isjumping=1{
			var splat = instance_create_layer(x, y, "Instances", obj_effect_splat);
			splat.gloop_color_index = gloop_color_index

		}
		
		scr_set_slime_trail(next_inst, derX, derY, prev_derX, prev_derY, 1, gloop_color_index)
		
		if grid_x=target_x and grid_y=target_y
		{
			sprite_index=s_idol
			image_speed=1
			ismoving=0	
			isjumping=0
			isrolling=0
			isslurp=0
			idletime=0
			has_targeting_cursor=0
			derX=0
			derY=0		
			
			current_grid_number.exitX=derX
			current_grid_number.exitY=derY
			///scr_set_slime_trail(next_inst, derX, derY, prev_derX, prev_derY, 1, gloop_color_index)
			
			with(obj_gridFlower){
				image_index++	
			}
			
			scr_end_turn()
		}
		else
		{
			current_grid_number.exitX=derX
			current_grid_number.exitY=derY
			///scr_set_slime_trail(next_inst, derX, derY, prev_derX, prev_derY, 1, gloop_color_index)
			next_target_x = grid_x + derX
			next_target_y = grid_y + derY
			
			next_inst = scr_get_grid_id(next_target_x, next_target_y)
			if next_inst.activeNumber=0 or next_inst.wall=1 
			{
				if puBonk>0
				{
					puBonk--
					audio_play_sound(snd_bonk, 1, false);
					if powerUp3 =1
						powerUp3=0
					else if powerUp2=1
						powerUp2=0
					else if powerUp1 = 1
						powerUp1=0
					scr_powerup_update(id)
					
					var oops = instance_create_layer(x+16, y, "Instances", obj_effect_dropped_hat);
					if derX<>0
						oops.xx*=derX
					else 
						oops.xx*=0.25						
				}
				else {
					audio_play_sound(snd_bonk, 1, false);
					alive=0
				}
				ismoving=0
				isjumping=0
				isrolling=0
				isslurp=0
				has_targeting_cursor=0
				scr_end_turn()				
			}
		}
	}
}



