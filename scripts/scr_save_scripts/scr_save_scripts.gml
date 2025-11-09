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






//function scr_save_high_score(){

//	var controller = global.controller;


//	var def_score_1=250
//	var def_score_2=225
//	var def_score_3=201
//	var def_score_4=200
//	var def_score_5=175
//	var def_score_6=40
//	var def_score_7=35
//	var def_score_8=30
//	var def_score_9=25
//	var def_score_10=1
	
//	var def_name_1="JEX"
//	var def_name_2="VI "
//	var def_name_3="KAY"
//	var def_name_4="BAG"
//	var def_name_5="AZR"
//	var def_name_6="RNT"
//	var def_name_7="ARK"
//	var def_name_8="KRA"
//	var def_name_9="HAT"
//	var def_name_10="SLM"
	
//	var def_index_1=1
//	var def_index_2=2
//	var def_index_3=0
//	var def_index_4=4
//	var def_index_5=4
//	var def_index_6=0
//	var def_index_7=4
//	var def_index_8=2
//	var def_index_9=0
//	var def_index_10=3
	
//	var def_color_1=2
//	var def_color_2=4
//	var def_color_3=3
//	var def_color_4=5
//	var def_color_5=1
//	var def_color_6=6
//	var def_color_7=7
//	var def_color_8=0
//	var def_color_9=1
//	var def_color_10=2
	
//	// obj_controller: Save Game
//	ini_open("save.ini");	
	
//	ini_write_real("Highscore", "Highscore1", def_score_1);
//	ini_write_real("Highscore", "Highscore2", def_score_2);
//	ini_write_real("Highscore", "Highscore3", def_score_3);
//	ini_write_real("Highscore", "Highscore4", def_score_4);
//	ini_write_real("Highscore", "Highscore5", def_score_5);
//	ini_write_real("Highscore", "Highscore6", def_score_6);
//	ini_write_real("Highscore", "Highscore7", def_score_7);
//	ini_write_real("Highscore", "Highscore8", def_score_8);
//	ini_write_real("Highscore", "Highscore9", def_score_9);
//	ini_write_real("Highscore", "Highscore10", def_score_10);


//	ini_write_string("Highscore", "HighscoreInitals1", def_name_1);
//	ini_write_string("Highscore", "HighscoreInitals2", def_name_2);
//	ini_write_string("Highscore", "HighscoreInitals3", def_name_3);
//	ini_write_string("Highscore", "HighscoreInitals4", def_name_4);
//	ini_write_string("Highscore", "HighscoreInitals5", def_name_5);
//	ini_write_string("Highscore", "HighscoreInitals6", def_name_6);
//	ini_write_string("Highscore", "HighscoreInitals7", def_name_7);
//	ini_write_string("Highscore", "HighscoreInitals8", def_name_8);
//	ini_write_string("Highscore", "HighscoreInitals9", def_name_9);
//	ini_write_string("Highscore", "HighscoreInitals10", def_name_10);


//	ini_write_real("Highscore", "HighscoreIndex1", def_index_1);
//	ini_write_real("Highscore", "HighscoreIndex2", def_index_2);
//	ini_write_real("Highscore", "HighscoreIndex3", def_index_3);
//	ini_write_real("Highscore", "HighscoreIndex4", def_index_4);
//	ini_write_real("Highscore", "HighscoreIndex5", def_index_5);
//	ini_write_real("Highscore", "HighscoreIndex6", def_index_6);
//	ini_write_real("Highscore", "HighscoreIndex7", def_index_7);
//	ini_write_real("Highscore", "HighscoreIndex8", def_index_8);
//	ini_write_real("Highscore", "HighscoreIndex9", def_index_9);
//	ini_write_real("Highscore", "HighscoreIndex10", def_index_10);


//	ini_write_real("Highscore", "HighscoreColor1", def_color_1);
//	ini_write_real("Highscore", "HighscoreColor2", def_color_2);
//	ini_write_real("Highscore", "HighscoreColor3", def_color_3);
//	ini_write_real("Highscore", "HighscoreColor4", def_color_4);
//	ini_write_real("Highscore", "HighscoreColor5", def_color_5);
//	ini_write_real("Highscore", "HighscoreColor6", def_color_6);
//	ini_write_real("Highscore", "HighscoreColor7", def_color_7);
//	ini_write_real("Highscore", "HighscoreColor8", def_color_8);
//	ini_write_real("Highscore", "HighscoreColor9", def_color_9);
//	ini_write_real("Highscore", "HighscoreColor10", def_color_10);


