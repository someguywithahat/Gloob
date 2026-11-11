/*
	A fish swimming in a fishing room.  Spawned by scr_fishing_spawn_fish, which calls set_fish with its scr_fish_data row.
	Wanders around, swims away from the boat when it gets close, and stays in the water.
	Click it to try to catch it in the fishing minigame.
*/
fish_data = undefined
light_color = c_white //Glow color in dark rooms (from the fish's scr_fish_data row)

vx = random_range(-1, 1) //Speed
vy = random_range(-0.3, 0.3)
max_speed = 2.5
turn_timer = irandom_range(60, 180) //Steps until it picks a new direction
flee_range = 100 //How close the boat gets before it swims away
flee_push = 0.02 //How hard it swims away
catch_range = 320 //How close the boat has to be to try to catch it (bigger than flee_range, since it swims away up close)
hovered = false //True while the mouse is over it
in_range = false //True while the boat is close enough to catch it
has_ticket = false //True while there's a fishing ticket to spend on it

//---- Jumping: now and then a fish leaps out of the water ----
jump_chance = 1/3600     //Chance each step (about once a minute per fish, so every 10-20 seconds in a room)
jump_frames = 46         //How long it's in the air
jump_height = 34         //How high it goes, in pixels
jump_speed = 1.6         //Swims at least this fast while in the air
jump_tilt = 40           //Nose up on the way up, nose down on the way down, in degrees
jump_grow = 0.25         //Drawn this much bigger at the top of the jump (closer to the camera)
jump_cooldown_min = 600  //Won't jump again for at least this long after landing
jump_sound = snd_slime_move     //Played quietly, low pitched, on take off and landing
jump_volume = 0.35

jumping = false
jump_time = 0
jump_facing = 1
jump_cooldown = irandom(jump_cooldown_min) //So fish spawned together don't wait the same amount
home_layer = layer //Instances_Underwater.  It goes back here when it lands
splashes = [] //{ el, frame } Spr_Ripple splashes on the room's Assets layer (above the underwater effect, so they're not wobbly)

//---- The waterfall (rm_fishingUp): a fish up in the obj_gloopFishingWaterfallTop area that swims off its bottom edge
//falls, tumbling, until it lands in the water below ----
waterfall_drop = 56    //Where it lands: its middle ends up this far below the bottom of the waterfall area
fall_gravity = 0.3
fall_spin_max = 28     //Fastest it spins (degrees a step)
fall_spin_change = 7   //How much the spin can change each step, so it tumbles every which way
falling = false
fall_vy = 0
fall_angle = 0
fall_spin = 0
fall_land_y = 0

/// Splashes play through once, then go away
update_splashes = function()
{
	for (var i = array_length(splashes)-1; i >= 0; i--)
	{
		splashes[i].frame += 0.25
		if splashes[i].frame>=sprite_get_number(Spr_Ripple)
		{
			layer_sprite_destroy(splashes[i].el)
			array_delete(splashes, i, 1)
		}
		else
			layer_sprite_index(splashes[i].el, floor(splashes[i].frame))
	}
}

/// How high off the water it is right now, in pixels
jump_lift = function()
{
	if !jumping
		return 0;
	return jump_height*sin(pi*jump_time/jump_frames);
}

/// A splash on the water, centered at (sx, sy), with a quiet plop
add_splash = function(sx, sy)
{
	var assets_layer = layer_get_id("Assets")
	if assets_layer<>-1
	{
		var half = sprite_get_width(Spr_Ripple)/2
		var el = layer_sprite_create(assets_layer, sx-half, sy-half, Spr_Ripple)
		layer_sprite_speed(el, 0) //Animated by hand in Step
		array_push(splashes, { el: el, frame: 0 })
	}
	var snd = audio_play_sound(jump_sound, 1, false)
	audio_sound_gain(snd, jump_volume, 0)
	audio_sound_pitch(snd, random_range(0.55, 0.75))
}

/// Sets which fish this is (a row from scr_fish_data)
set_fish = function(data)
{
	fish_data = data
	sprite_index = data.sprite
	light_color = data.light
}
