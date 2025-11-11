
	// Start shader
	shader_set(shd_palette_shift);

	// Set uniforms
	var u_palette_orig = shader_get_sampler_index(shd_palette_shift, "palette_orig");
	var u_palette_swap_old = shader_get_sampler_index(shd_palette_shift, "palette_swap_old");
	var u_palette_swap_new = shader_get_sampler_index(shd_palette_shift, "palette_swap_new");
	var u_color_count  = shader_get_uniform(shd_palette_shift, "color_count");
	var u_color_merge  = shader_get_uniform(shd_palette_shift, "color_merge");

	// Bind your palette sprites as textures
	texture_set_stage(u_palette_orig, sprite_get_texture(spr_palette_index, 0));
	texture_set_stage(u_palette_swap_old, sprite_get_texture(spr_palette_all, color_array[gloop_color_index]));
	texture_set_stage(u_palette_swap_new, sprite_get_texture(spr_palette_all, color_array[gloop_color_index_mix]));

	// Send color count
	shader_set_uniform_f(u_color_count, 6.0);
	shader_set_uniform_f(u_color_merge, mix_percent);

	// Draw the sprite
	draw_self();

	// End shader
	shader_reset();
