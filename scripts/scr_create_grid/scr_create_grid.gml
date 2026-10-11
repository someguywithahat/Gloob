

/// @function scr_setup_grid(x_count, y_count, obj_type, spacing, x_offset, y_offset, number_of_players)
/// @description Creates a grid of objects and stores instance references in a 2D array.
/// @param {real} x_count - number of columns
/// @param {real} y_count - number of rows
/// @param {real} spacing - distance between each object
/// @param {real} x_offset - number of columns
/// @param {real} y_offset - number of rows
/// @param {real} number_of_players - number of players

function scr_setup_grid(x_count, y_count, spacing, x_offset, y_offset, number_of_players)
{
	var controller = global.controller;
    var grid_array = array_create(x_count, 0);
	var number_of_powerups = controller.settings_NumberOfPowerUps
	var number_of_obstacles = controller.settings_obstacles
	
	//create targeting object
	target_obj = instance_create_layer(1, 1, "Instances", obj_targeting);
    
    for (var i = 0; i < x_count; i++)
    {
        grid_array[i] = array_create(y_count, noone);
		

        for (var j = 0; j < y_count; j++)
        {
            var xx = i * spacing;
            var yy = j * spacing;

            var inst = instance_create_layer(xx + x_offset, yy + y_offset, "Instances", obj_gridNumber);

            // Store grid coordinates inside the object
            inst.grid_x = i;
            inst.grid_y = j;

            // Store world positions (optional)
            inst.grid_pos_x = xx + x_offset;
            inst.grid_pos_y = yy + y_offset;

			if(i=0 or j=0 or i=x_count-1 or j=x_count-1){
				//inst.activeNumber=0
				inst.my_number=0
				inst.wall=1
				//inst.sprite_index = spr_gridOutline
				//inst.activeNumber=0
				inst.sprite_index=noone
			}
			
            // Store reference in the array
            grid_array[i][j] = inst;			
        }
    }

	//clears out bad save data
	for (var i = 0; i < array_length(controller.player_color); i++) 
		if i>number_of_players
			controller.player_color[i]=-1
			
	//spawns players
	for (var i = 0; i < number_of_players; i++)
	{
		var spawn_cell = scr_find_free_cell(grid_array, false)
		if spawn_cell=noone
			break
		var gloop_x = spawn_cell.grid_x;
		var gloop_y = spawn_cell.grid_y;

        var xx = gloop_x * spacing;
        var yy = gloop_y * spacing;		
		var gloop_color_index = controller.player_color[i]
		var gloop_accessory_index = controller.player_accessory[i]
		var gloop_color = 1
		
		var inst = grid_array[gloop_x,gloop_y]
		inst.activeNumber=false
		
		//inst.sprite_index=Trl_Grn_Under //temporary fix
		
		var gloopInst = instance_create_layer(xx + x_offset, yy + y_offset, "Instances", obj_gloop);
		gloopInst.grid_x=gloop_x
		gloopInst.grid_y=gloop_y
		gloopInst.player_number=i
		gloopInst.gloop_score_obj.player=i
		//gloop_color_index
		
		if 0<=gloop_color_index and gloop_color_index<=7
			gloop_color=gloop_color_index
		else gloop_color=irandom_range(0,7)
		
		inst.gloop_color_index=gloop_color
		gloopInst.has_accessory=gloop_accessory_index
		
		
		scr_set_slime_color(gloopInst,gloop_color)  //now this is only needed for slime pathway.  Hopefully this can be disabled soon
		show_debug_message(gloopInst.gloop_color);
		inst.sprite_index = scr_get_slime_trail(0)
		inst.depth=gloopInst.depth+2
		gloopInst.current_grid_number=inst
		
		if i = 0
			target_obj.next_gloop=gloopInst
	}
	
	
	//add powerups
	for (var i = 0; i < number_of_powerups; i++)
	{
		var gridInst = scr_find_free_cell(grid_array, true)
		if gridInst=noone
			break
		gridInst.has_powerUP=irandom_range(0,8)
	}


	//add obsticals
	for (var i = 0; i < number_of_obstacles; i++)
	{
		var gridInst = scr_find_free_cell(grid_array, false)
		if gridInst=noone
			break
		gridInst.activeNumber=0
		gridInst.obs=1
		gridInst.sprite_index=Spr_Obs_1x1
		//show_debug_message(string(sprite_get_number(spr_PowerUp1)))
		
	}
	

	
	var unused=noone
	for (var i=0;i<8;i++)
	{
		if !(array_contains(controller.player_color,i))
		{
			//1120, 100, 14, 30, 1
			unused=instance_create_layer(1120+irandom_range(1,214), 180+irandom_range(1,400), "Instances", obj_unusedGloop);	
			unused.gloop_color_index=i
			show_debug_message("Color found: " + string(i))
		}
	}
		

    return grid_array; // return the 2D array of instances
}









