
sleep_counter++

if sleep_counter>sleep_timer{
	sprite_index=s_sleep
	if yawn_counter=0{
		yawn_counter=1
		var snd = audio_play_sound(snd_yawn, 1, false);
		audio_sound_pitch(snd, random_range(0.9, 1.2));
	}
}
	
if sprite_index=s_sleep and (image_index > 50) {
    image_index = 20;
}



if (mouse_x > x - sprite_xoffset && mouse_x < x - sprite_xoffset + sprite_width &&
    mouse_y > y - sprite_yoffset && mouse_y < y - sprite_yoffset + sprite_height) {
    sprite_index=s_idol
	sleep_counter=0
	yawn_counter=0
}