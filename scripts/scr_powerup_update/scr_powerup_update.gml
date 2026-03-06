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