
scr_draw_sign(500,410,340,140,2,0,2,4)
scr_draw_menu_item(560,430,"New High Score!",noone)	
scr_draw_menu_item(560,460,"Enter Initials:",noone)	

scr_draw_menu_item(560,490,initial1,noone)
scr_draw_menu_item(580,490,initial2,noone)
scr_draw_menu_item(600,490,initial3,noone)

scroll_left=scr_draw_menu_item(690,490,"<",scroll_left)
scroll_right=scr_draw_menu_item(750,490,">",scroll_right)
//draw_sprite(Arrow,1,680,490)
//draw_sprite(Arrow,3,740,490)





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

draw_sprite_ext(Spr_Slm_Idol,1,660,560,4,4,0,c_white,1)
draw_sprite(Slm_All_Base_Expressions,gloop_image_index,710,490)

// End shader
shader_reset();