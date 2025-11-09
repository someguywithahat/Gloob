//Disable most controls while waiting on user input
if game_over_status>0
	disable_game_inputs=1
else 
	disable_game_inputs=0
	
	
if (keyboard_check_pressed(ord("M")))and disable_game_inputs=0 {
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


if (keyboard_check_pressed(ord("F")))and disable_game_inputs=0 {
    // code here runs once when F is pressed
    if slime_speed<MAXSPEED
		slime_speed+=.5		
}

if (keyboard_check_pressed(ord("S")))and disable_game_inputs=0 {
    // code here runs once when F is pressed
    if slime_speed>MINSPEED
		slime_speed-=.5		
}

if (keyboard_check_pressed(ord("R"))and disable_game_inputs=0 and room == rm_gameScreen) {
    // code here runs once when F is pressed
	grid_refs=noone
	game_over_status=0
    room_restart()	
}

if (keyboard_check_pressed(ord("T")) and room <> rm_titleScreen)and disable_game_inputs=0 {
    // code here runs once when F is pressed
	grid_refs=noone
	game_over_status=0
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
else if(clicked_scoreRoom=1){
	clicked_scoreRoom=-1;
	room_goto(rm_scoreScreen);
}


if (keyboard_check_pressed(ord("P")) and room = rm_gameScreen)and disable_game_inputs=0 {
//if (keyboard_check_pressed(ord("P"))) {
	if isPaused=0
	{
		isPaused=1
		//grid_refs.visible=false
		// Make them all invisible
		for (var i = 0; i < array_length(grid_refs); i++) {
		    for (var j = 0; j < array_length(grid_refs[i]); j++) {
		        var inst = grid_refs[i][j];
		        if (instance_exists(inst)) {
		            inst.visible = false;
		        }
		    }
		}
	}
	else
	{
		isPaused=-1
		// Make them all visible
		for (var i = 0; i < array_length(grid_refs); i++) {
		    for (var j = 0; j < array_length(grid_refs[i]); j++) {
		        var inst = grid_refs[i][j];
		        if (instance_exists(inst)) {
		            inst.visible = true;
		        }
		    }
		}
	}
}



if game_over_status=1{
	for (var i = 0; i < array_length(grid_refs); i++) {
	    for (var j = 0; j < array_length(grid_refs[i]); j++) {
	        var inst = grid_refs[i][j];
	        if (instance_exists(inst)) {
	            inst.visible = false;
	        }
	    }
	}
	with obj_gridFlower{
		visible=false	
	}
	if game_over_object=noone
	{
		game_over_object=instance_create_layer(1, 1, "Instances", obj_controller_high_score);	
		game_over_object.gloop_color_index=player_color[0]
	}
	
}