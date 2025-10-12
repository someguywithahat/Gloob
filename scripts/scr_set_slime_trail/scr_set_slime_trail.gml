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
	
	//show_debug_message(string(derX) + " " + string(derY)+ " move_angle " + string(move_angle)+ " prev_move_angle: " + string(prev_move_angle))
	show_debug_message(" prev_derX " + string(prev_derX)+ " prev_derY: " + string(prev_derY)+ " derX " + string(derX)+ " derY: " + string(derY))
	
	if move_angle=0 and prev_derX=0 and prev_derY=0
	{
		show_debug_message("Not updating trail.  Sprite is jumping")
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

	trail_sprite = scr_get_slime_trail(trail_type,color)
	target.sprite_index=trail_sprite
	scr_rotate_sprite(target,rotate)

}


		//if derX<>0 and derY=0
		//{
		//	next_inst.image_angle=90
		//	next_inst.y+=controller.spacing
		//}
		//else next_inst.image_angle=0
function scr_rotate_sprite(target, rotate_amount){		
	var controller = global.controller;
	var spacing = controller.spacing
	
	
	//Unrotate the sprite first.  
	var prev_trail_rotation = target.trail_rotation
	if prev_trail_rotation=1
	{
		target.image_angle=0
		target.y -= controller.spacing
		show_debug_message("unrotate rotate90")
	}
	else if prev_trail_rotation=2
	{
		target.image_angle=0
		target.y -= controller.spacing
		target.x -= controller.spacing
		show_debug_message("unrotate rotate180")
	}
	else if prev_trail_rotation=3
	{
		target.image_angle=0
		target.x -= controller.spacing
		show_debug_message("unrotate rotate270")
	}

	
	target.trail_rotation=rotate_amount	
	if rotate_amount=1
	{
		target.image_angle=90
		target.y += controller.spacing
		show_debug_message("rotate90")
	}
	else if rotate_amount=2
	{
		target.image_angle=180
		target.y += controller.spacing
		target.x += controller.spacing
		show_debug_message("rotate180")
	}
	else if rotate_amount=3
	{
		target.image_angle=270
		target.x += controller.spacing
		show_debug_message("rotate270")
	}
	else if rotate_amount=0
	{
		//target.image_angle=0
		show_debug_message("no rotate")
	}
		
}


/*
	trail_type=0 -- Trail Spot
	trail_type=1 -- Trail end
	trail_type=2 -- Trail Mid
	trail_type=3 -- Trail Corner
*/
function scr_get_slime_trail(trail_type, color){
	
		
	var trail_sprite = Trl_Grn_Spot
	
	//This was a case statement but gamemaker refused to cooperate 
	if color=="black"{
			switch(trail_type){
				case(0): trail_sprite=Trl_Blk_Spot; break;
				case(1): trail_sprite=Trl_Blk_End; break;
				case(2): trail_sprite=Trl_Blk_Mid; break;
				case(3): trail_sprite=Trl_Blk_Corner; break;
				default: trail_sprite=Trl_Blk_Corner; break;
			}
	}
	else if color=="blue"{
			switch(trail_type){
				case(0): trail_sprite=Trl_Blu_Spot; break;
				case(1): trail_sprite=Trl_Blu_End; break;
				case(2): trail_sprite=Trl_Blu_Mid; break;
				case(3): trail_sprite=Trl_Blu_Corner; break;
				default: trail_sprite=Trl_Blu_Corner; break;
			}
	}
	else if color=="green"{
			switch(trail_type){
				case(0): trail_sprite=Trl_Grn_Spot; break;
				case(1): trail_sprite=Trl_Grn_End; break;
				case(2): trail_sprite=Trl_Grn_Mid; break;
				case(3): trail_sprite=Trl_Grn_Corner; break;
				default: trail_sprite=Trl_Grn_Corner; break;
			}
	}
	else if color=="orange"{
			switch(trail_type){
				case(0): trail_sprite=Trl_Orn_Spot; break;
				case(1): trail_sprite=Trl_Orn_End; break;
				case(2): trail_sprite=Trl_Orn_Mid; break;
				case(3): trail_sprite=Trl_Orn_Corner; break;
				default: trail_sprite=Trl_Orn_Corner; break;
			}
	}
	else if color=="purple"{
			switch(trail_type){
				case(0): trail_sprite=Trl_Pur_Spot; break;
				case(1): trail_sprite=Trl_Pur_End; break;
				case(2): trail_sprite=Trl_Pur_Mid; break;
				case(3): trail_sprite=Trl_Pur_Corner; break;
				default: trail_sprite=Trl_Pur_Corner; break;
			}
	}
	else if color=="red"{
			switch(trail_type){
				case(0): trail_sprite=Trl_Red_Spot; break;
				case(1): trail_sprite=Trl_Red_End; break;
				case(2): trail_sprite=Trl_Red_Mid; break;
				case(3): trail_sprite=Trl_Red_Corner; break;
				default: trail_sprite=Trl_Red_Corner; break;
			}
	}
	else if color=="white"{
			switch(trail_type){
				case(0): trail_sprite=Trl_Wht_Spot; break;
				case(1): trail_sprite=Trl_Wht_End; break;
				case(2): trail_sprite=Trl_Wht_Mid; break;
				case(3): trail_sprite=Trl_Wht_Corner; break;
				default: trail_sprite=Trl_Wht_Corner; break;
			}
	}
	else if color=="yellow"{
			switch(trail_type){
				case(0): trail_sprite=Trl_Yel_Spot; break;
				case(1): trail_sprite=Trl_Yel_End; break;
				case(2): trail_sprite=Trl_Yel_Mid; break;
				case(3): trail_sprite=Trl_Yel_Corner; break;
				default: trail_sprite=Trl_Yel_Corner; break;
			}
	}
	return trail_sprite
		
}
