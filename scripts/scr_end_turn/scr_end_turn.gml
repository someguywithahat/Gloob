//Sets the next player.  Skip defeated players

function scr_end_turn(){
	var controller = global.controller;
	var controller_current_player = controller.current_player
	var controller_number_of_players = controller.number_of_players
	var targeting_object = controller.target_obj
	
	var target = noone;
	
	with (obj_gridNumber)
	{
	    highlighted=0
	}
		
	
	//skip if single player game
	//if controller_number_of_players==1
	//	return
		
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
			targeting_object.next_gloop=target
			targeting_object.traveling_to_next_gloop=1
			target.issleep=2
			target.idletime=0
			return
		}
	}	
	//If no one is alive then game over
	show_debug_message("GAME OVER!")
	var total_score =0
	with obj_gloop_score
	{
		total_score+=gloop_score
	}
	show_debug_message("score: "+string(total_score))
	
	//update running point total
	global.running_score_total+=total_score
	scr_save_add_to_running_total()
	
	controller.game_over_status=1
	controller.total_score=total_score
	with obj_unusedGloop
	{
		game_over()
	}


}


/// @function scr_revive_defeated_players()
/// @description New season: in a game with more than one player, any player with no slime still in play gets their
///              main slime back, right where it fell.  (Each player has one score sign, shared with their crown slimes.)
function scr_revive_defeated_players(){
	if instance_number(obj_gloop_score)<2
		return;

	with(obj_gloop_score)
	{
		var score_sign = id
		var main_slime = gloop
		if !instance_exists(main_slime)
			continue

		//Does this player still have a slime in play?  (The main slime or any of its crown slimes)
		var has_active = false
		with(obj_gloop)
		{
			if gloop_score_obj=score_sign and alive=1
				has_active = true
		}
		if has_active
			continue

		//Back on its feet
		with(main_slime)
		{
			alive=1
			ismoving=0
			issleep=0
			idletime=0
			sprite_index=s_idol
			hat_index=sh_idol
			accessory_index=sa_idol
			image_index=0
			image_speed=1
			var wake = audio_play_sound(snd_slm_wakeup2, 1, false)
			audio_sound_pitch(wake, random_range(1, 1.2))
		}
	}
}