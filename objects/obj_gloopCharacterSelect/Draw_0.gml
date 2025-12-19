
scr_get_accessory()




clicked_left = scr_draw_menu_item(x-4, y+80,"<",clicked_left)	
clicked_right = scr_draw_menu_item(x+54, y+80,">",clicked_right)	
//scr_draw_menu_item(x-30, y-40, gloop_name,noone)
scr_draw_text(x+(sprite_width/2)+3, y-43, gloop_name,1)


if sprite_index=s_idol 
	accessory_index=sa_idol
else if sprite_index=s_sleep 
	accessory_index=sa_sleep
else if sprite_index=s_roll_R
	accessory_index=sa_roll_R


// Start shader
shader_set(shd_palette_swap);

// Set uniforms
var u_palette_orig = shader_get_sampler_index(shd_palette_swap, "palette_orig");
var u_palette_swap = shader_get_sampler_index(shd_palette_swap, "palette_swap");
var u_color_count  = shader_get_uniform(shd_palette_swap, "color_count");

// Bind your palette sprites as textures
texture_set_stage(u_palette_orig, sprite_get_texture(spr_palette_index, 0));
texture_set_stage(u_palette_swap, sprite_get_texture(spr_palette_all, gloop_color));


// Send color count
shader_set_uniform_f(u_color_count, 6.0);
draw_sprite_ext(sa, 0, x+16, y+80, 1, 1, 0, c_white, 1);

// Draw the sprite
draw_sprite_ext(Spr_PU_N, icon_frame, x-16, y-16, 3, 3, 0, c_white, 1);
draw_self();
if has_accessory>0	
	draw_sprite_ext(accessory_index, image_index, x, y, 2, 2, 0, c_white, 1);

// End shader
shader_reset();
