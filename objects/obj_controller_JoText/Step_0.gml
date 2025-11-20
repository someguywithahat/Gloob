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
	
	
	//scr_save_scripts()
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
	
	//for (var i = 0; i < 8; i++){
		
	//}
	
	room_goto(rm_gameScreen)
} 


//w = string_width(label_menu2)
//h = string_height(label_menu2)
//if (mouse_x > xx_menu2-4 && mouse_x < xx_menu2+w+4 && mouse_y > yy_menu2-4 && mouse_y < yy_menu2+h+4
//	&& mouse_check_button_pressed(mb_left) and player_count>0)
//{
//	controller.number_of_players=player_count
//	room_goto(rm_gameScreen)
//} 