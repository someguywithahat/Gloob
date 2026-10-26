/*
	Night powerup firefly.  Bursts out of the slime, then swoops up to the "left" counter
	in the top right.  When it gets there the points needed for the day go down by 1
	and the slime that got the powerup scores 1.

	Set owner and home_delay right after creating this.
*/
owner=noone //The obj_gloop that got the night powerup
home_delay=20 //Steps of fluttering around before heading to the counter.  Stagger these so they don't all arrive at once
depth=-2002 //Above everything on the board

//Where it flies to: the "N left" counter drawn by obj_controller
target_x=1242 //Middle of the "N left" line on the goal sign (scr_draw_goal_sign at 1130, 0)
target_y=73

//Burst out in a random direction
direction=random(360)
speed=random_range(2,4)
burst_slowdown=0.92 //Speed multiplier per step while bursting out

//Heading home
home_speed=1 //Speeds up as it flies
home_acceleration=0.08
home_max_speed=7
turn_rate=0.05 //How sharply it steers toward the counter.  Grows over time so it always gets there

wiggle=random(360) //Little side to side flutter
image_index=irandom(image_number-1)

//Spr_Firefly is 24x24 with a top left origin
half_size=sprite_get_width(sprite_index)/2
