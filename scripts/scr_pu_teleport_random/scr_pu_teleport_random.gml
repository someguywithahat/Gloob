/*
		gloopInst.grid_x=gloop_x
		gloopInst.grid_y=gloop_y
*/
function scr_pu_teleport_random(gloopInst){
	var controller=global.controller
	var grid_array=controller.grid_refs

	var available = [];
	for (var i = 0; i < array_length(grid_array); i++) {
	    for (var j = 0; j < array_length(grid_array[i]); j++) {
			var inst = grid_array[i][j]
	        if (inst.activeNumber=1 and inst.wall=0 and inst.has_powerUP=0) {
	            array_push(available, [i, j]);
	        }
	    }
	}

	if (array_length(available) > 0) {
		var random_space = irandom_range(0,array_length(available))
//	    var choice = choose(available);
		var choice = available[random_space];
	    var i = choice[0];
	    var j = choice[1];
	    show_debug_message("Found free cell: " + string(i) + "," + string(j));
		gloopInst.grid_x=i
		gloopInst.grid_y=j
		
		var xx = i * controller.spacing;
        var yy = j * controller.spacing;	
		//xx + x_offset, yy + y_offset
		gloopInst.x = xx+controller.start_x
		gloopInst.y = yy+controller.start_y
		
		var gridinst = grid_array[i,j]
		gridinst.activeNumber=false	
		//gridinst.gloop_color_index=gloopInst.gloop_color
		gridinst.gloop_color_index=gloopInst.gloop_color_index
		gridinst.sprite_index = scr_get_slime_trail(0)
		gridinst.depth=gloopInst.depth+2
		
		
	}
	else
		show_debug_message("no tp location")
}