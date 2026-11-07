//---- Custom game menu.  Same style as the pause menu (scr_pause_menu).  In Draw End so it covers the slimes ----
if !custom_menu_open
	exit

var names = scr_powerup_names()
var icons = scr_powerup_icons()

//Dim everything behind the menu
draw_set_color(c_black)
draw_set_alpha(0.4)
draw_rectangle(0, 0, room_width, room_height, false)
draw_set_alpha(1)

//Sign slides down from the top.  Only take input once it has landed
if custom_menu_y<custom_menu_y_open
	custom_menu_y = min(custom_menu_y+50, custom_menu_y_open)
var ready = custom_menu_y>=custom_menu_y_open
var box = sign_box(0, 0, custom_menu_w, custom_menu_h, custom_menu_scale)
var sx = round((room_width-box[2])/2)
var sy = custom_menu_y
scr_draw_sign(sx, sy, custom_menu_w, custom_menu_h, custom_menu_scale, 10, 0, 4)
var center_x = sx + box[2]/2

draw_set_font(global.fnt_Gloop)
draw_set_color(c_white)
scr_menu_text_centered("Custom Rules", center_x, sy+40)

//---- Power up mix, in two columns.  Each row: icon, name, slider, number ----
var col_x = [sx+60, sx+500]
var row_top = sy+120
var row_h = 46
var icon_w = 44 //Name starts this far after the icon
var slider_dx = 225 //Slider starts this far into the column
var slider_w = 120
var value_dx = slider_dx+slider_w+22
for (var i = 0; i < 9; i++)
{
	var cx = col_x[i div 5]
	var cy = row_top + (i mod 5)*row_h

	//Icon, centered on its visible part (the power up sprites have extra space around them).  Faded when turned off
	var spr = icons[i]
	var icon_mid_x = (sprite_get_bbox_left(spr)+sprite_get_bbox_right(spr))/2 - sprite_get_xoffset(spr)
	var icon_mid_y = (sprite_get_bbox_top(spr)+sprite_get_bbox_bottom(spr))/2 - sprite_get_yoffset(spr)
	var icon_frame = (current_time/150) mod sprite_get_number(spr)
	draw_sprite_ext(spr, icon_frame, cx+16-icon_mid_x, cy-icon_mid_y, 1, 1, 0, c_white, custom_values.pu_weights[i]>0 ? 1 : 0.35)

	custom_values.pu_weights[i] = draw_rule_slider(names[i], "pu"+string(i), custom_values.pu_weights[i],
		cx+icon_w, cx+slider_dx, slider_w, cx+value_dx, cy, ready)
}

//---- Obstacles and power ups each season, side by side ----
var season_y = row_top + 5*row_h + 24
custom_values.obstacles = draw_rule_slider("Obstacles", "obstacles", custom_values.obstacles,
	col_x[0], col_x[0]+slider_dx, slider_w, col_x[0]+value_dx, season_y, ready)
custom_values.powerups = draw_rule_slider("Power-ups", "powerups", custom_values.powerups,
	col_x[1], col_x[1]+slider_dx, slider_w, col_x[1]+value_dx, season_y, ready)

//Let go of a slider
if pause_dragging<>"" and !mouse_check_button(mb_left)
{
	audio_play_sound(snd_slime_move, 1, false)
	pause_dragging = ""
}

//---- Start Game and Cancel ----
var buttons_y = season_y + 48
var start_clicked = scr_menu_button("Start Game", sx+box[2]*0.3, buttons_y, ready)
var cancel_clicked = scr_menu_button("Cancel", sx+box[2]*0.7, buttons_y, ready)

if start_clicked
{
	scr_game_rules_custom(custom_values.pu_weights, custom_values.obstacles, custom_values.powerups)
	custom_menu_open = false
	start_with_team()
}
else if cancel_clicked
	custom_menu_open = false
