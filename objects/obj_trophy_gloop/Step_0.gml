anim += 8/game_get_speed(gamespeed_fps) //The slime sprites play at 8 frames a second

if state="air"
{
	var prev_x = x
	var prev_y = y
	vy += grav
	x += vx
	y += vy

	//The ends of the shelves are walls, unless he's jumping off the map (or still jumping in)
	if !leaving
	{
		if x<shelf_left and prev_x>=shelf_left
		{
			x = shelf_left
			vx = 0
		}
		else if x>shelf_right and prev_x<=shelf_right
		{
			x = shelf_right
			vx = 0
		}
	}

	//Landing: shelves catch him on the way down (only the one he's aiming for, if he's aiming)
	if !leaving and vy>0 and x>=shelf_left and x<=shelf_right
	{
		for (var i = 0; i < array_length(shelf_ys); i++)
		{
			var shelf_y = shelf_ys[i]
			if prev_y<=shelf_y and y>=shelf_y and (target_y<0 or shelf_y=target_y)
			{
				y = shelf_y
				vx = 0
				vy = 0
				state = "stand"
				squash = 1
				anim = 0
				rest = land_rest
				break
			}
		}
	}

	//Off the map (jumped off, or fell past the end of the shelves)
	if y>room_height+120 or y<-240 or x<-120 or x>room_width+120
		instance_destroy()
}

if rest>0
	rest--

//Which bowl he's standing on (one with its fish caught), and for how long
var on_bowl = noone
if state="stand"
{
	var feet_x = x
	var feet_y = y
	with(obj_trophy_bowl)
	{
		//The bowl's base is the bottom of its sprite's bounding box, sitting on the shelf
		if caught and feet_x>=bbox_left and feet_x<=bbox_right and abs(feet_y-bbox_bottom)<24
			on_bowl = id
	}
}
if on_bowl<>bowl_under
{
	bowl_under = on_bowl
	bowl_time = 0
}
else if on_bowl<>noone
	bowl_time++

//Squish when landing
if squash>0.01
	squash *= 0.85
else
	squash = 0
