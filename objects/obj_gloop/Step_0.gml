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
	if powerUp1=global.RED or powerUp2=global.RED or powerUp3=global.RED 
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
					//A click on a bubble pops it instead of moving
					var clicked_bubble = false
					with(obj_effect_bubble)
						if blocks_click()
							clicked_bubble = true
					if (mouse_check_button_pressed(mb_left) and ismoving=0 and !clicked_bubble)
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
							
							
						selected_grid = scr_get_grid_id(movement_array[a].grid_x, movement_array[a].grid_y)

							
						if selected_grid.wall = 0 and selected_grid.activeNumber=1
						{
							ismoving=1
							//Mushroom jump: selected a space 2 away, hop there first
							is_hopping = (abs(selected_grid.grid_x-grid_x)=2 or abs(selected_grid.grid_y-grid_y)=2)

							//The hop uses up one mushroom
							if is_hopping
							{
								if powerUp3=global.RED
									powerUp3=-1
								else if powerUp2=global.RED
									powerUp2=-1
								else if powerUp1=global.RED
									powerUp1=-1
								audio_play_sound(snd_boing, 1, false)
							}
						}
					}
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
		
			//set the target
			next_target_x = grid_x + derX
			next_target_y = grid_y + derY
	
			target_x = grid_x +(derX*selected_grid.my_number)
			target_y = grid_y +(derY*selected_grid.my_number)

			//Mushroom hop: the move starts from the space 1 further out
			if is_hopping
			{
				target_x+=derX
				target_y+=derY
			}
	
			///*
			//keep the target in bounds
			if target_x<0 target_x=0
			if target_x>=controller.cols-1 target_x=controller.cols-1
			if target_y<0 target_y=0
			if target_y>=controller.cols-1 target_y=controller.cols-1


			idletime=0

			if(abs((derX+derY) mod 2) = 0) or is_hopping{
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

			//Starting fresh (crown slime, new day, after a teleport): this trail starts here.
			//Another slime's trail that ran through this space gets cut and rounded off
			if prev_derX=0 and prev_derY=0
			{
				current_grid_number.enterX=0
				current_grid_number.enterY=0
				scr_trail_fix_neighbors(current_grid_number)
			}

			//A hop leaves the starting trail as it is.  The slime jumps off from the center
			if !is_hopping
				scr_set_slime_trail(current_grid_number, derX, derY, prev_derX, prev_derY, 0, gloop_color_index)

	}
}

if (keyboard_check_pressed(vk_space) and (powerUp1=global.BLUE or powerUp2=global.BLUE or powerUp3=global.BLUE) and ismoving=0) {

	if powerUp3=global.BLUE
		powerUp3=-1
	else if powerUp2=global.BLUE
		powerUp2=-1
	else if powerUp1=global.BLUE
		powerUp1=-1
	isteleporting=1
	ismoving=1
	sprite_index=s_teleport
	image_index=0

	//Clear the move options around the old position.  New ones show up after the teleport finishes
	with (obj_gridNumber)
	{
	    highlighted=0
	}
	var _snd = audio_play_sound(snd_flap, 1, false)
	audio_sound_pitch(_snd, 0.75);
}

//Leaf powerup: Enter sends bushes out in 4 directions that turn trails and obstacles back into numbers
if (keyboard_check_pressed(vk_enter) and (powerUp1=global.GREEN or powerUp2=global.GREEN or powerUp3=global.GREEN) and ismoving=0
	and !instance_exists(obj_effect_grass_burst)) {

	if powerUp3=global.GREEN
		powerUp3=-1
	else if powerUp2=global.GREEN
		powerUp2=-1
	else if powerUp1=global.GREEN
		powerUp1=-1
	//Grass hat stays on only if there's another leaf powerup left
	has_grass = (powerUp1=global.GREEN or powerUp2=global.GREEN or powerUp3=global.GREEN)

	var burst = instance_create_layer(x, y, "Instances", obj_effect_grass_burst)
	burst.origin_grid_x=grid_x
	burst.origin_grid_y=grid_y
	audio_play_sound(snd_effect_leaf_crunch, 1, false)
}








