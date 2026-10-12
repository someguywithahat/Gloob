/*
	Leaf powerup.  Lines of bushes grow out from the slime up, down, left and right.
	Each bush turns the trail or obstacle under it back into numbers.

	Set origin_grid_x/origin_grid_y right after creating this.
*/
origin_grid_x=0
origin_grid_y=0

step_delay=4 //Steps between each new bush
max_bushes=3 //Bushes showing per line.  The oldest is removed when a new one is added
step_timer=0

depth=-1999 //Above the trails, below the slime

lines=undefined //Built on the first step, once the origin is set
