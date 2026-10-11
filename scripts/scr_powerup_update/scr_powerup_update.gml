/// @function scr_powerup_update(gloop_id)
/// @param {instance<obj_gloop>} gloop_id - number of columns
/// @description Creates a grid of objects and stores instance references in a 2D array.
function scr_powerup_update(gloop_id){
	var powerUp1 = gloop_id.powerUp1
	var powerUp2 = gloop_id.powerUp2
	var powerUp3 = gloop_id.powerUp3
	
	if powerUp1=-1 and powerUp2>-1{
		powerUp1=powerUp2
		powerUp2=powerUp3
		powerUp3=-1
	}
	
	if powerUp1=-1 and powerUp3>-1{
		powerUp1=powerUp3
		powerUp3=-1
	}
	
	if powerUp2=-1 and powerUp3>-1{
		powerUp2=powerUp3
		powerUp3=-1
	}


}


#macro RAINBOW_TURNS 6

/// @function scr_rainbow_start(gloop_id)
/// @description Rainbow powerup picked up: color cycling and invincibility for RAINBOW_TURNS turns
function scr_rainbow_start(gloop_id){
	with(gloop_id)
	{
		if rainbow_turns<=0
			rainbow_original_color=gloop_color_index
		//+1 because the move the rainbow was picked up on doesn't count
		rainbow_turns=RAINBOW_TURNS+1
	}
}

/// @function scr_rainbow_end_move(gloop_id)
/// @description Call when the slime finishes a move.  Counts down the rainbow and ends it when time is up
function scr_rainbow_end_move(gloop_id){
	if gloop_id.rainbow_turns<=0
		return;
	gloop_id.rainbow_turns--
	if gloop_id.rainbow_turns>0
		return;
		
	//Rainbow is over: go back to the slime's real color and drop the powerup icon
	with(gloop_id)
	{
		gloop_color_index=rainbow_original_color
		gloop_color_index_old=rainbow_original_color
		rainbow_delay=0
		if powerUp1=global.RAINBOW
			powerUp1=-1
		if powerUp2=global.RAINBOW
			powerUp2=-1
		if powerUp3=global.RAINBOW
			powerUp3=-1
	}
}
