function scr_save_settings(){

var controller = global.controller;

var controller_player_count = controller.number_of_players
//var controller_powers = controller.settings_NumberOfPowerUps
var controller_obstacles = controller.settings_obstacles

var cGloop0 = controller.player_color[0]
var cGloop1 = controller.player_color[1]
var cGloop2 = controller.player_color[2]
var cGloop3 = controller.player_color[3]
var cGloop4 = controller.player_color[4]
var cGloop5 = controller.player_color[5]
var cGloop6 = controller.player_color[6]
var cGloop7 = controller.player_color[7]
var cGloop8 = controller.player_color[8]
var cGloop9 = controller.player_color[9]

// obj_controller: Save Game
ini_open("save.ini");


ini_write_real("DefaultSettings", "controller_player_count", controller_player_count);
//ini_write_real("DefaultSettings", "controller_powers", controller_powers);
ini_write_real("DefaultSettings", "controller_obstacles", controller_obstacles);

ini_write_real("DefaultSettings", "cGloop0", cGloop0);
ini_write_real("DefaultSettings", "cGloop1", cGloop1);
ini_write_real("DefaultSettings", "cGloop2", cGloop2);
ini_write_real("DefaultSettings", "cGloop3", cGloop3);
ini_write_real("DefaultSettings", "cGloop4", cGloop4);
ini_write_real("DefaultSettings", "cGloop5", cGloop5);
ini_write_real("DefaultSettings", "cGloop6", cGloop6);
ini_write_real("DefaultSettings", "cGloop7", cGloop7);
ini_write_real("DefaultSettings", "cGloop8", cGloop8);
ini_write_real("DefaultSettings", "cGloop9", cGloop9);

//ini_write_real("Player", "Score", score);
//ini_write_real("Player", "Health", health);
//ini_write_string("Player", "Name", player_name);
//ini_write_real("Game", "Level", current_level);

ini_close();
}


function scr_load_settings(){
	var controller = global.controller;

	// obj_controller: Load Game
	if (file_exists("save.ini")) {
	    ini_open("save.ini");
		//controller.settings_NumberOfPowerUps = ini_read_real("DefaultSettings", "controller_powers", 0);
		controller.settings_NumberOfObstacles = ini_read_real("DefaultSettings", "controller_obstacles", 0);    
		
		controller.number_of_players = ini_read_real("DefaultSettings", "controller_player_count", 1);    
		controller.player_color[0] = ini_read_real("DefaultSettings", "cGloop0", -1);    
		controller.player_color[1] = ini_read_real("DefaultSettings", "cGloop1", -1);    
		controller.player_color[2] = ini_read_real("DefaultSettings", "cGloop2", -1);    
		controller.player_color[3] = ini_read_real("DefaultSettings", "cGloop3", -1);    
		controller.player_color[4] = ini_read_real("DefaultSettings", "cGloop4", -1);    
		controller.player_color[5] = ini_read_real("DefaultSettings", "cGloop5", -1);    
		controller.player_color[6] = ini_read_real("DefaultSettings", "cGloop6", -1);    
		controller.player_color[7] = ini_read_real("DefaultSettings", "cGloop7", -1);    
		controller.player_color[8] = ini_read_real("DefaultSettings", "cGloop8", -1);    
		controller.player_color[9] = ini_read_real("DefaultSettings", "cGloop9", -1);   
	    ini_close();
	} else {
	    show_debug_message("No save file found.");
	}
}






function scr_save_high_score(){

	var controller = global.controller;


	var def_score_1=250
	var def_score_2=226
	var def_score_3=201
	var def_score_4=200
	var def_score_5=175
	var def_score_6=150
	var def_score_7=125
	var def_score_8=100
	var def_score_9=75
	var def_score_10=1
	
	var def_name_1="JEX"
	var def_name_2="VI "
	var def_name_3="KAY"
	var def_name_4="BAG"
	var def_name_5="HAT"
	var def_name_6="RNT"
	var def_name_7="ARK"
	var def_name_8="KRA"
	var def_name_9="SHN"
	var def_name_10="SLM"
	
	// obj_controller: Save Game
	ini_open("save.ini");	
	
	ini_write_real("Highscore", "Highscore1", def_score_1);
	ini_write_real("Highscore", "Highscore2", def_score_2);
	ini_write_real("Highscore", "Highscore3", def_score_3);
	ini_write_real("Highscore", "Highscore4", def_score_4);
	ini_write_real("Highscore", "Highscore5", def_score_5);
	ini_write_real("Highscore", "Highscore6", def_score_6);
	ini_write_real("Highscore", "Highscore7", def_score_7);
	ini_write_real("Highscore", "Highscore8", def_score_8);
	ini_write_real("Highscore", "Highscore9", def_score_9);
	ini_write_real("Highscore", "Highscore10", def_score_10);


	ini_write_string("Highscore", "HighscoreInitals1", def_name_1);
	ini_write_string("Highscore", "HighscoreInitals2", def_name_2);
	ini_write_string("Highscore", "HighscoreInitals3", def_name_3);
	ini_write_string("Highscore", "HighscoreInitals4", def_name_4);
	ini_write_string("Highscore", "HighscoreInitals5", def_name_5);
	ini_write_string("Highscore", "HighscoreInitals6", def_name_6);
	ini_write_string("Highscore", "HighscoreInitals7", def_name_7);
	ini_write_string("Highscore", "HighscoreInitals8", def_name_8);
	ini_write_string("Highscore", "HighscoreInitals9", def_name_9);
	ini_write_string("Highscore", "HighscoreInitals10", def_name_10);


	ini_close();
}
