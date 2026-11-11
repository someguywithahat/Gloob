/*
	A seashell in the fishing cave (rm_fishingDown) that glows faintly in its own color.
	Each one is tinted, sized and turned in the room editor (Colour, Scale, Rotation, Image Index).
	The glow takes the tint's hue at full brightness, and lighter shells glow more than darker ones.
	It goes into obj_lighting's light map, like the fish glows.
*/

//---- Settings ----
glow_radius = 26      //At 1x scale (room pixels).  Grows with the shell's scale
glow_strength = 0.45  //0-1, for the lightest shells.  Darker shells glow a bit less
dark_glow = 0.6       //How strong the darkest shells glow, compared to the lightest (0-1)
glow_shimmer = 0.15   //How much the glow gently breathes

image_speed = 0
//On land: just above the room's Assets layer (where the shells used to be), so the paths don't cover them.
//Underwater: just below the fish (the Instances_Underwater layer), so they swim over them and the water ripples them.
//Uses the layers' real depths, so it still works if the room's layers are moved around.
//The dark shells are the underwater ones
underwater_shade = 128 //Shells darker than this (0-255) are underwater
underwater = colour_get_value(image_blend)<underwater_shade
var fish_layer = layer_get_id("Instances_Underwater")
var assets_layer = layer_get_id("Assets")
if underwater and fish_layer<>-1
	depth = layer_get_depth(fish_layer)+1
else if !underwater and assets_layer<>-1
	depth = layer_get_depth(assets_layer)-1

//Glow color: the tint's hue and saturation, as bright as it goes
glow_color = make_colour_hsv(colour_get_hue(image_blend), colour_get_saturation(image_blend), 255)
glow_amount = lerp(dark_glow, 1, colour_get_value(image_blend)/255) //Lighter shade = brighter glow
shimmer_offset = random(1000)

/// Adds this shell's glow to the light map.  Called by obj_lighting while it builds the map
add_lights = function(lighting, strength)
{
	//Middle of the shell, turned and scaled with it (the sprite's origin is its top left corner)
	var dx = (sprite_get_width(sprite_index)/2 - sprite_get_xoffset(sprite_index))*image_xscale
	var dy = (sprite_get_height(sprite_index)/2 - sprite_get_yoffset(sprite_index))*image_yscale
	var cx = x + dx*dcos(image_angle) + dy*dsin(image_angle)
	var cy = y - dx*dsin(image_angle) + dy*dcos(image_angle)

	var shimmer = 1 + glow_shimmer*sin(current_time/700 + shimmer_offset)
	var radius = glow_radius*max(abs(image_xscale), abs(image_yscale))
	lighting.add_light(cx, cy, radius*shimmer, glow_color, strength*glow_strength*glow_amount, spr_effect_glow)
}
