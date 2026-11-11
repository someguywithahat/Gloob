//---- Docking: the slime hops out onto the dock, waits a moment, then off to the next room ----
if dock_state>0
{
	dock_time++
	//The empty boat drifts back and stops
	xx += clamp(-xx, -slow_down*0.5, slow_down*0.5)
	x += xx
	if dock_state=1
	{
		var k = min(1, dock_time/dock_hop_frames)
		slime_x = lerp(hop_x0, hop_x1, k)
		slime_y = lerp(hop_y0, hop_y1, k) - dock_hop_height*4*k*(1-k)
		if k>=1
		{
			dock_state = 2
			dock_time = 0
			audio_play_sound(snd_pop, 1, false)
		}
	}
	else if dock_state=2 and dock_time=dock_wait
		scr_room_goto(dock_room)
	else if dock_state=3 and dock_time>board_wait
	{
		//Back from the trophy room: hop from the dock into the boat
		var k = min(1, (dock_time-board_wait)/dock_hop_frames)
		slime_x = lerp(hop_x0, hop_x1, k)
		slime_y = lerp(hop_y0, hop_y1, k) - dock_hop_height*4*k*(1-k)
		if k>=1
		{
			dock_state = 0
			sprite_index = spr_boat_test
			xx = -0.8 //The jump pushes the boat back from the dock
			dock_armed = false
			audio_play_sound(snd_pop, 1, false)
		}
		else if k>0 and k<=1/dock_hop_frames
		{
			var snd = audio_play_sound(snd_boing, 1, false)
			audio_sound_pitch(snd, 1.1)
		}
	}
	exit
}

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

//Sailed into a dock: hop out
var room_info = scr_fishing_room_info(room)
if !is_undefined(room_info) and variable_struct_exists(room_info, "dock") and !instance_exists(obj_fishing_minigame)
{
	var d = room_info.dock
	var at_dock = bbox_right+max(xx, 0)+4>=d.x1 and bbox_left<d.x2 and bbox_bottom>d.y1 and bbox_top<d.y2
	//Just got back in the boat at the dock: sail away from it before it can dock again
	if !at_dock
		dock_armed = true
	if at_dock and dock_armed
	{
		start_docking(d)
		exit
	}
}

//Bump off the shore, and the top of the waterfall (obj_gloopFishingWaterfallTop: fish only, the boat can't go up there).
//Check each axis on its own so the boat slides along a wall it hits from the side
if place_meeting(x+xx, y, obj_gloopFishingWall) or place_meeting(x+xx, y, obj_gloopFishingWaterfallTop)
	xx*=-0.5
if place_meeting(x, y+yy, obj_gloopFishingWall) or place_meeting(x, y+yy, obj_gloopFishingWaterfallTop)
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
