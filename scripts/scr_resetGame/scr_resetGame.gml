function scr_resetGame(){	
	season_goal_percentage=global.controller_default_season_goal_percentage
	season_goal = round(grid_size*season_goal_percentage)
	isPaused=0
	current_player=0
	number_of_players = 1
	total_score=0
	disable_game_inputs=0
	isNight=0
	isNightShader=0
	
	
	clicked_quickstart = -1
	clicked_character_select = -1
	clicked_debugRoom = -1
	clicked_scoreRoom = -1
	clicked_restart=-1
	clicked_main_menu=-1
	clicked_exitGame=-1
	clicked_characterSelect = -1 //remake of character select
	clicked_end_day=-1
	
	//player_color=noone
	//player_accessory=noone
}