/*
		gloopInst.grid_x=gloop_x
		gloopInst.grid_y=gloop_y
*/
function scr_pu_teleport_random(gloopInst){
	var controller=global.controller
	var grid_array=controller.grid_refs

	var gridinst = scr_find_free_cell(grid_array, false)
	if gridinst=noone
	{
		show_debug_message("no tp location")
		return;
	}

	var i = gridinst.grid_x;
	var j = gridinst.grid_y;
	show_debug_message("Found free cell: " + string(i) + "," + string(j));
	gloopInst.grid_x=i
	gloopInst.grid_y=j

	var xx = i * controller.spacing;
	var yy = j * controller.spacing;
	//xx + x_offset, yy + y_offset
	gloopInst.x = xx+controller.start_x
	gloopInst.y = yy+controller.start_y

	gridinst.activeNumber=false
	//gridinst.gloop_color_index=gloopInst.gloop_color
	gridinst.gloop_color_index=gloopInst.gloop_color_index
	gridinst.sprite_index = scr_get_slime_trail(0)
	gridinst.image_speed=1
	gridinst.trail_custom=0
	gridinst.depth=gloopInst.depth+2

	gloopInst.current_grid_number=gridinst

	//Start fresh on the new space so the next trail isn't based on the move before the teleport
	gloopInst.prev_derX=0
	gloopInst.prev_derY=0
	gloopInst.derX=0
	gloopInst.derY=0
}
