
scr_draw_menu_item(10,10,"Total Point Total: " + string(global.running_score_total),noone)


var gloop_score = global.running_score_total+debugcounter
var gloop_scale = 1.0 + (gloop_score/100)
var gloop_scale2 = 1.0 + (gloop_score/1000)

var parent_sprite = Slm_All_Base_Faceless
var xx = 350
var yy=400

var x_shift = (sprite_get_width(parent_sprite))*(gloop_score/100.0)/2
var y_shift = (sprite_get_height(parent_sprite))*(gloop_score/100.0)/2

var x2_shift = (sprite_get_width(parent_sprite))*(gloop_score/1000.0)/2
var y2_shift = (sprite_get_height(parent_sprite))*(gloop_score/1000.0)/2

if gloop_score<1000{
	gloop_scale2=1
	x2_shift=0
	y2_shift=0
	
}

draw_sprite_ext(parent_sprite, 2, xx-5-x_shift, yy+30-y_shift, gloop_scale, gloop_scale, 0, c_white, 1);
draw_sprite_ext(spr_gloop_smile, 0, xx-5-x2_shift, yy+30-y2_shift, gloop_scale2, gloop_scale2, 0, c_white, 1);
//draw_sprite(spr_gloop_smile, 0, round(xx-5), round(yy+30))




for(i=0;i<array_length(global.high_scores);i++)
{
	var highscore = global.high_scores[i]
	scr_draw_menu_item(600,200+(i*35),highscore.gname,noone)
	scr_draw_menu_item(700,200+(i*35),highscore.gscore,noone)
	
	
	
		// Start shader
	shader_set(shd_palette_swap);

	// Set uniforms
	var u_palette_orig = shader_get_sampler_index(shd_palette_swap, "palette_orig");
	var u_palette_swap = shader_get_sampler_index(shd_palette_swap, "palette_swap");
	var u_color_count  = shader_get_uniform(shd_palette_swap, "color_count");

	// Bind your palette sprites as textures
	texture_set_stage(u_palette_orig, sprite_get_texture(spr_palette_index, 0));
	texture_set_stage(u_palette_swap, sprite_get_texture(spr_palette_all, highscore.gcolor));
	//texture_set_stage(u_palette_orig, sprite_get_texture(spr_palette_index_red, 0));
	//texture_set_stage(u_palette_swap, sprite_get_texture(spr_palette_index, 0));



	// Send color count
	shader_set_uniform_f(u_color_count, 6.0);

	// Draw the sprite
	draw_sprite(Slm_All_Base_Expressions,highscore.gindex,565,200+(i*35))

	// End shader
	shader_reset();
	
}

