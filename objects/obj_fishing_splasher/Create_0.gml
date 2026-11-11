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

//---- Secret (Mallow only): marshmallows (obj_marshmallow) ----
//She follows a marshmallow you drag near her, and eats it if it touches her.  Lure her past the bottom edge of the
//waterfall area and she falls over the falls into the lake.  Click her down there to catch her in the fishing
//minigame (free, not saved).  Caught: she shows up angry in a bowl in a clam on the top right grass, then jumps
//out of it back up into the water
loves_marshmallows = false //Set for Mallow by whoever makes her
lure_range = 200           //A dragged marshmallow this close: she comes after it
lose_range = 260           //Further than this (or let go): she stops
chase_speed = 1.3          //Slow enough to stay just ahead of her
eat_range = 18             //Touching her head: she eats it
happy_frames = 90          //Happy after eating one
waterfall_drop = 160       //Falls this far below the bottom of the waterfall area (same as the fish)
fall_gravity = 0.3
fall_spin_max = 28
fall_spin_change = 7
catch_range = 320          //The boat this close to try to catch her (same as the fish)
trophy_x = 1290            //The clam with her bowl: the bottom middle of the clam, on the top right grass
trophy_y = 232
trophy_open_speed = 2      //Like the trophy clams: Spr_Shell at twice its own speed
trophy_show = 120          //Sits in the bowl looking angry this long before jumping out
trophy_fade = 0.02         //The clam fades away after she's out
trophy_jump_frames = 50
trophy_jump_height = 60
//What the fishing minigame uses for her: stands still in the middle, angry, in white.  Not saved (no_save)
mallow_fish = {
	name: "Mallow", title: "Mallow", sprite: Slm_All_Base_Expressions,
	accel: 0, decel: 0, max_speed: 0, move: FISH_MOVE.STILL,
	start_bar: 0.3, bar_grow: 0.25, bar_shrink: 0.17, light: c_white,
	slime_color: global.WHITE, still_frame: UG_FACE.ANGRY, no_save: true,
}

//---- State ----
state = "dive" //"dive", "peek", "jump".  Mallow also: "chase", "happy", "fall", "sunk", "trophy", "trophy_jump"
fall_vy = 0
fall_angle = 0
fall_spin = 0
fall_land_y = 0
hovered = false
in_range = false
shell_x = trophy_x
shell_y = trophy_y
shell_frame = 0
shell_alpha = 0 //The trophy clam, while it's showing
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
		case "happy": state_length = happy_frames; break
		case "trophy_jump": state_length = trophy_jump_frames; break
	}
}

/// Up in the air, above the water effect (like a jumping fish)
set_depth_above_water = function()
{
	var top_layer = layer_get_id("Instances")
	if top_layer<>-1
		depth = layer_get_depth(top_layer)-1
}

/// The bowl in the trophy clam: how grown it is (0 flat to 1 full size, like obj_clamTrophy) and where its base is
trophy_bowl_size = function()
{
	var last = sprite_get_number(Spr_Shell)-1
	return clamp((shell_frame-7)/(last-7), 0, 1);
}
trophy_bowl_base = function() { return shell_y - 20 + 48*0.3 } //The clam's mouth, like obj_clamTrophy

/// Where she lands jumping out of the trophy bowl: in the water up top, toward the clam's end.  False if nowhere
pick_trophy_target = function()
{
	if !instance_exists(area)
		return false;
	repeat (30)
	{
		var tx = random_range(max(area.bbox_left, area.bbox_right-260)+edge_margin, area.bbox_right-edge_margin)
		var ty = random_range(area.bbox_top+edge_margin, area.bbox_bottom-edge_margin)
		if position_meeting(tx, ty, obj_gloopFishingWall)
			continue
		jump_x1 = tx
		jump_y1 = ty
		return true;
	}
	return false;
}

/// The fishing minigame caught her (obj_fishing_minigame calls this instead of removing her)
caught_in_minigame = function()
{
	set_state("trophy")
	//She jumps back into whichever waterfall area is closest to the clam
	var nearest_area = instance_nearest(shell_x, shell_y, obj_gloopFishingWaterfallTop)
	if nearest_area<>noone
		area = nearest_area
	shell_frame = 0
	shell_alpha = 1
	hovered = false
	set_depth_above_water()
}

//Above the water effect, like a jumping fish
set_depth_above_water()
