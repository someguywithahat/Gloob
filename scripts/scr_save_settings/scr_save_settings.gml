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