//Eaten: back at its spot after a little while, growing back in
if eaten
{
	respawn_timer--
	if respawn_timer<=0
	{
		eaten = false
		pop = 0
	}
	exit
}
pop = min(1, pop+0.08)

//Pick it up
if !dragging and mouse_check_button_pressed(mb_left) and position_meeting(mouse_x, mouse_y, id) and global.dragging_snack=noone and !instance_exists(obj_fishing_minigame)
{
	dragging = true
	global.dragging_snack = id
	grab_x = mouse_x-x
	grab_y = mouse_y-y
}

if dragging
{
	x = mouse_x-grab_x
	y = mouse_y-grab_y
	//Let go: floats back to its spot
	if !mouse_check_button(mb_left)
	{
		dragging = false
		global.dragging_snack = noone
	}
}
else
{
	x = lerp(x, home_x, return_speed)
	y = lerp(y, home_y, return_speed)
}
