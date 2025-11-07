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



var gloop = instance_place(x, y, obj_unusedGloop);
if gloop != noone{	
    audio_play_sound(snd_slm_chomp, 1, false);	
	gloop.well_fed+=60
	gloop.speed=0
	instance_destroy()
}