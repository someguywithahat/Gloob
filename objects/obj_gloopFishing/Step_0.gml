//---- Steering: hold the left mouse button to sail toward the cursor.  Let go to glide to a stop ----
//(No sailing while the fishing minigame is open)
var steering = mouse_check_button(mb_left) and !instance_exists(obj_fishing_minigame)
var dist = point_distance(center_x(), center_y(), mouse_x, mouse_y)
if steering and dist>8
{
	var dir = point_direction(center_x(), center_y(), mouse_x, mouse_y)
	var want_speed = min(max_speed, dist*0.05) //Eases off as it gets to the cursor
	xx += clamp(lengthdir_x(want_speed, dir)-xx, -acceleration, acceleration)
	yy += clamp(lengthdir_y(want_speed, dir)-yy, -acceleration, acceleration)
}
else
{
	xx += clamp(-xx, -slow_down, slow_down)
	yy += clamp(-yy, -slow_down, slow_down)
}

//Bump off the shore.  Check each axis on its own so the boat slides along a wall it hits from the side
if place_meeting(x+xx, y, obj_gloopFishingWall)
	xx*=-0.5
if place_meeting(x, y+yy, obj_gloopFishingWall)
	yy*=-0.5

x+=xx
y+=yy

if abs(xx)>0.3
	facing = sign(xx)


//---- Edges: get close to one with a room beyond it to sail there.  Other edges keep the whole boat on screen ----
//(The cursor can't go past the edge of the screen, so the front of the boat only has to get within exit_distance of it)
var info = scr_fishing_room_info(room)
var has_info = !is_undefined(info)
if has_info and info.left<>noone and bbox_left<exit_distance
	scr_fishing_go(info.left, "right")
else if has_info and info.right<>noone and bbox_right>room_width-exit_distance
	scr_fishing_go(info.right, "left")
else if has_info and info.up<>noone and bbox_top<exit_distance
	scr_fishing_go(info.up, "bottom")
else if has_info and info.down<>noone and bbox_bottom>room_height-exit_distance
	scr_fishing_go(info.down, "top")
else
{
	if bbox_left<0
	{
		x -= bbox_left
		xx = 0
	}
	if bbox_right>room_width
	{
		x -= bbox_right-room_width
		xx = 0
	}
	if bbox_top<0
	{
		y -= bbox_top
		yy = 0
	}
	if bbox_bottom>room_height
	{
		y -= bbox_bottom-room_height
		yy = 0
	}
}
