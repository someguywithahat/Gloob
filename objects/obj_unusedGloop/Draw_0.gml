
if well_fed>0{
	well_fed--
	sprite_index=Slm_All_Base_Expressions
	image_speed=0
	image_index=1
}
else if is_angry>60 {
	sprite_index=Slm_All_Base_Expressions
	image_speed=0
	image_index=4
}
else if is_angry>0 {
	sprite_index=Slm_All_Base_Expressions
	image_speed=0
	image_index=2
}
else if is_angry>0 {
	sprite_index=Slm_All_Base_Expressions
	image_speed=0
	image_index=0
}
else if issleep=1 {
	if (image_index > 50)
		image_index = 20;
	sprite_index=Spr_Slm_Sleep
	image_speed=1
}
else 
{
	sprite_index=Spr_Slm_Move_Up_Jump
	image_speed=1	
}


draw_self()



// Start shader
shader_set(shd_palette_swap);

// Set uniforms
var u_palette_orig = shader_get_sampler_index(shd_palette_swap, "palette_orig");
var u_palette_swap = shader_get_sampler_index(shd_palette_swap, "palette_swap");
var u_color_count  = shader_get_uniform(shd_palette_swap, "color_count");

// Bind your palette sprites as textures
texture_set_stage(u_palette_orig, sprite_get_texture(spr_palette_index, 0));
texture_set_stage(u_palette_swap, sprite_get_texture(spr_palette_all, gloop_color_index));
//texture_set_stage(u_palette_orig, sprite_get_texture(spr_palette_index_red, 0));
//texture_set_stage(u_palette_swap, sprite_get_texture(spr_palette_index, 0));



// Send color count
shader_set_uniform_f(u_color_count, 6.0);

// Draw the sprite
draw_self();

// End shader
shader_reset();



