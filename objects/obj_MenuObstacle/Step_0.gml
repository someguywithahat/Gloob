var controllerID = global.controller


if (mouse_check_button_pressed(mb_left)) {
    if (position_meeting(mouse_x, mouse_y, id)) {
        if clicked=0{
			image_alpha=1
			clicked=1
			controllerID.settings_obstacles+=3
			
			var grrrr_snd = audio_play_sound(snd_slm_grrrrr, 1, false);
			//Grumble gets lower the more challanging we make it.
			var grrrr_pitch = 1-(controllerID.settings_obstacles/30)			
			audio_sound_pitch(grrrr_snd, grrrr_pitch);
			audio_sound_gain(grrrr_snd, random_range(0.8, 1.0), 0);	
		}
		else{
			image_alpha=.5
			clicked=0		
			controllerID.settings_obstacles-=3	
		}
    }
}