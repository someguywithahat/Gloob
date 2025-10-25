var controllerID = global.controller


if (mouse_check_button_pressed(mb_left)) {
    if (position_meeting(mouse_x, mouse_y, id)) {
        if clicked=0{
			image_alpha=1
			clicked=1
			controllerID.settings_NumberOfPowerUps+=2
			
			var yay_snd = audio_play_sound(snd_slm_yay, 1, false);
			audio_sound_pitch(yay_snd, random_range(1, 1.3));
			audio_sound_gain(yay_snd, random_range(0.8, 1.0), 0);	
		}
		else{
			image_alpha=.5
			clicked=0		
			controllerID.settings_NumberOfPowerUps-=2	
		}
    }
}