//	ini_close();
//}



function scr_save_high_score(){

	
	
	// obj_controller: Save Game
	ini_open("save.ini");	
	
	ini_write_real("Highscore", "Highscore1", global.high_scores[0].gscore);
	ini_write_real("Highscore", "Highscore2", global.high_scores[1].gscore);
	ini_write_real("Highscore", "Highscore3", global.high_scores[2].gscore);
	ini_write_real("Highscore", "Highscore4", global.high_scores[3].gscore);
	ini_write_real("Highscore", "Highscore5", global.high_scores[4].gscore);
	ini_write_real("Highscore", "Highscore6", global.high_scores[5].gscore);
	ini_write_real("Highscore", "Highscore7", global.high_scores[6].gscore);
	ini_write_real("Highscore", "Highscore8", global.high_scores[7].gscore);
	ini_write_real("Highscore", "Highscore9", global.high_scores[8].gscore);
	ini_write_real("Highscore", "Highscore10", global.high_scores[9].gscore);


	ini_write_string("Highscore", "HighscoreInitals1", global.high_scores[0].gname);
	ini_write_string("Highscore", "HighscoreInitals2", global.high_scores[1].gname);
	ini_write_string("Highscore", "HighscoreInitals3", global.high_scores[2].gname);
	ini_write_string("Highscore", "HighscoreInitals4", global.high_scores[3].gname);
	ini_write_string("Highscore", "HighscoreInitals5", global.high_scores[4].gname);
	ini_write_string("Highscore", "HighscoreInitals6", global.high_scores[5].gname);
	ini_write_string("Highscore", "HighscoreInitals7", global.high_scores[6].gname);
	ini_write_string("Highscore", "HighscoreInitals8", global.high_scores[7].gname);
	ini_write_string("Highscore", "HighscoreInitals9", global.high_scores[8].gname);
	ini_write_string("Highscore", "HighscoreInitals10", global.high_scores[9].gname);


	ini_write_real("Highscore", "HighscoreIndex1", global.high_scores[0].gindex);
	ini_write_real("Highscore", "HighscoreIndex2", global.high_scores[1].gindex);
	ini_write_real("Highscore", "HighscoreIndex3", global.high_scores[2].gindex);
	ini_write_real("Highscore", "HighscoreIndex4", global.high_scores[3].gindex);
	ini_write_real("Highscore", "HighscoreIndex5", global.high_scores[4].gindex);
	ini_write_real("Highscore", "HighscoreIndex6", global.high_scores[5].gindex);
	ini_write_real("Highscore", "HighscoreIndex7", global.high_scores[6].gindex);
	ini_write_real("Highscore", "HighscoreIndex8", global.high_scores[7].gindex);
	ini_write_real("Highscore", "HighscoreIndex9", global.high_scores[8].gindex);
	ini_write_real("Highscore", "HighscoreIndex10", global.high_scores[9].gindex);


	ini_write_real("Highscore", "HighscoreColor1", global.high_scores[0].gcolor);
	ini_write_real("Highscore", "HighscoreColor2", global.high_scores[1].gcolor);
	ini_write_real("Highscore", "HighscoreColor3", global.high_scores[2].gcolor);
	ini_write_real("Highscore", "HighscoreColor4", global.high_scores[3].gcolor);
	ini_write_real("Highscore", "HighscoreColor5", global.high_scores[4].gcolor);
	ini_write_real("Highscore", "HighscoreColor6", global.high_scores[5].gcolor);
	ini_write_real("Highscore", "HighscoreColor7", global.high_scores[6].gcolor);
	ini_write_real("Highscore", "HighscoreColor8", global.high_scores[7].gcolor);
	ini_write_real("Highscore", "HighscoreColor9", global.high_scores[8].gcolor);
	ini_write_real("Highscore", "HighscoreColor10", global.high_scores[9].gcolor);


	ini_close();
}

