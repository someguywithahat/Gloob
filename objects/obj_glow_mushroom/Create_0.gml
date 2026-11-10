/*
	A glowing mushroom in the fishing cave (rm_fishingDown).  Each one glows its own shade, somewhere between
	a medium dark purple and a light blue, and slowly pulses.  The glow comes from the cap.
	It goes into obj_lighting's light map, like the seashells and fish.
*/

//---- Settings ----
glow_radius = 30      //At 1x scale (room pixels).  Grows with the mushroom's scale
glow_strength = 0.6   //0-1
glow_pulse = 0.2      //How much the glow pulses
pulse_speed = random_range(0.6, 1.0) //Each one pulses at its own pace
color_dark = make_colour_rgb(110, 70, 190)  //Medium dark purple
color_light = make_colour_rgb(150, 215, 255) //Light blue
cap_x = 16 //Middle of the cap on Spr_Mushroom_Glow (sprite pixels)
cap_y = 14

image_speed = 0
depth = 199 //Just above the room's Assets layer (where the mushrooms used to be), so the paths don't cover them

glow_color = merge_colour(color_dark, color_light, random(1))
pulse_offset = random(1000)

/// Adds this mushroom's glow to the light map.  Called by obj_lighting while it builds the map
add_lights = function(lighting, strength)
{
	//The cap, turned and scaled with the mushroom
	var dx = (cap_x - sprite_get_xoffset(sprite_index))*image_xscale
	var dy = (cap_y - sprite_get_yoffset(sprite_index))*image_yscale
	var cx = x + dx*dcos(image_angle) + dy*dsin(image_angle)
	var cy = y - dx*dsin(image_angle) + dy*dcos(image_angle)

	var pulse = 1 + glow_pulse*sin(current_time/900*pulse_speed + pulse_offset)
	var radius = glow_radius*max(abs(image_xscale), abs(image_yscale))
	lighting.add_light(cx, cy, radius*pulse, glow_color, strength*glow_strength*(0.85 + 0.15*pulse), spr_effect_glow)
}
