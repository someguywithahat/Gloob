/*
	Gloop in the trophy room, twice as big like the fish bowls.  Jumps between the shelves (obj_trophy_room
	handles the clicks).  The shelves only catch him on the way down, so he can jump up through them.
*/

//---- Settings ----
draw_scale = 2
grav = 0.45
color_index = global.GREEN //The slime from the boat
max_side_speed = 6

//---- State ----
state = "air" //"air" or "stand"
leaving = false //Jumping off the map: lands on nothing, and is gone once he's off it
vx = 0
vy = 0
target_y = -1 //The shelf he's aiming for (its y), or -1 for whichever one he comes down on
facing = 1
anim = 0
squash = 0
rest = 0 //Steps after landing before the next hop (so holding the button doesn't skip the landing)
land_rest = 8

var room_ctrl = instance_find(obj_trophy_room, 0)
shelf_ys = room_ctrl.shelf_ys
shelf_left = room_ctrl.shelf_left
shelf_right = room_ctrl.shelf_right

play_jump = function()
{
	var snd = audio_play_sound(snd_slime_move, 1, false)
	audio_sound_pitch(snd, random_range(0.9, 1.15))
}

/// Jumps in an arc that comes down on (tx, ty).  rise is how far above the higher end the arc goes
jump_to = function(tx, ty, rise)
{
	var arc_top = min(y, ty) - rise
	vy = -sqrt(2*grav*(y-arc_top))
	var time_up = -vy/grav
	var time_down = sqrt(2*(ty-arc_top)/grav)
	vx = (tx-x)/(time_up+time_down)
	target_y = ty
	state = "air"
	if abs(vx)>0.2
		facing = sign(vx)
	play_jump()
}

/// Jumps toward a spot that isn't a shelf: the higher the click, the higher the jump.  Lands on whatever shelf
jump_toward = function(px, py)
{
	vx = clamp((px-x)/35, -max_side_speed, max_side_speed)
	vy = -clamp(6 + (y-py)/25, 4, 13)
	target_y = -1
	state = "air"
	if abs(vx)>0.2
		facing = sign(vx)
	play_jump()
}

/// Jumps off the map, out the left (side -1) or right (side 1) of the room
leave = function(side)
{
	leaving = true
	target_y = -1
	state = "air"
	vx = side*9
	vy = -9
	facing = side
	play_jump()
}
