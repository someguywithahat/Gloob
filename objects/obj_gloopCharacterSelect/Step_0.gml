
sleep_counter++

if sleep_counter>sleep_timer and selected=0{
	sprite_index=s_sleep
	if yawn_counter=0{
		yawn_counter=1
		var snd = audio_play_sound(snd_yawn, 1, false);
		audio_sound_pitch(snd, random_range(0.9, 1.2));
		//audio_sound_gain(snd, random_range(0.8, 1.0), 0);
	}
}
	
if sprite_index=s_sleep and (image_index > 50) {
    image_index = 20;
}


if (mouse_x > x - sprite_xoffset && mouse_x < x - sprite_xoffset + sprite_width &&
    mouse_y > y - sprite_yoffset && mouse_y < y - sprite_yoffset + sprite_height
	&& mouse_check_button_pressed(mb_left)) 
{
    sprite_index=s_jump
	selected=1
	sleep_counter=0
	yawn_counter=0
}
else if (mouse_x > x - sprite_xoffset && mouse_x < x - sprite_xoffset + sprite_width &&
    mouse_y > y - sprite_yoffset && mouse_y < y - sprite_yoffset + sprite_height
	&&  selected=0) 
{
    sprite_index=s_idol
	yawn_counter=0
	sleep_counter=0
}