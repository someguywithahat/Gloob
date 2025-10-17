if (keyboard_check_pressed(ord("M"))) {
    if (!music_playing) {
        audio_play_sound(snd_background1, 1, true); // play sound, priority 1, loop true
        music_playing = true;
    } else {
        audio_stop_sound(snd_background1); // stop it
        music_playing = false;
    }
}

if (keyboard_check_pressed(vk_escape)) {
    game_end();
}

if (keyboard_check_pressed(vk_f11)) {
    window_set_fullscreen(!window_get_fullscreen());
}


if grid_refs == noone and room == rm_gameScreen{
	target_obj = instance_create_layer(1, 1, "Instances", obj_targeting);
	grid_refs = scr_setup_grid(rows, cols, spacing, start_x, start_y, number_of_players)

}

if (keyboard_check_pressed(ord("F"))) {
    // code here runs once when F is pressed
    if slime_speed<3
		slime_speed+=.5		
}

if (keyboard_check_pressed(ord("S"))) {
    // code here runs once when F is pressed
    if slime_speed>.5
		slime_speed-=.5		
}

