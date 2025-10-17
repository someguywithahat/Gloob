//Sets the next player.  Skip defeated players

function scr_end_turn(){
	var controller = global.controller;
	var controller_current_player = controller.current_player
	var controller_number_of_players = controller.number_of_players
	
	var target = noone;
		
	
	//skip if single player game
	if controller_number_of_players==1
		return
		
    for (var i = 0; i < controller_number_of_players; i++)
    {		
		var nextPlayerNum = ((controller_current_player+1+i) mod controller_number_of_players)


		with (obj_gloop)
		{
		    if (player_number == nextPlayerNum)
		        target = id;				
		}
		
		if target.alive=1
		{
			controller.current_player=target.player_number
			target.issleep=2
			target.idletime=0
			return
		}
	}	
	
	
}