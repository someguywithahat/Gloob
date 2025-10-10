

//if wait_counter>wait_next_room
if mouse_check_button_pressed(mb_left)
	room_goto(rm_gameScreen)
	
	
if (keyboard_check_pressed(vk_escape)) {
    game_end();
}

if (keyboard_check_pressed(vk_f11)) {
    window_set_fullscreen(!window_get_fullscreen());
}	


