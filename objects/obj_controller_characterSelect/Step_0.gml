var controller = global.controller;
var controller_current_player = controller.number_of_players



player_count=slime1.selected+slime2.selected+slime3.selected+slime4.selected+slime5.selected+slime6.selected+slime7.selected+slime8.selected



//var w = string_width(label_menu1)
//var h = string_height(label_menu1)
//if (mouse_x > xx_menu1-4 && mouse_x < xx_menu1+w+4 && mouse_y > yy_menu1-4 && mouse_y < yy_menu1+h+4
//	&& mouse_check_button_pressed(mb_left) and player_count>0)
//{

if (clicked_save_defaults=1)
{
	controller.number_of_players=player_count
	clicked_save_defaults=-1
	
	var active_player_count=0

	
	if slime1.selected=1{
		controller.player_color[active_player_count]=slime1.gloop_color
		active_player_count++
	}
	if slime2.selected=1{
		controller.player_color[active_player_count]=slime2.gloop_color
		active_player_count++
	}
	if slime3.selected=1{
		controller.player_color[active_player_count]=slime3.gloop_color
		active_player_count++
	}
	if slime4.selected=1{
		controller.player_color[active_player_count]=slime4.gloop_color
		active_player_count++
	}
	if slime5.selected=1{
		controller.player_color[active_player_count]=slime5.gloop_color
		active_player_count++
	}
	if slime6.selected=1{
		controller.player_color[active_player_count]=slime6.gloop_color
		active_player_count++
	}
	if slime7.selected=1{
		controller.player_color[active_player_count]=slime7.gloop_color
		active_player_count++
	}
	if slime8.selected=1{
		controller.player_color[active_player_count]=slime8.gloop_color
		active_player_count++
	}
	
	
}


if (clicked_coop=1 or clicked_vs=1) and player_count>0{
	controller.number_of_players = player_count
	var active_player_count=0

	
	if slime1.selected=1{
		controller.player_color[active_player_count]=slime1.gloop_color
		active_player_count++
		show_debug_message("slime1")
	}
	if slime2.selected=1{
		controller.player_color[active_player_count]=slime2.gloop_color
		active_player_count++
		show_debug_message("slime2")
	}
	if slime3.selected=1{
		controller.player_color[active_player_count]=slime3.gloop_color
		active_player_count++
		show_debug_message("slime3")
	}
	if slime4.selected=1{
		controller.player_color[active_player_count]=slime4.gloop_color
		active_player_count++
		show_debug_message("slime4")
	}
	if slime5.selected=1{
		controller.player_color[active_player_count]=slime5.gloop_color
		active_player_count++
		show_debug_message("slime5")
	}
	if slime6.selected=1{
		controller.player_color[active_player_count]=slime6.gloop_color
		active_player_count++
		show_debug_message("slime6")
	}
	if slime7.selected=1{
		controller.player_color[active_player_count]=slime7.gloop_color
		active_player_count++
		show_debug_message("slime7")
	}
	if slime8.selected=1{
		controller.player_color[active_player_count]=slime8.gloop_color
		active_player_count++
		show_debug_message("slime8")
	}

	room_goto(rm_gameScreen)
}

//---- Which bio to show: the slime under the mouse, otherwise the one selected most recently ----
var hovered = noone
for (var i = 0; i < array_length(slimes); i++)
{
	var slime = slimes[i]
	if mouse_over_slime(slime)
		hovered = slime
	if slime.selected=1 and was_selected[i]=0
		last_selected = slime
	if slime.selected=0 and last_selected=slime
		last_selected = noone
	was_selected[i] = slime.selected
}

var showing = bio_gloop
var panel_w = (bio_x_tiles+1)*sprite_get_width(Spr_Garden_path)
var panel_h = (bio_y_tiles+1)*sprite_get_width(Spr_Garden_path)
if hovered<>noone
	showing = hovered
else if !point_in_rectangle(mouse_x, mouse_y, bio_x, bio_y, bio_x+panel_w, bio_y+panel_h)
	showing = last_selected //Keep the current bio while the mouse is over the panel, so it can be scrolled
if showing<>bio_gloop
{
	bio_gloop = showing
	bio_scroll = 0
}

//---- Stumps: copies of the selected slimes line up on the stumps, left to right, in the order they were picked ----
//Deselected slimes leave the line (the ones after them slide over)
for (var i = array_length(stump_order)-1; i >= 0; i--)
	if stump_order[i].selected=0
		array_delete(stump_order, i, 1)
//Newly selected slimes join the end
for (var i = 0; i < array_length(slimes); i++)
	if slimes[i].selected=1 and !array_contains(stump_order, slimes[i])
		array_push(stump_order, slimes[i])
stump_frame += sprite_get_speed(Spr_Slm_Idol)/game_get_speed(gamespeed_fps)
