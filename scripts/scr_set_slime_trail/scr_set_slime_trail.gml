/*
	move_status=0 -- Gloop has never moved
	move_status=1 -- Gloop is about to move
	move_status=2 -- Gloop is moving and will continue to move
	move_status=3 -- Gloop is stopping
*/
function scr_set_slime_trail(target, derX, derY, prev_derX, prev_derY, entering, color){
	var trail_type =0
	var trail_sprite = Trl_Blu_End
	var rotate=0
	
	
	var move_angle = abs(derX + derY) mod 2
	var prev_move_angle = abs(prev_derX + prev_derY) mod 2
	

	if move_angle=0 and prev_derX=0 and prev_derY=0
	{
		//show_debug_message("Not updating trail.  Sprite is jumping")
		return
	}
	//Sprite is jumping with no trail
	if  move_angle = 0 and prev_move_angle=0{
		trail_type=0
	}
	//Sprite is moving straight after a jump or jumping after moving straight
	else if abs((move_angle + prev_move_angle) mod 2) = 1{
		trail_type=1
		
		if (abs(move_angle mod 2) =1) //if starting to move
		{
			if derX=1
				rotate=1
			else if derY=-1
				rotate=2
			else if derX=-1
				rotate=3
			else 
				rotate=0
		}
		else 
		if (abs(prev_move_angle mod 2) =1) //Starting move
		{
			if prev_derX=1
				rotate=3
			else if prev_derY=-1
				rotate=0
			else if prev_derX=-1
				rotate=1
			else 
				rotate=2
		}
	}
	//Sprite is going straight
	else if derX=prev_derX{
		trail_type=2
		if derX<>0
			rotate=1
	}
	//sprite is turning 90 degrees
	else {
		trail_type=3
		if (prev_derX=-1 and derY=-1) or (prev_derY=1 and derX=1)
			rotate=0
		else if (prev_derX=1 and derY=-1) or (prev_derY=1 and derX=-1)
			rotate=1
		else if (prev_derX=1 and derY=1) or (prev_derY=-1 and derX=-1)
			rotate=2
		else if (prev_derX=-1 and derY=1) or (prev_derY=-1 and derX=1)
			rotate=3
	}

	trail_sprite = scr_get_slime_trail(trail_type)
	target.sprite_index=trail_sprite
	//scr_rotate_sprite(target,rotate)
	target.image_speed=1
	target.gloop_color_index=color
	target.trail_animating=0
	target.trail_custom=0

	//Corner trail is animated frame by frame by obj_gloop as it slides out of the tile
	if trail_type=3 and entering=0
		scr_start_trail_anim(target, Spr_Trl_Corner, prev_derX, prev_derY, derX, derY, 1)
	//Straight trail rests on the first Mid frame (trail reaches the center). obj_gloop animates it when the slime slides out
	else if trail_type=2
		scr_start_trail_anim(target, Spr_Trl_Mid, derX, derY, derX, derY, 0)

}

/*
	Sets a tile to an animated trail sprite, oriented by the slime's travel direction.
	Base sprites travel upward (Corner enters from the right, then goes up)
	in_x/in_y  -- direction the slime was moving when it entered the tile
	out_x/out_y -- direction the slime is moving when it leaves the tile
*/
function scr_start_trail_anim(target, sprite, in_x, in_y, out_x, out_y, animate){
	target.sprite_index=sprite
	target.image_speed=0
	target.image_index=0
	target.trail_animating=animate
	target.trail_custom=1

	//Rotate so "up" in the sprite points the way the slime leaves
	target.trail_angle = (point_direction(0, 0, out_x, out_y) + 270) mod 360

	//Base corner is a right turn.  Mirror it for left turns
	target.trail_xscale = 1
	if (in_x*out_y - in_y*out_x) < 0
		target.trail_xscale = -1

}

//progress -- 0 to 1, how far the slime has moved across one tile
function scr_update_trail_anim(target, progress){
	if target.trail_animating=0
		return;
	var frames = sprite_get_number(target.sprite_index)
	target.image_index = clamp(floor(progress*frames), 0, frames-1)
}

//Called when the slime finishes crossing a tile.  Swaps the trail to its looping idle sprite
function scr_finish_trail_anim(target){
	if target.trail_animating=0
		return;
	target.trail_animating=0

	var idle_sprite = noone
	switch(target.sprite_index){
		case Spr_Trl_Corner: idle_sprite=Trl_Grn_Corner; break;
		case Spr_Trl_Mid:    idle_sprite=Trl_Grn_Mid; break;
	}
	if idle_sprite<>noone
	{
		//Keeps trail_angle/trail_xscale so the idle sprite faces the same way
		target.sprite_index=idle_sprite
		target.image_index=0
		target.image_speed=1
	}
}



