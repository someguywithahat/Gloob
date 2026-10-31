//Face the way it's sailing.  The sprite has a top left origin, so shift it back over when it's flipped
var draw_x = (facing<0) ? x+sprite_width : x
draw_sprite_ext(sprite_index, image_index, draw_x, y, facing, 1, 0, c_white, image_alpha)

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
