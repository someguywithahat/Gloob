

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
		var gloop_x = irandom_range(1,x_count-2);
		var gloop_y = irandom_range(1,y_count-2);
		
        var xx = gloop_x * spacing;
        var yy = gloop_y * spacing;		
		var gloop_color_index = controller.player_color[i]
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
		
		
		scr_set_slime_color(gloopInst,gloop_color)  //now this is only needed for slime pathway.  Hopefully this can be disabled soon
		show_debug_message(gloopInst.gloop_color);
		inst.sprite_index = scr_get_slime_trail(0)
		inst.depth=gloopInst.depth+2
		gloopInst.current_grid_number=inst
	}
	
	//add powerups
	for (var i = 0; i < number_of_powerups; i++)
	{
		var powerup_x = irandom_range(1,x_count-2);
		var powerup_y = irandom_range(1,y_count-2);
		var gridInst = grid_array[powerup_x,powerup_y]
		gridInst.has_powerUP=irandom_range(1,2)
		//show_debug_message(string(sprite_get_number(spr_PowerUp1)))
		
	}
	
		
	//add obsticals
	for (var i = 0; i < number_of_obstacles; i++)
	{
		var powerup_x = irandom_range(1,x_count-2);
		var powerup_y = irandom_range(1,y_count-2);
		var gridInst = grid_array[powerup_x,powerup_y]
		gridInst.activeNumber=0
		gridInst.obs=1
		gridInst.sprite_index=Spr_Obs_1x1
		//show_debug_message(string(sprite_get_number(spr_PowerUp1)))
		
	}
	
	//for (var i = 0; i<7-number_of_players;i++)
	//{
	//	//instance_create_layer(70+irandom_range(1,10), 600+irandom_range(1,10), "Instances", obj_unusedGloop);
		
	//}
	
	var unused=noone
	for (var i=0;i<8;i++)
	{
		if !(array_contains(controller.player_color,i))
		{
			unused=instance_create_layer(10+irandom_range(1,90), 500+irandom_range(1,230), "Instances", obj_unusedGloop);	
			unused.gloop_color_index=i
			show_debug_message("Color found: " + string(i))
		}
		//show_debug_message("Color found: " + string(i))
	}
		

    return grid_array; // return the 2D array of instances
}






/* TODO - Loop through the code to prevent objects from spawning on eachother.
2 examples of ways to do this:

----------------------------------------

var max_i = array_length(grid_array);
var max_j = array_length(grid_array[0]);

repeat (1000) { // safety loop to prevent infinite searching
    var i = irandom(max_i - 1);
    var j = irandom(max_j - 1);
    if (grid_array[i][j] != 1) {
        show_debug_message("Found free cell: " + string(i) + "," + string(j));
        break; // stop when found
    }
}

----------------------------------------

var available = [];
for (var i = 0; i < array_length(grid_array); i++) {
    for (var j = 0; j < array_length(grid_array[i]); j++) {
        if (grid_array[i][j] != 1) {
            array_push(available, [i, j]);
        }
    }
}

if (array_length(available) > 0) {
    var choice = choose(available);
    var i = choice[0];
    var j = choice[1];
    show_debug_message("Found free cell: " + string(i) + "," + string(j));
}

----------------------------------------





*/


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
			    if (gridNum.activeNumber=1 and gridNum.wall=0 and gridNum.has_powerUP=0) {
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
				gridNum.has_powerUp=0
				gridNum.rotate=0
				gridNum.rot_x=0
				gridNum.rot_y=0
				gridNum.enterX=0
				gridNum.enterY=0
				gridNum.exitX=0
				gridNum.exitY=0
				//show_debug_message("Am I refreshing grid?");
				
			}		
			//show_debug_message("Wall: " + string(gridNum.wall) + " obs: " + string(gridNum.obs))
        }
		
    }
	instance_destroy(obj_gridFlower);
	
}




