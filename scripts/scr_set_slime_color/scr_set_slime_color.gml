function scr_set_slime_color(target, color_num){
	//gloop =  variable_instance_set(id, obj_gloop, value);
	target.image_speed=1
	if color_num=1
	{
		target.sprite_index=Slm_Grn_Idol
		target.gloop_color="green"
		target.gloop_color_index=2
		variable_instance_set(target, "s_idol", Slm_Grn_Idol);
		variable_instance_set(target, "s_sleep", Slm_Grn_Sleep);
		variable_instance_set(target, "s_death", Slm_Grn_Death);
		variable_instance_set(target, "s_trl_corner", Trl_Grn_Corner);
		variable_instance_set(target, "s_trl_end", Trl_Grn_End);
		variable_instance_set(target, "s_trl_mid", Trl_Grn_Mid);
		variable_instance_set(target, "s_trl_spot", Trl_Grn_Spot);
		variable_instance_set(target, "gloop_score_obj.parent_sprite", Slm_Grn_Idol);
	}
	else if color_num=2
	{
		target.sprite_index=Slm_Blu_Idol
		target.gloop_color="blue"
		target.gloop_color_index=1
		variable_instance_set(target, "s_idol", Slm_Blu_Idol);
		variable_instance_set(target, "s_sleep", Slm_Blu_Sleep);
		variable_instance_set(target, "s_death", Slm_Blu_Death);
		variable_instance_set(target, "s_trl_corner", Trl_Blu_Corner);
		variable_instance_set(target, "s_trl_end", Trl_Blu_End);
		variable_instance_set(target, "s_trl_mid", Trl_Blu_Mid);
		variable_instance_set(target, "s_trl_spot", Trl_Blu_Spot);
		variable_instance_set(target, "gloop_score_obj.parent_sprite", Slm_Blu_Idol);
	}
	else if color_num=3
	{
		target.sprite_index=Slm_Pur_Idol
		target.gloop_color_index=4
		target.gloop_color="purple"
		variable_instance_set(target, "s_idol", Slm_Pur_Idol);
		variable_instance_set(target, "s_sleep", Slm_Pur_Sleep);
		variable_instance_set(target, "s_death", Slm_Pur_Death);
		variable_instance_set(target, "s_trl_corner", Trl_Pur_Corner);
		variable_instance_set(target, "s_trl_end", Trl_Pur_End);
		variable_instance_set(target, "s_trl_mid", Trl_Pur_Mid);
		variable_instance_set(target, "s_trl_spot", Trl_Pur_Spot);
		variable_instance_set(target, "gloop_score_obj.parent_sprite", Slm_Pur_Idol);
	}
	else if color_num=4
	{
		target.sprite_index=Slm_Red_Idol
		target.gloop_color_index=5
		target.gloop_color="red"
		variable_instance_set(target, "s_idol", Slm_Red_Idol);
		variable_instance_set(target, "s_sleep", Slm_Red_Sleep);
		variable_instance_set(target, "s_death", Slm_Red_Death);
		variable_instance_set(target, "s_trl_corner", Trl_Red_Corner);
		variable_instance_set(target, "s_trl_end", Trl_Red_End);
		variable_instance_set(target, "s_trl_mid", Trl_Red_Mid);
		variable_instance_set(target, "s_trl_spot", Trl_Red_Spot);	
		variable_instance_set(target, "gloop_score_obj.parent_sprite", Slm_Red_Idol);	
	}
	else if color_num=5
	{
		target.sprite_index=Slm_Orn_Idol
		target.gloop_color="orange"
		target.gloop_color_index=3
		variable_instance_set(target, "s_idol", Slm_Orn_Idol);
		variable_instance_set(target, "s_sleep", Slm_Orn_Sleep);
		variable_instance_set(target, "s_death", Slm_Orn_Death);	
		variable_instance_set(target, "s_trl_corner", Trl_Orn_Corner);
		variable_instance_set(target, "s_trl_end", Trl_Orn_End);
		variable_instance_set(target, "s_trl_mid", Trl_Orn_Mid);
		variable_instance_set(target, "s_trl_spot", Trl_Orn_Spot);		
		variable_instance_set(target, "gloop_score_obj.parent_sprite", Slm_Orn_Idol);
	}
	else if color_num=6
	{
		target.sprite_index=Slm_Yel_Idol
		target.gloop_color="yellow"
		target.gloop_color_index=7
		variable_instance_set(target, "s_idol", Slm_Yel_Idol);
		variable_instance_set(target, "s_sleep", Slm_Yel_Sleep);
		variable_instance_set(target, "s_death", Slm_Yel_Death);	
		variable_instance_set(target, "s_trl_corner", Trl_Yel_Corner);
		variable_instance_set(target, "s_trl_end", Trl_Yel_End);
		variable_instance_set(target, "s_trl_mid", Trl_Yel_Mid);
		variable_instance_set(target, "s_trl_spot", Trl_Yel_Spot);		
		variable_instance_set(target, "gloop_score_obj.parent_sprite", Slm_Yel_Idol);	
	}
	else if color_num=7
	{
		target.sprite_index=Slm_Wht_Idol
		target.gloop_color="white"
		target.gloop_color_index=6
		variable_instance_set(target, "s_idol", Slm_Wht_Idol);
		variable_instance_set(target, "s_sleep", Slm_Wht_Sleep);
		variable_instance_set(target, "s_death", Slm_Wht_Death);	
		variable_instance_set(target, "s_trl_corner", Trl_Wht_Corner);
		variable_instance_set(target, "s_trl_end", Trl_Wht_End);
		variable_instance_set(target, "s_trl_mid", Trl_Wht_Mid);
		variable_instance_set(target, "s_trl_spot", Trl_Wht_Spot);	
		variable_instance_set(target, "gloop_score_obj.parent_sprite", Slm_Wht_Idol);		
	}
	else if color_num=8
	{
		target.sprite_index=Slm_Blk_Idol
		target.gloop_color_index=0
		target.gloop_color="black"
		variable_instance_set(target, "s_idol", Slm_Blk_Idol);
		variable_instance_set(target, "s_sleep", Slm_Blk_Sleep);
		variable_instance_set(target, "s_death", Slm_Blk_Death);
		variable_instance_set(target, "s_trl_corner", Trl_Blk_Corner);
		variable_instance_set(target, "s_trl_end", Trl_Blk_End);
		variable_instance_set(target, "s_trl_mid", Trl_Blk_Mid);
		variable_instance_set(target, "s_trl_spot", Trl_Blk_Spot);
		variable_instance_set(target, "gloop_score_obj.parent_sprite", Slm_Blk_Idol);
	}

}
