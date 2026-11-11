/*
	A slime playing in the water at the top of the waterfall (rm_fishingUp): Mallow (white) and Barry (purple).
	Made by scr_fishing_room_start, inside the obj_gloopFishingWaterfallTop area.
	Dives under, pokes its head up, then leaps out of the water to a new spot and lands with a splash.
	Fish that come near swim away (obj_gloopFish reads scare_range/scare_push), and each splash scares them off harder.
	x, y is the middle of the slime at the water line.
*/

//---- Settings ----
color_index = global.WHITE //Set by whoever makes it
area = noone               //The waterfall area it stays in (set by whoever makes it)
dive_min = 40              //Steps fully under the water (just ripples)
dive_max = 90
peek_min = 40              //Then steps with its head poking out
peek_max = 120
hop_min = 40               //How far each leap goes
hop_max = 130
jump_frames = 44           //How long a leap takes
jump_height = 34
edge_margin = 20           //Stays this far inside the area's edges
scare_range = 80           //Fish this close keep swimming away
scare_push = 0.12
splash_scare_range = 130   //Fish this close to a splash get kicked away
splash_kick = 2.5
splash_sound = snd_slime_move //Played low and quiet, like the fish jumps
splash_volume = 0.45

//---- State ----
state = "dive" //"dive", "peek", "jump"
state_time = 0
state_length = irandom_range(dive_min, dive_max)
anim = random(8)
facing = choose(-1, 1)
jump_x0 = x
jump_y0 = y
jump_x1 = x
jump_y1 = y
splashes = [] //{ el, frame } Spr_Ripple splashes on the Assets layer (above the underwater effect)

/// The middle of the slime (fish use this to keep away)
mid_x = function() { return x }
mid_y = function() { return y }

/// Picks a spot to leap to: in its area, in the water, not too far.  Returns false if it can't find one
pick_target = function()
{
	if !instance_exists(area)
		return false;
	repeat (20)
	{
		var dist = random_range(hop_min, hop_max)
		var dir = random(360)
		var tx = x + lengthdir_x(dist, dir)
		var ty = y + lengthdir_y(dist, dir)*0.5 //Mostly sideways: the water up top is a long strip
		if tx<area.bbox_left+edge_margin or tx>area.bbox_right-edge_margin or ty<area.bbox_top+edge_margin or ty>area.bbox_bottom-edge_margin
			continue
		if position_meeting(tx, ty, obj_gloopFishingWall)
			continue
		jump_x1 = tx
		jump_y1 = ty
		return true;
	}
	return false;
}

/// A splash at (sx, sy) that scares the fish around it
splash = function(sx, sy)
{
	var assets_layer = layer_get_id("Assets")
	if assets_layer<>-1
	{
		var half = sprite_get_width(Spr_Ripple)/2
		var el = layer_sprite_create(assets_layer, sx-half, sy-half, Spr_Ripple)
		layer_sprite_speed(el, 0) //Animated by hand in Step
		array_push(splashes, { el: el, frame: 0 })
	}
	var snd = audio_play_sound(splash_sound, 1, false)
	audio_sound_gain(snd, splash_volume, 0)
	audio_sound_pitch(snd, random_range(0.5, 0.7))

	var range = splash_scare_range
	var kick = splash_kick
	with(obj_gloopFish)
	{
		if falling
			continue
		var fish_x = (bbox_left+bbox_right)/2
		var fish_y = (bbox_top+bbox_bottom)/2
		var dist = point_distance(sx, sy, fish_x, fish_y)
		if dist<range and dist>0
		{
			vx += (fish_x-sx)/dist*kick
			vy += (fish_y-sy)/dist*kick
			turn_timer = max(turn_timer, 45) //Keeps swimming away for a bit
		}
	}
}

set_state = function(new_state)
{
	state = new_state
	state_time = 0
	switch (new_state)
	{
		case "dive": state_length = irandom_range(dive_min, dive_max); break
		case "peek": state_length = irandom_range(peek_min, peek_max); break
		case "jump": state_length = jump_frames; break
	}
}

//Above the water effect, like a jumping fish
var top_layer = layer_get_id("Instances")
if top_layer<>-1
	depth = layer_get_depth(top_layer)-1
