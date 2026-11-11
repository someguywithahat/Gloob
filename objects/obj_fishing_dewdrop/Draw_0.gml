//What he's doing
var spr = Spr_Slm_Idol
var img = floor(anim) mod sprite_get_number(Spr_Slm_Idol)
switch (state)
{
	case "sleep":
		spr = Spr_Slm_Sleep
		img = floor(anim)
		break
	case "open":
		spr = Spr_Slm_Sleep
		img = min(floor(anim), open_last_frame)
		break
	case "drink":
		spr = Spr_Slm_Sleep
		img = open_last_frame //Mouth open, holding still
		break
	case "happy":
		//Idling, with a big happy smile now and then
		if (state_time mod happy_every)<happy_for
		{
			spr = Slm_All_Base_Expressions
			img = UG_FACE.HAPPY
		}
		break
}

//Him, grown from his feet, with a little squish on each gulp
var xs = size*(1 + 0.12*squish)
var ys = size*(1 - 0.12*squish)
shader_set(shd_palette_swap)
var u_palette_orig = shader_get_sampler_index(shd_palette_swap, "palette_orig")
var u_palette_swap = shader_get_sampler_index(shd_palette_swap, "palette_swap")
var u_color_count = shader_get_uniform(shd_palette_swap, "color_count")
texture_set_stage(u_palette_orig, sprite_get_texture(spr_palette_index, 0))
texture_set_stage(u_palette_swap, sprite_get_texture(spr_palette_all, color_index))
shader_set_uniform_f(u_color_count, 6.0)
draw_sprite_ext(spr, img, feet_x-16*xs, feet_y-32*ys, xs, ys, 0, c_white, 1)
shader_reset()