//Teleporting is handled by the teleport animation in the Draw event, not by grid movement
if ismoving=1 and isteleporting=0 {

	var step_size = 1
	if is_hopping
		step_size = 2
	var next_inst = scr_get_grid_id(grid_x+derX*step_size, grid_y+derY*step_size)
	
	
	gridNumberX=next_inst.x
	gridNumberY=next_inst.y
	

	

	var is_sliding = isjumping=0 and isteleporting=0 and (derX<>0 or derY<>0)
	if is_sliding
	{
		//Trail grows into the tile we are sliding onto (Spr_Trl_End)
		//A rainbow slime also redraws trails it slides over
		if next_inst.trail_animating=0 and (next_inst.activeNumber>0 or rainbow_turns>0)
			scr_start_trail_anim(next_inst, Spr_Trl_End, derX, derY, derX, derY, 1)

		//Continuing straight: trail slides out of the tile we are leaving (Spr_Trl_Mid)
		if current_grid_number.trail_animating=0 and current_grid_number.sprite_index=Spr_Trl_Mid
			and current_grid_number.image_index=0 and derX=prev_derX and derY=prev_derY
			current_grid_number.trail_animating=1

		next_inst.gloop_color_index=gloop_color_index
	}

	var trail_index = scr_get_jump_sprite(gridNumberX,x,gridNumberPrevX,10)
	if trail_index>5 and next_inst.trail_animating=0 and !is_hopping
		scr_set_slime_trail(next_inst, derX, derY, prev_derX, prev_derY, 1, gloop_color_index)

	var gloop_speed =1
	if isjumping=1
	{
		//Jump progress uses total distance so straight up/down hops animate too
		var jump_total = abs(gridNumberX-gridNumberPrevX) + abs(gridNumberY-gridNumberPrevY)
		var jump_done = abs(x-gridNumberPrevX) + abs(y-gridNumberPrevY)
		gloop_speed = scr_get_jump_speed2(scr_get_jump_sprite(jump_total,jump_done,0,8))*move_speed*0.75
		if is_hopping
			gloop_speed*=2 //Twice the distance in the same time as a normal jump
	}
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

	//Animate the trails on the tiles we are sliding out of and onto based on how far we've moved
	var trail_progress = (abs(x-gridNumberPrevX) + abs(y-gridNumberPrevY)) / controller.spacing
	scr_update_trail_anim(current_grid_number, trail_progress)
	scr_update_trail_anim(next_inst, trail_progress)


	if x==gridNumberX and y==gridNumberY
	{
		scr_finish_trail_anim(current_grid_number)
		scr_finish_trail_anim(next_inst)

		prev_derX=derX
		prev_derY=derY
		
		gridNumberPrevX=x
		gridNumberPrevY=y

		//A rainbow slime can slide over old trails.  Those spaces don't score again
		var is_new_space = next_inst.activeNumber>0
		next_inst.activeNumber=0
		if next_inst.has_powerUP>=0
		{
			//Crown, bubble, night and fish are used immediately.  They don't take a powerup slot
			var takes_slot = next_inst.has_powerUP<>global.PURPLE
				and next_inst.has_powerUP<>global.WHITE
				and next_inst.has_powerUP<>global.BLACK
				and next_inst.has_powerUP<>global.ORANGE
			var powerUpCheck=0
			if takes_slot and powerUp1=-1
			{
				powerUp1=next_inst.has_powerUP
				powerUpCheck=1
			}
			else if takes_slot and powerUp2=-1
			{
				powerUp2=next_inst.has_powerUP
				powerUpCheck=2
			}
			else if takes_slot
			{
				powerUp3=next_inst.has_powerUP
				powerUpCheck=3
			}	
			
			if next_inst.has_powerUP=global.PURPLE
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
				audio_play_sound(snd_slm_chomp, 1, false);	
			}
			else if next_inst.has_powerUP=global.GREEN
			{
				has_grass=1
				audio_play_sound(snd_slm_chomp, 1, false);
			}
			else if next_inst.has_powerUP=global.BLUE{
				var fairy = instance_create_layer(x+16, y, "Instances", obj_effect_fairy);
				fairy.parent_gloop=id		
				fairy.gloop_powerUp_check = powerUpCheck
				show_debug_message("Picked UP fairy")
				audio_play_sound(snd_slm_chomp, 1, false);	
			}
			else if next_inst.has_powerUP=global.BLACK{
				var nightTimePoints = round(controller.grid_size*0.05)
				controller.season_goal-=nightTimePoints
				gloop_score_obj.gloop_score+=nightTimePoints
				audio_play_sound(snd_yawn, 1, false);
			}
			else if next_inst.has_powerUP=global.WHITE{
				var bubble = instance_create_layer(x+16, y+16, "Instances", obj_effect_bubble);
				bubble.owner=id
				audio_play_sound(snd_slm_chomp, 1, false);
			}
			else if next_inst.has_powerUP=global.RAINBOW{
				scr_rainbow_start(id)
				audio_play_sound(snd_slm_chomp, 1, false);
			}
			else if next_inst.has_powerUP=global.RED{
				var mushroom = instance_create_layer(x, y, "Instances", obj_effect_mushroom);
				mushroom.parent_gloop=id
				audio_play_sound(snd_slm_chomp, 1, false);
			}
			else 
			{
				audio_play_sound(snd_slm_chomp, 1, false);	
			}
			next_inst.has_powerUP=-1
			
			
			puBonk=0
			if powerUp1=global.YELLOW
				puBonk+=1
			if powerUp2=global.YELLOW
				puBonk+=1
			if powerUp3=global.YELLOW
				puBonk+=1				
		}
		
		
		current_grid_number.exitX=derX
		current_grid_number.exitY=derY
		current_grid_number = next_inst
		current_grid_number.enterX=derX*-1
		current_grid_number.enterY=derY*-1
		

		

		//change to spawn a flower
		if is_new_space
			scr_spawn_flower(x,y,gloop_color_index)

		grid_x=next_inst.grid_x
		grid_y=next_inst.grid_y

		//Add gloop score and remaining grid value
		if is_new_space
		{
			controller.season_goal--
			gloop_score_obj.gloop_score++
		}
		
		var snd = audio_play_sound(snd_slime_move, 1, false);
		audio_sound_pitch(snd, random_range(0.9, 1.2));
		audio_sound_gain(snd, random_range(0.8, 1.0), 0);
		
		if isjumping=1{
			var splat = instance_create_layer(x, y, "Instances", obj_effect_splat);
			splat.gloop_color_index = gloop_color_index

		}
		
		scr_set_slime_trail(next_inst, derX, derY, prev_derX, prev_derY, 1, gloop_color_index)

		//Mushroom hop landed.  Straight hops slide the rest of the way, diagonal hops keep jumping
		if is_hopping
		{
			is_hopping=0
			//The hop skipped a space, so the trail isn't joined to where it jumped from
			next_inst.enterX=0
			next_inst.enterY=0
			var hop_from = scr_get_grid_id(grid_x-derX*2, grid_y-derY*2)
			if hop_from<>noone and hop_from.exitX=derX and hop_from.exitY=derY
			{
				hop_from.exitX=0
				hop_from.exitY=0
			}
			if abs((derX+derY) mod 2) = 1
			{
				if grid_x=target_x and grid_y=target_y
				{
					//Stopping where we landed: just a splat spot
					next_inst.sprite_index=scr_get_slime_trail(0)
					next_inst.trail_custom=0
				}
				else
				{
					//Trail starts here and heads out the way we're sliding
					scr_start_trail_anim(next_inst, Trl_Grn_End, -derX, -derY, -derX, -derY, 0)
					next_inst.image_speed=1
					isjumping=0
					if selected_grid.my_number<=3 and derY=0
						isslurp=1
					else
						isrolling=1
				}
			}
		}

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
			
			with(obj_gridFlower){
				image_index++
			}

			scr_rainbow_end_move(id)
			scr_end_turn()
		}
		else
		{
			current_grid_number.exitX=derX
			current_grid_number.exitY=derY
			next_target_x = grid_x + derX
			next_target_y = grid_y + derY
			
			next_inst = scr_get_grid_id(next_target_x, next_target_y)

			//Rainbow slime is invincible: smashes obstacles and slides over old trails
			var rainbow_pass = rainbow_turns>0 and next_inst.wall=0
			if rainbow_pass and next_inst.obs=1
			{
				scr_remove_obstacle(next_inst)
				audio_play_sound(snd_bonk, 1, false);
			}

			if (next_inst.activeNumber=0 or next_inst.wall=1) and !rainbow_pass
			{
				if rainbow_turns>0
				{
					//Rainbow slime hit the edge of the map: just stop
				}
				else if puBonk>0
				{
					puBonk--
					audio_play_sound(snd_bonk, 1, false);
					if powerUp3 =global.YELLOW
						powerUp3=-1
					else if powerUp2=global.YELLOW
						powerUp2=-1
					else if powerUp1 = global.YELLOW
						powerUp1=-1
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
				derX=0
				derY=0
				//Stopped here, so the trail doesn't go on to the space it bonked into
				current_grid_number.exitX=0
				current_grid_number.exitY=0
				scr_rainbow_end_move(id)
				scr_end_turn()
			}
		}

		//Rainbow slid over an old trail.  The trail it cut across gets rounded ends
		if !is_new_space
			scr_trail_fix_neighbors(current_grid_number)
	}
}



