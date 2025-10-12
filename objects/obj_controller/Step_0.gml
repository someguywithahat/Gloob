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

