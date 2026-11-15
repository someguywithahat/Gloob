/// True if this slime has at least one legal space to move into right now (including the extra two-away jumps
/// a Shroom powerup gives).  Doesn't check whose turn it is -- that's up to the caller
function scr_gloop_has_valid_move(gloop_id){
	var gx = gloop_id.grid_x
	var gy = gloop_id.grid_y
	var moves = [
		scr_get_grid_id(gx-1, gy-1), scr_get_grid_id(gx, gy-1), scr_get_grid_id(gx+1, gy-1),
		scr_get_grid_id(gx-1, gy),                              scr_get_grid_id(gx+1, gy),
		scr_get_grid_id(gx-1, gy+1), scr_get_grid_id(gx, gy+1), scr_get_grid_id(gx+1, gy+1),
	]
	if gloop_id.powerUp1=global.RED or gloop_id.powerUp2=global.RED or gloop_id.powerUp3=global.RED
	{
		array_push(moves, scr_get_grid_id(gx-2, gy-2), scr_get_grid_id(gx, gy-2), scr_get_grid_id(gx+2, gy-2))
		array_push(moves, scr_get_grid_id(gx-2, gy), scr_get_grid_id(gx+2, gy))
		array_push(moves, scr_get_grid_id(gx-2, gy+2), scr_get_grid_id(gx, gy+2), scr_get_grid_id(gx+2, gy+2))
	}
	//Same gate the click handler uses: a free, unclaimed number.  (An obstacle space has activeNumber=0 too)
	for (var i = 0; i < array_length(moves); i++)
		if moves[i]<>noone and moves[i].wall=0 and moves[i].activeNumber=1
			return true;
	return false;
}

/// True if this slime has no legal move, but can still save itself on its own this turn: Teleport (the fairy)
/// to escape, Leaf (the grass bush) to clear the spaces around it, or the season goal is already met, so
/// End Day is an option.  A hardhat (bonk) or Rainbow doesn't count: neither one opens up a free space
function scr_gloop_has_escape_action(gloop_id){
	if scr_gloop_has_valid_move(gloop_id)
		return false;
	if gloop_id.powerUp1=global.BLUE or gloop_id.powerUp2=global.BLUE or gloop_id.powerUp3=global.BLUE
		return true; //Teleport
	if gloop_id.powerUp1=global.GREEN or gloop_id.powerUp2=global.GREEN or gloop_id.powerUp3=global.GREEN
		return true; //Leaf
	if global.controller.season_goal<=0
		return true; //Could end the day instead
	return false;
}
