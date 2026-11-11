/*
	Coal, the black slime, asleep in the fishing cave (rm_fishingDown) with a soft glow.
	Sail the boat right up next to him and click him: he wakes up and glows brighter and brighter until the
	whole cave is lit, then gets a surprised look, pulls the light back in and falls back asleep.
	The glow goes into obj_lighting's light map, like the fish and the lighthouse.
*/

//---- Settings ----
color_index = global.BLACK
near_distance = 110   //The boat has to be this close (middle to middle) for a click to wake him
sleep_radius = 45     //Glow while he's asleep
sleep_strength = 0.55
breathe_amount = 0.12 //The sleeping glow breathes in and out with his snoring
wake_frames = 45      //Waking up before he starts to glow
glow_frames = 180     //Glowing brighter and brighter, until the whole cave is lit
hold_frames = 45      //The whole cave stays lit this long
surprised_frames = 80 //Surprised, pulling the light back in
room_radius = 1700    //How big the glow gets (bigger than the cave)
room_fill = 0.85      //At full glow, the whole cave also gets this much light, so every corner is lit

image_speed = 0 //Animated by hand
mask_index = Spr_Slm_Sleep //For clicking
anim = 0
state = "sleep" //"sleep", "wake", "glow", "hold", "surprised"
state_time = 0
glow = 0 //0 asleep, 1 the whole cave lit

set_state = function(new_state)
{
	state = new_state
	state_time = 0
	anim = 0
}

/// Middle of his body (the sprites are 32x32 with a top left origin)
mid_x = function() { return x+16 }
mid_y = function() { return y+20 }

/// Adds his glow to the light map.  Called by obj_lighting while it builds the map
add_lights = function(lighting, strength)
{
	var light_color = lighting.slime_light_color(color_index)
	var ease = glow*glow //Slow to start, then floods the room
	var breathe = (state="sleep") ? 1 + breathe_amount*sin(current_time/700) : 1
	var radius = lerp(sleep_radius, room_radius, ease)*breathe
	lighting.add_light(mid_x(), mid_y(), radius, light_color, strength*lerp(sleep_strength, 1, glow))

	//Bright enough to light every corner of the cave
	if ease>0
	{
		draw_set_color(merge_colour(light_color, c_white, 0.6))
		draw_set_alpha(strength*ease*room_fill)
		draw_rectangle(0, 0, room_width, room_height, false)
		draw_set_alpha(1)
	}
}
