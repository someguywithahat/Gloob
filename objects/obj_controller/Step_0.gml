//Disable most controls while waiting on user input
if game_over_status>0
{
	if game_over_status=1
	{
		//show_debug_message("game over total score = "+string(total_score))
		game_over_status=2
		if total_score>global.high_scores[9].gscore{
			disable_game_inputs=1
			show_debug_message("New high score")
			
			var score_placement=9
			for(var a=0;a<array_length(global.high_scores);a++)
			{
				if global.high_scores[a].gscore<total_score{
					score_placement=a
					break;
				}
			}
			show_debug_message("score placement: "+string(score_placement))
	
			//disable visuals and create high score object
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
				game_over_object.score_rank=score_placement
				game_over_object.gloop_score=total_score
			}
			else
				game_over_status=10
		}
		total_score=0
	}
	
	
	if game_over_status=10 or game_over_object=noone
	{
		//disable visuals and create high score object
		for (var i = 0; i < array_length(grid_refs); i++) {
		    for (var j = 0; j < array_length(grid_refs[i]); j++) {
		        var inst = grid_refs[i][j];
		        if (instance_exists(inst)) {
		            inst.visible = true;
		        }
		    }
		}
		with obj_gridFlower{
			visible=true	
		}
		game_over_status=20
		if game_over_object <> noone
		{
			instance_destroy(game_over_object)
			game_over_object=noone
		}
		total_score=0
	}
	
}
else 
	disable_game_inputs=0
	
	
//show_debug_message(string(game_over_status))
	
	
if (keyboard_check_pressed(ord("M")))and disable_game_inputs=0 {
    music_playing++
	audio_stop_sound(global.music_current)
	if music_playing=1
		global.music_current=audio_play_sound(snd_track1, 1, true);
	else if music_playing=2
		music_playing=music_playing //nothing happens
	else if music_playing=3
		global.music_current=audio_play_sound(snd_track2, 1, true);	
	else music_playing=0	
}



if (keyboard_check_pressed(vk_escape)) {
    game_end();
}

if (keyboard_check_pressed(vk_f11)) {
    window_set_fullscreen(!window_get_fullscreen());
}

///*
if grid_refs == noone and room == rm_gameScreen{
	grid_refs = scr_setup_grid(rows, cols, spacing, start_x, start_y, number_of_players)
	//target_obj = instance_create_layer(1, 1, "Instances", obj_targeting);

	season_goal = round(grid_size*season_goal_percentage)
	
	

}
//*/

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

if (keyboard_check_pressed(ord("R"))and disable_game_inputs=0 and room == rm_gameScreen)or clicked_restart=1 {


	clicked_restart=-1
	grid_refs=noone
	game_over_status=0
	disable_game_inputs=0
	if game_over_object <> noone
	{
		instance_destroy(game_over_object)
		game_over_object=noone
	}	
	scr_resetGame()
    room_restart()	
	
	/*
	var lay_id = layer_get_id("Background_Winter");
	show_debug_message(string(lay_id) + "layid")
	var back_id = layer_background_get_id(lay_id);
	layer_background_visible(back_id, false);
	*/

}

if ((keyboard_check_pressed(ord("T")) and room <> rm_titleScreen)and disable_game_inputs=0) or clicked_main_menu=1 {
    // code here runs once when F is pressed
	clicked_main_menu=-1
	grid_refs=noone
	game_over_status=0
	disable_game_inputs=0
	if game_over_object <> noone
	{
		instance_destroy(game_over_object)
		game_over_object=noone
	}	
	scr_resetGame()
    room_goto(rm_titleScreen)
}

if ((keyboard_check_pressed(ord("B")) and room = rm_titleScreen)and disable_game_inputs=0) {
    // code here runs once when F is pressed
    room_goto(rm_town)
}

if ((keyboard_check_pressed(ord("V")) and room = rm_titleScreen)and disable_game_inputs=0) {
    // code here runs once when F is pressed
    room_goto(rm_fishingTest)
}


if ((keyboard_check_pressed(ord("L")) and room <> rm_titleScreen) and isNight=0 and disable_game_inputs=0) or clicked_main_menu=1 {

	//scr_refresh_grid(grid_refs)
	show_debug_message("Refreshing Grid")
	isNight=1
}

if isNight=1{
	isNightShader+=0.01	
	if isNightShader>=1{
		isNight=-1
		scr_refresh_grid(grid_refs)
		
		var spawnObs = irandom_range(1,100)
		if spawnObs>95
			scr_setup_add_obstacle(grid_refs,3,3)
		else if spawnObs>=75
			scr_setup_add_obstacle(grid_refs,2,2)
		else if spawnObs>=55
			scr_setup_add_obstacle(grid_refs,1,2)
		else if spawnObs>=35
			scr_setup_add_obstacle(grid_refs,2,1)
		else if spawnObs>=0
			scr_setup_add_obstacle(grid_refs,1,1)
	}
}
if isNight=-1{
	isNightShader-=0.01
	if isNightShader<=0{
		isNight=-1
		isNightShader=0
		isNight=0
	}
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
else if(clicked_characterSelect=1){
	clicked_characterSelect=-1;
	room_goto(rm_characterSelect);
}
else if(clicked_debugRoom=1){
	clicked_debugRoom=-1;
	room_goto(rm_testRoom1);
}
else if(clicked_debugRoom2=1){
	clicked_debugRoom2=-1;
	room_goto(rm_testRoomAnimations);
}
else if(clicked_scoreRoom=1){
	clicked_scoreRoom=-1;
	room_goto(rm_scoreScreen);
}

if clicked_end_day=1
{
	clicked_end_day=-1	
	audio_play_sound(snd_sleep_jingle, 0, false);
	show_debug_message("Refreshing Grid")
	//end day logic all handled by weather controller.  Oops
	with obj_weather_controller
	{
		isNight=1
	}
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

