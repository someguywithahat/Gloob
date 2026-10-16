//Fish sign (animates on its own as this object's sprite)
draw_self()

//Ticket count, lined up with the middle of the sign
var tickets = variable_global_exists("fishing_tickets") ? global.fishing_tickets : 0
if variable_global_exists("fnt_Gloop_small")
	draw_set_font(global.fnt_Gloop_small)
var text = string(tickets)
var text_x = x + sprite_width + text_gap
var text_y = y + (sprite_height - string_height(text))/2
draw_set_color(text_color)
draw_text(text_x, text_y, text)