function scr_load_high_score(){		
		var high_score ={
			gname: "tst",
			gscore: 123,
			gindex: 1,
			gcolor: 2
		}
	
	// obj_controller: Load Game
	if (file_exists("save.ini")) {
	    ini_open("save.ini");
		
		global.high_scores[0].gname=ini_read_string("Highscore", "HighscoreInitals1", "???");
		global.high_scores[0].gscore=ini_read_real("Highscore", "Highscore1", 0);
		global.high_scores[0].gindex=ini_read_real("Highscore", "HighscoreIndex1", 0);
		global.high_scores[0].gcolor=ini_read_real("Highscore", "HighscoreColor1", 0);
		//global.high_scores[0]=high_score
		
		
		global.high_scores[1].gname=ini_read_string("Highscore", "HighscoreInitals2", "???");
		global.high_scores[1].gscore=ini_read_real("Highscore", "Highscore2", 0);
		global.high_scores[1].gindex=ini_read_real("Highscore", "HighscoreIndex2", 0);
		global.high_scores[1].gcolor=ini_read_real("Highscore", "HighscoreColor2", 0);
		//global.high_scores[1]=high_score
		
		global.high_scores[2].gname=ini_read_string("Highscore", "HighscoreInitals3", "???");
		global.high_scores[2].gscore=ini_read_real("Highscore", "Highscore3", 0);
		global.high_scores[2].gindex=ini_read_real("Highscore", "HighscoreIndex3", 0);
		global.high_scores[2].gcolor=ini_read_real("Highscore", "HighscoreColor3", 0);
		//global.high_scores[2]=high_score
		
		global.high_scores[3].gname=ini_read_string("Highscore", "HighscoreInitals4", "???");
		global.high_scores[3].gscore=ini_read_real("Highscore", "Highscore4", 0);
		global.high_scores[3].gindex=ini_read_real("Highscore", "HighscoreIndex4", 0);
		global.high_scores[3].gcolor=ini_read_real("Highscore", "HighscoreColor4", 0);
		//global.high_scores[3]=high_score
		
		global.high_scores[4].gname=ini_read_string("Highscore", "HighscoreInitals5", "???");
		global.high_scores[4].gscore=ini_read_real("Highscore", "Highscore5", 0);
		global.high_scores[4].gindex=ini_read_real("Highscore", "HighscoreIndex5", 0);
		global.high_scores[4].gcolor=ini_read_real("Highscore", "HighscoreColor5", 0);
		//global.high_scores[4]=high_score
		
		global.high_scores[5].gname=ini_read_string("Highscore", "HighscoreInitals6", "???");
		global.high_scores[5].gscore=ini_read_real("Highscore", "Highscore6", 0);
		global.high_scores[5].gindex=ini_read_real("Highscore", "HighscoreIndex6", 0);
		global.high_scores[5].gcolor=ini_read_real("Highscore", "HighscoreColor6", 0);
		//global.high_scores[5]=high_score
		
		global.high_scores[6].gname=ini_read_string("Highscore", "HighscoreInitals7", "???");
		global.high_scores[6].gscore=ini_read_real("Highscore", "Highscore7", 0);
		global.high_scores[6].gindex=ini_read_real("Highscore", "HighscoreIndex7", 0);
		global.high_scores[6].gcolor=ini_read_real("Highscore", "HighscoreColor7", 0);
		//global.high_scores[6]=high_score
		
		global.high_scores[7].gname=ini_read_string("Highscore", "HighscoreInitals8", "???");
		global.high_scores[7].gscore=ini_read_real("Highscore", "Highscore8", 0);
		global.high_scores[7].gindex=ini_read_real("Highscore", "HighscoreIndex8", 0);
		global.high_scores[7].gcolor=ini_read_real("Highscore", "HighscoreColor8", 0);
		//global.high_scores[7]=high_score
		
		global.high_scores[8].gname=ini_read_string("Highscore", "HighscoreInitals9", "???");
		global.high_scores[8].gscore=ini_read_real("Highscore", "Highscore9", 0);
		global.high_scores[8].gindex=ini_read_real("Highscore", "HighscoreIndex9", 0);
		global.high_scores[8].gcolor=ini_read_real("Highscore", "HighscoreColor9", 0);
		//global.high_scores[8]=high_score
		
		global.high_scores[9].gname=ini_read_string("Highscore", "HighscoreInitals10", "???");
		global.high_scores[9].gscore=ini_read_real("Highscore", "Highscore10", 0);
		global.high_scores[9].gindex=ini_read_real("Highscore", "HighscoreIndex10", 0);
		global.high_scores[9].gcolor=ini_read_real("Highscore", "HighscoreColor10", 0);
		//global.high_scores[9]=high_score
		

		
	    ini_close();
	} else {
	    show_debug_message("No save file found.");
	}	
	
}