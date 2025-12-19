
sleep_counter++
if selected=1
	icon_frame+=0.25
else 
	icon_frame=0



if sleep_counter>sleep_timer and selected=0{
	sprite_index=s_sleep
	if yawn_counter=0{
		yawn_counter=1
		var snd = audio_play_sound(snd_yawn, 1, false);
		audio_sound_pitch(snd, random_range(0.9, 1.2));
		audio_sound_gain(snd, random_range(0.8, 1.0), 0);
	}
}
	
if sprite_index=s_sleep and (image_index > 50) {
    image_index = 20;
}


if (mouse_x > x - sprite_xoffset && mouse_x < x - sprite_xoffset + sprite_width &&
    mouse_y > y - sprite_yoffset && mouse_y < y - sprite_yoffset + sprite_height
	&& mouse_check_button_pressed(mb_left)) 
{
	if selected=0{
	    sprite_index=s_roll_R
		selected=1
		var yay_snd = audio_play_sound(snd_slm_yay, 1, false);	
	}
	else 
	{
	    sprite_index=s_idol
		selected=0
		var confused_snd = audio_play_sound(snd_slm_confused, 1, false);
		audio_sound_pitch(confused_snd, random_range(1, 1.3));
		audio_sound_gain(confused_snd, random_range(0.8, 1.0), 0);			
	}
	sleep_counter=0
	yawn_counter=0
}
else if (mouse_x > x - sprite_xoffset && mouse_x < x - sprite_xoffset + sprite_width &&
    mouse_y > y - sprite_yoffset && mouse_y < y - sprite_yoffset + sprite_height
	&&  selected=0) 
{
    sprite_index=s_idol
	if sleep_counter>5{
		var wake_snd = audio_play_sound(snd_slm_wakeup2, 1, false);
		audio_sound_pitch(wake_snd, random_range(1, 1.3));
		audio_sound_gain(wake_snd, random_range(0.8, 1.0), 0);	
	}
	yawn_counter=0
	sleep_counter=0
}

if clicked_left>0
{
	clicked_left=-1
	if has_accessory=0
		has_accessory=global.MAX_ACCESSORY
	else has_accessory--
}
if clicked_right>0
{
	clicked_right=-1
	if has_accessory=global.MAX_ACCESSORY
		has_accessory=0
	else has_accessory++
}