function scr_rotate_sprite(target, rotate_amount){		
	var controller = global.controller;
	var spacing = controller.spacing
	
	
	//Unrotate the sprite first.  
	var prev_trail_rotation = target.trail_rotation
	if prev_trail_rotation=1
	{
		target.image_angle=0
		target.y -= controller.spacing
		//show_debug_message("unrotate rotate90")
	}
	else if prev_trail_rotation=2
	{
		target.image_angle=0
		target.y -= controller.spacing
		target.x -= controller.spacing
		//show_debug_message("unrotate rotate180")
	}
	else if prev_trail_rotation=3
	{
		target.image_angle=0
		target.x -= controller.spacing
		//show_debug_message("unrotate rotate270")
	}

	
	target.trail_rotation=rotate_amount	
	if rotate_amount=1
	{
		target.image_angle=90
		target.y += controller.spacing
		//show_debug_message("rotate90")
	}
	else if rotate_amount=2
	{
		target.image_angle=180
		target.y += controller.spacing
		target.x += controller.spacing
		//show_debug_message("rotate180")
	}
	else if rotate_amount=3
	{
		target.image_angle=270
		target.x += controller.spacing
		//show_debug_message("rotate270")
	}
	else if rotate_amount=0
	{
		//target.image_angle=0
		//show_debug_message("no rotate")
	}
		
}


/*
	trail_type=0 -- Trail Spot
	trail_type=1 -- Trail end
	trail_type=2 -- Trail Mid
	trail_type=3 -- Trail Corner
*/
function scr_get_slime_trail(trail_type){
	
		
	var trail_sprite = Trl_Grn_Spot_Lg
	switch(trail_type){
		//case(0): trail_sprite=Trl_Grn_Spot_Lg; break;
		case(1): trail_sprite=Trl_Grn_End; break;
		case(2): trail_sprite=Trl_Grn_Mid; break;
		case(3): trail_sprite=Trl_Grn_Corner; break;
		default: trail_sprite=Trl_Grn_Corner; break;
	}
	if trail_type=0{
		var randomSpot = irandom_range(1,4)
		if randomSpot=1
			trail_sprite=Trl_Grn_Spot_Lg
		else if randomSpot=2
			trail_sprite=Trl_Grn_Spot_O
		else if randomSpot=3
			trail_sprite=Trl_Grn_Spot_Sm
		else trail_sprite=Trl_Grn_Spot_Sm_D
	}
	
	////This was a case statement but gamemaker refused to cooperate 
	//if color=="black"{
	//		switch(trail_type){
	//			case(0): trail_sprite=Trl_Blk_Spot; break;
	//			case(1): trail_sprite=Trl_Blk_End; break;
	//			case(2): trail_sprite=Trl_Blk_Mid; break;
	//			case(3): trail_sprite=Trl_Blk_Corner; break;
	//			default: trail_sprite=Trl_Blk_Corner; break;
	//		}
	//}
	//else if color=="blue"{
	//		switch(trail_type){
	//			case(0): trail_sprite=Trl_Blu_Spot; break;
	//			case(1): trail_sprite=Trl_Blu_End; break;
	//			case(2): trail_sprite=Trl_Blu_Mid; break;
	//			case(3): trail_sprite=Trl_Blu_Corner; break;
	//			default: trail_sprite=Trl_Blu_Corner; break;
	//		}
	//}
	//else if color=="green"{
	//		switch(trail_type){
	//			case(0): trail_sprite=Trl_Grn_Spot_Lg; break;
	//			case(1): trail_sprite=Trl_Grn_End; break;
	//			case(2): trail_sprite=Trl_Grn_Mid; break;
	//			case(3): trail_sprite=Trl_Grn_Corner; break;
	//			default: trail_sprite=Trl_Grn_Corner; break;
	//		}
	//}
	//else if color=="orange"{
	//		switch(trail_type){
	//			case(0): trail_sprite=Trl_Orn_Spot; break;
	//			case(1): trail_sprite=Trl_Orn_End; break;
	//			case(2): trail_sprite=Trl_Orn_Mid; break;
	//			case(3): trail_sprite=Trl_Orn_Corner; break;
	//			default: trail_sprite=Trl_Orn_Corner; break;
	//		}
	//}
	//else if color=="purple"{
	//		switch(trail_type){
	//			case(0): trail_sprite=Trl_Pur_Spot; break;
	//			case(1): trail_sprite=Trl_Pur_End; break;
	//			case(2): trail_sprite=Trl_Pur_Mid; break;
	//			case(3): trail_sprite=Trl_Pur_Corner; break;
	//			default: trail_sprite=Trl_Pur_Corner; break;
	//		}
	//}
	//else if color=="red"{
	//		switch(trail_type){
	//			case(0): trail_sprite=Trl_Red_Spot; break;
	//			case(1): trail_sprite=Trl_Red_End; break;
	//			case(2): trail_sprite=Trl_Red_Mid; break;
	//			case(3): trail_sprite=Trl_Red_Corner; break;
	//			default: trail_sprite=Trl_Red_Corner; break;
	//		}
	//}
	//else if color=="white"{
	//		switch(trail_type){
	//			case(0): trail_sprite=Trl_Wht_Spot; break;
	//			case(1): trail_sprite=Trl_Wht_End; break;
	//			case(2): trail_sprite=Trl_Wht_Mid; break;
	//			case(3): trail_sprite=Trl_Wht_Corner; break;
	//			default: trail_sprite=Trl_Wht_Corner; break;
	//		}
	//}
	//else if color=="yellow"{
	//		switch(trail_type){
	//			case(0): trail_sprite=Trl_Yel_Spot; break;
	//			case(1): trail_sprite=Trl_Yel_End; break;
	//			case(2): trail_sprite=Trl_Yel_Mid; break;
	//			case(3): trail_sprite=Trl_Yel_Corner; break;
	//			default: trail_sprite=Trl_Yel_Corner; break;
	//		}
	//}
	return trail_sprite
		
}



