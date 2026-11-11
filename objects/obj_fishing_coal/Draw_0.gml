//Asleep, awake (idle while he glows), or surprised
var spr = Spr_Slm_Idol
var img = floor(anim) mod sprite_get_number(Spr_Slm_Idol)
if state="sleep"
{
	spr = Spr_Slm_Sleep
	img = floor(anim)
}
else if state="surprised"
{
	spr = Slm_All_Base_Expressions
	img = UG_FACE.ANNOYED //The surprised face
}

shader_set(shd_palette_swap)
var u_palette_orig = shader_get_sampler_index(shd_palette_swap, "palette_orig")
var u_palette_swap = shader_get_sampler_index(shd_palette_swap, "palette_swap")
var u_color_count = shader_get_uniform(shd_palette_swap, "color_count")
texture_set_stage(u_palette_orig, sprite_get_texture(spr_palette_index, 0))
texture_set_stage(u_palette_swap, sprite_get_texture(spr_palette_all, color_index))
shader_set_uniform_f(u_color_count, 6.0)
draw_sprite(spr, img, x, y)
shader_reset()
