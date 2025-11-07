if locked=1{
	x=mouse_x-16
	y=mouse_y-16
}
	
if !mouse_check_button(mb_left)
	locked=0


if (mouse_check_button_pressed(mb_left)) {
    if (position_meeting(mouse_x, mouse_y, id)) {
        locked=1
    }
}

if (place_meeting(x + 4, y, obj_unusedGloop)) {
    audio_play_sound(snd_slm_chomp, 1, false);	
	instance_destroy()
}