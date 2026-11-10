//Face the way it's sailing.  The sprite has a top left origin, so shift it back over when it's flipped
var draw_x = (facing<0) ? x+sprite_width : x
draw_sprite_ext(sprite_index, image_index, draw_x, y, facing, 1, 0, c_white, image_alpha)

//Docking: the slime hopping out onto the dock, then happy on it
if dock_state>0
{
	shader_set(shd_palette_swap)
	var u_palette_orig = shader_get_sampler_index(shd_palette_swap, "palette_orig")
	var u_palette_swap = shader_get_sampler_index(shd_palette_swap, "palette_swap")
	var u_color_count = shader_get_uniform(shd_palette_swap, "color_count")
	texture_set_stage(u_palette_orig, sprite_get_texture(spr_palette_index, 0))
	texture_set_stage(u_palette_swap, sprite_get_texture(spr_palette_all, slime_color))
	shader_set_uniform_f(u_color_count, 6.0)
	//Hopping out onto the dock (1), or back into the boat (3, after waiting on the dock a moment)
	var hop_time = -1
	if dock_state=1
		hop_time = dock_time
	else if dock_state=3 and dock_time>board_wait
		hop_time = dock_time-board_wait
	if hop_time>=0
	{
		var hop_frame = min(hop_time/dock_hop_frames, 0.999)*sprite_get_number(Spr_Slm_Move_Jump)
		draw_sprite(Spr_Slm_Move_Jump, hop_frame, round(slime_x), round(slime_y))
	}
	else
		draw_sprite(Slm_All_Base_Expressions, UG_FACE.HAPPY, round(slime_x), round(slime_y))
	shader_reset()
}

//Fishing ticket used: the ticket sign and the new total, floating up above the boat and fading out
if ticket_popup_timer>0
{
	ticket_popup_timer--
	var shown = 1 - ticket_popup_timer/ticket_popup_time //0 just used, 1 gone
	var popup_alpha = min(ticket_popup_timer/25, 1)
	draw_set_font(global.fnt_Gloop_small)
	var total_text = string(ticket_popup_total)
	var icon_size = sprite_get_width(Spr_Pu_Fish_Sign) //16x16, top left origin
	var gap = 3
	var popup_w = icon_size + gap + string_width(total_text)
	var popup_x = center_x() - popup_w/2
	var popup_y = bbox_top - icon_size - 8 - shown*ticket_popup_rise
	draw_sprite_ext(Spr_Pu_Fish_Sign, current_time/125, popup_x, popup_y, 1, 1, 0, c_white, popup_alpha)
	draw_set_alpha(popup_alpha)
	draw_set_color(c_white)
	draw_text(popup_x + icon_size + gap, popup_y + (icon_size - string_height(total_text))/2, total_text)
	draw_set_alpha(1)
}
