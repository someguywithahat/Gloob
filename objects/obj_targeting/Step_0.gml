


//x = (grid_x*spacing) + offset_x
//y = (grid_y*spacing) + offset_y

if traveling_to_next_gloop =1
{
	var xx = next_gloop.x 
	var yy = next_gloop.y
	move_towards_point(xx,yy,moveSpeed)
	if (point_distance(x, y, xx, yy) < moveSpeed*2) {
    // The objects are within 10 pixels of each other
		//x=xx
		//y=yy
		traveling_to_next_gloop=0
	}
}
else
{
	x = (grid_x*spacing) + offset_x
	y = (grid_y*spacing) + offset_y	
	//show_debug_message(string(grid_x) +" " +string(spacing)+" "+string(offset_x))
	//show_debug_message(string(grid_y) +" " +string(spacing)+" "+string(offset_y))
	show_debug_message(string(x)+" "+string(y))
}