function scr_setup_add_obstacle(grid_arrays, obstacle_x, obstacle_y)
{
	var obs_sprite = noone
	if obstacle_x = 1 and obstacle_y=1 then obs_sprite=Spr_Obs_1x1
	else if obstacle_x = 2 and obstacle_y=1 then obs_sprite=Spr_Obs_2x1
	else if obstacle_x = 1 and obstacle_y=2 then obs_sprite=Spr_Obs_1x2
	else if obstacle_x = 2 and obstacle_y=2 then obs_sprite=Spr_Obs_2x2
	else if obstacle_x = 3 and obstacle_y=3 then obs_sprite=Spr_Obs_3x3
	else return
	
	var max_i = array_length(grid_arrays);
	var max_j = array_length(grid_arrays[0]);
	var placement_fail=0
	
	var i = 0
	var j = 0

	repeat (10) 
	{
		placement_fail=0
	    i = irandom_range(1,max_i - obstacle_x);
	    j = irandom_range(1,max_j - obstacle_y);
		for(var ii=0;ii<obstacle_x;ii++)
		{
			for(var jj=0;jj<obstacle_y;jj++) 
			{
				var gridNum = grid_arrays[i+ii][j+jj]
			    if (gridNum.activeNumber=1 and gridNum.wall=0 and gridNum.has_powerUP=-1) {
			        show_debug_message("Found free cell: " + string(i+ii) + "," + string(j+jj));
				}
				else{
					placement_fail++
					show_debug_message("Cell full at: " + string(i+ii) + "," + string(j+jj));
				}
			}
	    }
		
		if placement_fail=0
			break
	}	
	
	if placement_fail>0
		return
	
	var gridNum = grid_arrays[i][j]
	
	for(var ii=0;ii<obstacle_x;ii++)
	{
		for(var jj=0;jj<obstacle_y;jj++) 
		{	
			gridNum = grid_arrays[i+ii][j+jj] 
			gridNum.activeNumber=0
			gridNum.obs=1
			gridNum.sprite_index=noone
			//show_debug_message("deactivating: " + string(i+ii) + "," + string(j+jj));
		}
	}
	
	gridNum = grid_arrays[i][j]
	gridNum.sprite_index=obs_sprite
	gridNum.image_index = irandom_range(0, image_number-1)
	//gridNum.image_index = image_number-1
	gridNum.depth--
	
}




function scr_setup_add_pu()
{
	var gridNum = scr_find_free_cell(global.controller.grid_refs, true)
	if gridNum=noone
		return
	gridNum.has_powerUP=irandom_range(0,8)
}


/// @function scr_find_free_cell(grid_array, avoid_powerups)
/// @description Picks a random empty grid space: not a wall, obstacle, player, used space or powerup.
/// @param avoid_powerups - true to also skip spaces touching a powerup (including diagonals)
/// @returns the obj_gridNumber instance, or noone if the board is full
function scr_find_free_cell(grid_array, avoid_powerups)
{
	var max_i = array_length(grid_array);
	var max_j = array_length(grid_array[0]);
	var available = [];

	for (var i = 0; i < max_i; i++)
	{
		for (var j = 0; j < max_j; j++)
		{
			var gridNum = grid_array[i][j]
			if gridNum.wall<>0 or gridNum.obs<>0 or gridNum.activeNumber<>1 or gridNum.has_powerUP<>-1
				continue

			//No player standing here (activeNumber covers this at setup, this covers a refreshed grid)
			var has_player = false
			with(obj_gloop)
				if grid_x=i and grid_y=j
					has_player = true
			if has_player
				continue

			if avoid_powerups
			{
				var next_to_powerup = false
				for (var ii = max(i-1,0); ii <= min(i+1,max_i-1); ii++)
					for (var jj = max(j-1,0); jj <= min(j+1,max_j-1); jj++)
						if grid_array[ii][jj].has_powerUP<>-1
							next_to_powerup = true
				if next_to_powerup
					continue
			}

			array_push(available, gridNum)
		}
	}

	if array_length(available)=0
	{
		show_debug_message("scr_find_free_cell: no free space found")
		return noone
	}
	return available[irandom(array_length(available)-1)]
}



function scr_refresh_grid(grid_arrays)
{
	
	var max_i = array_length(grid_arrays);
	var max_j = array_length(grid_arrays[0]);
	var gridNum = grid_arrays[0][0]
	
    for (var i = 0; i < max_i; i++)
    {
        for (var j = 0; j < max_j; j++)
        {
            
			gridNum = grid_arrays[i][j]
			if (gridNum.wall=0 and gridNum.obs=0) {
				gridNum.activeNumber=1
				gridNum.my_number = scr_get_weighted_grid_number()
				gridNum.sprite_index=Numbers
				gridNum.image_index = gridNum.my_number - 1
				gridNum.image_speed=0
				//gridNum.has_powerUp=-1
				gridNum.rotate=0
				gridNum.rot_x=0
				gridNum.rot_y=0
				gridNum.enterX=0
				gridNum.enterY=0
				gridNum.exitX=0
				gridNum.exitY=0
				gridNum.trail_animating=0
				gridNum.trail_custom=0
				gridNum.trail_angle=0
				gridNum.trail_xscale=1
				
			}		
        }

    }

	//Each slime starts the new day fresh on its current tile, same as scr_setup_grid
	with(obj_gloop)
	{
		prev_derX=0
		prev_derY=0
		var start_inst = grid_arrays[grid_x][grid_y]
		start_inst.activeNumber=false
		start_inst.gloop_color_index=gloop_color_index
		start_inst.sprite_index = scr_get_slime_trail(0)
		start_inst.image_speed=1
		current_grid_number=start_inst
	}
	instance_destroy(obj_gridFlower);
	
}




