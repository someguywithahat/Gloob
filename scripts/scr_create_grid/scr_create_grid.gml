

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
    var grid_array = array_create(x_count, 0);
    
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
				inst.sprite_index = spr_gridOutline
			}
			
            // Store reference in the array
            grid_array[i][j] = inst;
			
			

			
        }
    }

	for (var i = 0; i < number_of_players; i++)
	{
		var gloop_x = irandom_range(1,x_count-2);
		var gloop_y = irandom_range(1,y_count-2);
		
        var xx = gloop_x * spacing;
        var yy = gloop_y * spacing;		
		
		var inst = grid_array[gloop_x,gloop_y]
		inst.activeNumber=false
		inst.sprite_index=Trl_Grn_Under //temporary fix
		var gloopInst = instance_create_layer(xx + x_offset, yy + y_offset, "Instances", obj_gloop);
		gloopInst.grid_x=gloop_x
		gloopInst.grid_y=gloop_y
		gloopInst.player_number=i
		
		
		
		
		scr_set_slime_color(gloopInst,irandom_range(1,8))
		

		
	}


    return grid_array; // return the 2D array of instances
}








