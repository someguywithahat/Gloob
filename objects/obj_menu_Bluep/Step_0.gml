if (mouse_x > x - sprite_xoffset && mouse_x < x - sprite_xoffset + sprite_width &&
    mouse_y > y - sprite_yoffset && mouse_y < y - sprite_yoffset + sprite_height
	&& mouse_check_button_pressed(mb_left)) 
{
	room_goto(rm_gameScreen)
}