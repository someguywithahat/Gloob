/*
	The lighthouse in the fishing cave (rm_fishingDown).  Its lamp spins two lights around (Spr_Lighthouse's
	two orange lights), and each one shines a beam (spr_effect_glow_Cone) out its side of the room.
	The beams go into obj_lighting's light map, so they light up the dark cave.

	The beams sweep around the room counterclockwise (right, up, left, down), each one following its light
	around the lamp: out to the side when the beam points sideways, higher up when it points up.
	8 frames is one full turn.
*/

//---- Settings ----
beam_length = 520   //How far a beam reaches (room pixels)
beam_width = 1.4    //How wide the beams spread (1 = the cone sprite's own width)
beam_strength = 0.9 //0-1
beam_color = make_colour_rgb(255, 215, 150) //Warm, like the lamp
lamp_glow_radius = 70 //Soft glow around the lamp itself
lamp_glow_strength = 0.8

//Where the lamp is on Spr_Lighthouse (sprite pixels), and how far its lights swing out from the middle
lamp_x = 40.5
lamp_y = 26
lamp_orbit = 8.5
lamp_orbit_up = 3.5 //The lights also go a little up and down as they go around

//Just above the room's Assets layer (where the lighthouse sprite used to be), so the paths don't cover it
var assets_layer = layer_get_id("Assets")
if assets_layer<>-1
	depth = layer_get_depth(assets_layer)-1

cone_length = 127 //spr_effect_glow_Cone: from its origin (the tip) to the far edge

/// Adds the lamp glow and both beams to the light map.  Called by obj_lighting while it builds the map
add_lights = function(lighting, strength)
{
	//The lamp in the room
	var lx = x + (lamp_x - sprite_get_xoffset(sprite_index))*image_xscale
	var ly = y + (lamp_y - sprite_get_yoffset(sprite_index))*image_yscale

	//How far around the lamp has turned, counterclockwise (0 = the first light's beam points right).
	//Frame k of the sprite is k*45 degrees (half a frame back, so the middle of each frame lines up with the art)
	var turn = (image_index-0.5) * 360/image_number

	//Glow on the lamp
	lighting.add_light(lx, ly, lamp_glow_radius, beam_color, strength*lamp_glow_strength)

	//The two lights are opposite each other, so their beams are too
	var stretch = beam_length/cone_length
	for (var i = 0; i < 2; i++)
	{
		var beam_dir = turn + i*180
		//The light on the lamp: out to the side the beam points, and a little up or down
		var bx = lx + dcos(beam_dir)*lamp_orbit*image_xscale
		var by = ly - dsin(beam_dir)*lamp_orbit_up*image_yscale
		//The cone sprite points down (direction 270), so turn it by beam_dir+90 to point it along beam_dir
		draw_sprite_ext(spr_effect_glow_Cone, 0, round(bx), round(by), beam_width, stretch, beam_dir+90,
			beam_color, strength*beam_strength)
	}
}
