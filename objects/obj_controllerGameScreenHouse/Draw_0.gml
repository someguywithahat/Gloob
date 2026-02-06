
if image_index>image_number-1
{
	image_index=image_number-1
	image_speed=0
}

var season_shader=0

//if global.weather<>global.FALL and global.weather<>global.WINTER
//	scr_draw_grass_leaves_area(1120, 100, 14, 30, 1)
scr_draw_grass_leaves_area(1120, 100, 14, 30, 1)

/*
if global.weather=global.FALL
	season_shader=1

// Start shader
shader_set(shd_palette_swap);
// Set uniforms
var u_palette_orig = shader_get_sampler_index(shd_palette_swap, "palette_orig");
var u_palette_swap = shader_get_sampler_index(shd_palette_swap, "palette_swap");
var u_color_count  = shader_get_uniform(shd_palette_swap, "color_count");
// Bind your palette sprites as textures
texture_set_stage(u_palette_orig, sprite_get_texture(spr_palette_seasons_index, 0));
texture_set_stage(u_palette_swap, sprite_get_texture(spr_palette_seasons_all, season_shader));
// Send color count
shader_set_uniform_f(u_color_count, 6.0);
// Draw the sprite
scr_draw_grass_leaves_area(1120, 100, 14, 30, 1)
// End shader
shader_reset();
*/

draw_self()