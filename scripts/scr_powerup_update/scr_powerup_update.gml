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


/// Puts a powerup in the first empty slot.  If all 3 slots are full, slot 1 is lost and the others shift forward
function scr_powerup_add(gloop_id, powerup){
	with(gloop_id)
	{
		if powerUp1=-1
			powerUp1=powerup
		else if powerUp2=-1
			powerUp2=powerup
		else if powerUp3=-1
			powerUp3=powerup
		else
		{
			powerUp1=powerUp2
			powerUp2=powerUp3
			powerUp3=powerup
		}
	}
}

/// How many slots hold this powerup
function scr_powerup_count(gloop_id, powerup){
	return (gloop_id.powerUp1=powerup) + (gloop_id.powerUp2=powerup) + (gloop_id.powerUp3=powerup)
}

/// How many slots are empty
function scr_powerup_empty_slots(gloop_id){
	return scr_powerup_count(gloop_id, -1)
}

/// Creates the buddy that follows a slime around for powerups that have one (mushroom, fairy).
/// Buddies count their slime's powerups and go away on their own when it has fewer than buddies
function scr_powerup_spawn_buddy(gloop_id, powerup){
	if powerup=global.RED
	{
		var mushroom = instance_create_layer(gloop_id.x, gloop_id.y, "Instances", obj_effect_mushroom)
		mushroom.parent_gloop=gloop_id
	}
	else if powerup=global.BLUE
	{
		var fairy = instance_create_layer(gloop_id.x+16, gloop_id.y, "Instances", obj_effect_fairy)
		fairy.parent_gloop=gloop_id
	}
}

/// Call after the slots change.  Updates the hardhat count and the grass hat
function scr_powerup_refresh(gloop_id){
	with(gloop_id)
	{
		puBonk = scr_powerup_count(id, global.YELLOW)
		has_grass = scr_powerup_count(id, global.GREEN)>0
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
