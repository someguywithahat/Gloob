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
	
	//Set inital count of remaining numbers
	remaining_grid=0
	with(obj_gridNumber)
	{
		if wall=0
			other.remaining_grid+=activeNumber
	}
}


if (keyboard_check_pressed(ord("F"))) {
    // code here runs once when F is pressed
    if slime_speed<MAXSPEED
		slime_speed+=.5		
}

if (keyboard_check_pressed(ord("S"))) {
    // code here runs once when F is pressed
    if slime_speed>MINSPEED
		slime_speed-=.5		
}

if (keyboard_check_pressed(ord("R")) and room == rm_gameScreen) {
    // code here runs once when F is pressed
	grid_refs=noone
    room_restart()	
}

if (keyboard_check_pressed(ord("T")) and room <> rm_titleScreen) {
    // code here runs once when F is pressed
	grid_refs=noone
    room_goto(rm_titleScreen)
}

//Menu buttons
if(clicked_quickstart=1){
	clicked_quickstart=-1
	scr_load_settings()
	room_goto(rm_gameScreen)
}
else if(clicked_character_select=1){
	clicked_character_select=-1;
	room_goto(Character_Select);
}
else if(clicked_debugRoom=1){
	clicked_debugRoom=-1;
	room_goto(rm_testRoom1);
}

if (keyboard_check_pressed(ord("P")) and room = rm_gameScreen) {
//if (keyboard_check_pressed(ord("P"))) {
	if isPaused=0
		isPaused=1
	else
	{
		isPaused=-1
	}
}