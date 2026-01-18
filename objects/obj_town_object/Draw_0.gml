
//draw_self();


//draw_sprite_ext(Spr_Obs_1x1, 0,100,100,1,flip,0,c_white,1)
sprite_index=sprite
var spr_xx = sprite_get_xoffset(sprite)
var spr_yy = sprite_get_yoffset(sprite)


if shader=0
{
	draw_sprite_ext(sprite, image_index,x-spr_xx,y-spr_yy,flip,1,0,c_white,1)	

}
else
{
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
	draw_sprite_ext(sprite, image_index,x+spr_xx,y+spr_yy,flip,1,0,c_white,1)
		

	// End shader
	shader_reset();
}