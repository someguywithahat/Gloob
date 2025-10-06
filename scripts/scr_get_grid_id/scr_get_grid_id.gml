function scr_get_grid_id(grid_x,grid_y){
	var controller = global.controller;
	var grid = controller.grid_refs
	
	var max_grid_x = controller.cols
	var max_grid_y = controller.rows
	
	if(0<=grid_x and grid_x<=max_grid_x and 0<=grid_y and grid_y<=max_grid_y)
		return grid[grid_x][grid_y].id
	else
		return noone	
}