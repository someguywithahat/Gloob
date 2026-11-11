//In her own color: asleep, surprised (stuck to the boat), hopping, or heart-eyed (sitting with Gloop)
var spr = Spr_Slm_Sleep
var img = floor(anim)
var draw_y = y
switch (state)
{
	case "stuck":
		spr = Slm_All_Base_Expressions
		img = UG_FACE.ANNOYED //The surprised face
		draw_y = y+2 //The faces sit 2 pixels higher in their sprite
		break
	case "hop":
		spr = Spr_Slm_Move_Jump
		img = min(state_time/hop_frames, 0.999)*sprite_get_number(Spr_Slm_Move_Jump)
		break
	case "sit":
		//Heart eyes for a moment as she lands, then idling
		if state_time<sit_face_time
		{
			spr = Slm_All_Base_Expressions
			img = UG_FACE.LOVE
			draw_y = y+2
		}
		else
		{
			spr = Spr_Slm_Idol
			img = floor(anim) mod sprite_get_number(Spr_Slm_Idol)
		}
		break
}

shader_set(shd_palette_swap)
var u_palette_orig = shader_get_sampler_index(shd_palette_swap, "palette_orig")
var u_palette_swap = shader_get_sampler_index(shd_palette_swap, "palette_swap")
var u_color_count = shader_get_uniform(shd_palette_swap, "color_count")
texture_set_stage(u_palette_orig, sprite_get_texture(spr_palette_index, 0))
texture_set_stage(u_palette_swap, sprite_get_texture(spr_palette_all, color_index))
shader_set_uniform_f(u_color_count, 6.0)
draw_sprite(spr, img, x, draw_y)
shader_reset()