/*
	Rounding off cut trails.
	Every trail space remembers the side the slime came in from (enterX/enterY) and left by (exitX/exitY).
	Two spaces are joined when they point at each other.  When a space's trail is removed or replaced
	(leaf powerup, rainbow, a crown slime starting from the space), call scr_trail_fix_neighbors on it.
	Any neighbor that pointed at it but isn't joined anymore gets a rounded end.
*/

/// True if gridNum has a slime trail on it
function scr_is_trail_space(gridNum){
	return gridNum<>noone and gridNum.wall=0 and gridNum.obs=0 and gridNum.activeNumber=0
}

/// True if gridNum's trail goes out the (dx,dy) side
function scr_trail_points(gridNum, dx, dy){
	return (gridNum.enterX=dx and gridNum.enterY=dy) or (gridNum.exitX=dx and gridNum.exitY=dy)
}

/// Rounds off the trails next to gridNum that used to connect to it
function scr_trail_fix_neighbors(gridNum){
	var directions = [[0,-1], [0,1], [-1,0], [1,0]]
	for (var i = 0; i < array_length(directions); i++)
	{
		var dx = directions[i][0]
		var dy = directions[i][1]
		var neighbor = scr_get_grid_id(gridNum.grid_x+dx, gridNum.grid_y+dy)
		
		//Only trails that point back at gridNum.  Skip ones a slime is sliding across right now
		if !scr_is_trail_space(neighbor) or neighbor.trail_animating=1
			continue;
		var in_use = false
		with(obj_gloop)
			if ismoving=1 and current_grid_number=neighbor
				in_use = true
		if in_use
			continue;
		if !scr_trail_points(neighbor, -dx, -dy)
			continue;
		//Still joined
		if scr_is_trail_space(gridNum) and scr_trail_points(gridNum, dx, dy)
			continue;
		
		//Cut: forget that side and round off what's left
		if neighbor.enterX=-dx and neighbor.enterY=-dy
		{
			neighbor.enterX=0
			neighbor.enterY=0
		}
		if neighbor.exitX=-dx and neighbor.exitY=-dy
		{
			neighbor.exitX=0
			neighbor.exitY=0
		}
		scr_trail_round_off(neighbor)
	}
}

/// Redraws a trail that lost a connection.  One side left: Trl_Grn_End.  Nothing left: Trl_Grn_Spot_O
function scr_trail_round_off(gridNum){
	//Straight (not diagonal) sides still connected
	var sides = []
	if abs(gridNum.enterX)+abs(gridNum.enterY)=1
		array_push(sides, [gridNum.enterX, gridNum.enterY])
	if abs(gridNum.exitX)+abs(gridNum.exitY)=1
		array_push(sides, [gridNum.exitX, gridNum.exitY])
	
	if array_length(sides)>=2
		return;
		
	if array_length(sides)=1
	{
		//Trl_Grn_End opens at the bottom and is rounded at the top.  Point the rounded end away from the connected side
		var away_x = -sides[0][0]
		var away_y = -sides[0][1]
		scr_start_trail_anim(gridNum, Trl_Grn_End, away_x, away_y, away_x, away_y, 0)
	}
	else
	{
		gridNum.sprite_index=Trl_Grn_Spot_O
		gridNum.trail_custom=0
	}
	gridNum.image_index=0
	gridNum.image_speed=1
}
