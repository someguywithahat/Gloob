//if player_count=1{
//	//draw_text_transformed(x, y, "HELLO", 0.5, 0.5, 0);
//	clicked_coop = scr_draw_menu_item(600,440,"Single Player Game",clicked_coop)	
//	//clicked_vs = scr_draw_menu_item(600,490,"VS Game",clicked_vs)
//	clicked_save_defaults = scr_draw_menu_item(600,540,"Save Defaults",clicked_save_defaults)
//}


//if player_count>1{
//	clicked_coop = scr_draw_menu_item(600,440,"COOP Game",clicked_coop)	
//	clicked_vs = scr_draw_menu_item(600,490,"VS Game",clicked_vs)
//	clicked_save_defaults = scr_draw_menu_item(600,540,"Save Defaults",clicked_save_defaults)
//}

//---- Character bio, on a grass sign on the left.  Name along the top, bio underneath ----
if bio_gloop<>noone
{
	var tile = sprite_get_width(Signage)
	var panel_w = (bio_x_tiles+1)*tile
	var panel_h = (bio_y_tiles+1)*tile

	//The sign draws the name in global.fnt_Gloop.  The bio goes underneath it in global.fnt_Gloop_small
	draw_set_font(global.fnt_Gloop)
	var name_h = string_height(bio_gloop.gloop_name)
	var text_x = bio_x + bio_padding
	var text_top = bio_y + 8 + name_h + 8
	var text_w = panel_w - bio_padding*2 - 16 //Room for the scroll bar
	var view_h = bio_y + panel_h - bio_padding - text_top

	//How tall the whole bio is, to see if it needs scrolling
	draw_set_font(global.fnt_Gloop_small)
	var bio = scr_gloop_bio(bio_gloop.gloop_color)
	var line_gap = bio_line_gap/bio_text_scale
	var content_h = string_height_ext(bio, line_gap, text_w/bio_text_scale)*bio_text_scale
	var needs_scroll = content_h>view_h

	//Sign with the name (and a scroll bar when the bio is too long)
	if needs_scroll
		bio_scroll = scr_draw_grass_sign(bio_x, bio_y, bio_gloop.gloop_name, 1, panel_w, panel_h, bio_scroll, view_h/content_h)
	else
		scr_draw_grass_sign(bio_x, bio_y, bio_gloop.gloop_name, 1, panel_w, panel_h)

	//Bio text, clipped to the sign and moved up by the scroll
	var scroll_px = needs_scroll ? bio_scroll*(content_h-view_h) : 0
	var old_scissor = gpu_get_scissor()
	gpu_set_scissor(text_x, text_top, text_w, view_h)
	draw_set_font(global.fnt_Gloop_small)
	draw_set_color(c_black)
	draw_text_ext_transformed(text_x+2, text_top-scroll_px+2, bio, line_gap, text_w/bio_text_scale, bio_text_scale, bio_text_scale, 0)
	draw_set_color(c_white)
	draw_text_ext_transformed(text_x, text_top-scroll_px, bio, line_gap, text_w/bio_text_scale, bio_text_scale, bio_text_scale, 0)
	gpu_set_scissor(old_scissor)
}

//---- Copies of the selected slimes standing on the stumps ----
shader_set(shd_palette_swap)
var u_palette_orig = shader_get_sampler_index(shd_palette_swap, "palette_orig")
var u_palette_swap = shader_get_sampler_index(shd_palette_swap, "palette_swap")
var u_color_count  = shader_get_uniform(shd_palette_swap, "color_count")
texture_set_stage(u_palette_orig, sprite_get_texture(spr_palette_index, 0))
shader_set_uniform_f(u_color_count, 6.0)
for (var i = 0; i < min(array_length(stump_order), array_length(stumps)); i++)
{
	var slime = stump_order[i]
	var copy_x = stumps[i].x + stump_offset_x
	var copy_y = stumps[i].y + stump_offset_y
	texture_set_stage(u_palette_swap, sprite_get_texture(spr_palette_all, slime.gloop_color))
	draw_sprite_ext(Spr_Slm_Idol, floor(stump_frame), copy_x, copy_y, 2, 2, 0, c_white, 1)
	if slime.has_accessory>0
		draw_sprite_ext(slime.sa_idol, floor(stump_frame), copy_x, copy_y, 2, 2, 0, c_white, 1)
}
shader_reset()


//---- Start sign: click it to start the game (needs at least one slime on a stump) ----
var start_box = sign_box(start_sign_x, start_sign_y, start_sign_w, start_sign_h, start_sign_scale)
var can_start = array_length(stump_order)>0
var over_start = point_in_rectangle(mouse_x, mouse_y, start_box[0], start_box[1], start_box[0]+start_box[2], start_box[1]+start_box[3])
scr_draw_sign(start_sign_x, start_sign_y, start_sign_w, start_sign_h, start_sign_scale, 0, 0, 1)
draw_set_font(global.fnt_Gloop)
draw_set_color(c_white)
draw_text(start_box[0] + (start_box[2]-string_width(start_text))/2, start_box[1] + (start_box[3]-string_height(start_text))/2, start_text)
if !can_start
{
	//Nobody picked yet: dimmed
	draw_set_color(c_black)
	draw_set_alpha(0.01)
	draw_rectangle(start_box[0], start_box[1], start_box[0]+start_box[2], start_box[1]+start_box[3], false)
}
else if over_start
{
	//Light up on hover
	draw_set_color(c_white)
	draw_set_alpha(0.2)
	draw_rectangle(start_box[0], start_box[1], start_box[0]+start_box[2], start_box[1]+start_box[3], false)
}
draw_set_alpha(1)
draw_set_color(c_white)


//---- Custom sign, hanging under the Start sign by its chains ----
var custom_x = start_box[0] + (start_box[2] - sign_box(0, 0, custom_sign_w, custom_sign_h, custom_sign_scale)[2])/2
var custom_y = start_box[1] + start_box[3] + custom_sign_gap
var custom_box = sign_box(custom_x, custom_y, custom_sign_w, custom_sign_h, custom_sign_scale)
var over_custom = point_in_rectangle(mouse_x, mouse_y, custom_box[0], custom_box[1], custom_box[0]+custom_box[2], custom_box[1]+custom_box[3])
scr_draw_sign(custom_x, custom_y, custom_sign_w, custom_sign_h, custom_sign_scale, 3, 0, 0)
draw_set_font(global.fnt_Gloop_small)
var custom_scale = 2
var custom_text_w = string_width(custom_text)*custom_scale
var custom_text_h = string_height(custom_text)*custom_scale
draw_text_transformed(custom_box[0] + (custom_box[2]-custom_text_w)/2, custom_box[1] + (custom_box[3]-custom_text_h)/2, custom_text, custom_scale, custom_scale, 0)
if over_custom
{
	draw_set_color(c_white)
	draw_set_alpha(0.2)
	draw_rectangle(custom_box[0], custom_box[1], custom_box[0]+custom_box[2], custom_box[1]+custom_box[3], false)
	draw_set_alpha(1)
}


//---- Clicks ----
if mouse_check_button_pressed(mb_left)
{
	if can_start and over_start
	{
		audio_play_sound(snd_slm_woo, 1, false)
		start_game()
	}
	else if over_custom
		start_custom()
}
