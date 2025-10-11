/*
	move_status=0 -- Gloop has never moved
	move_status=1 -- Gloop is about to move
	move_status=2 -- Gloop is moving and will continue to move
	move_status=3 -- Gloop is stopping
*/
function scr_set_slime_trail(target, derX,derY, prev_derX, prev_derY, move_status, color){
	var trail_type =0
	
	
	
	

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
