

	
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


if has_powerUP=1{
	draw_sprite(Spr_PU_Hat,powerUpImageIndex,x,y)
	powerUpImageIndex=powerUpImageIndex+.2
}
else if has_powerUP=2{
	draw_sprite(Spr_Pu_Tel,powerUpImageIndex,x,y)
	powerUpImageIndex=powerUpImageIndex+.2
}
	


if (mouse_x > x && mouse_x < x+sprite_width &&
    mouse_y > y && mouse_y < y+sprite_width)
{
	tooltip_counter++
	if tooltip_counter>40
	{
		var depthTemp = depth
		depth=-2000000

		if has_powerUP=1
			scr_draw_grass_sign(x-300,y-60, "Ignores one hit",1)
		else if has_powerUP=2
			scr_draw_grass_sign(x-300,y-60, "Press SPACE to teleport",1)
	
	}
	
}
else tooltip_counter=0

