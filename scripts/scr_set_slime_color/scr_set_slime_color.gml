function scr_set_slime_color(target, color_num){
	//gloop =  variable_instance_set(id, obj_gloop, value);
	target.image_speed=1
	if color_num=1
	{
		target.sprite_index=Slm_Grn_Idol
		variable_instance_set(target, "s_idol", Slm_Grn_Idol);
		variable_instance_set(target, "s_sleep", Slm_Grn_Sleep);
		variable_instance_set(target, "s_death", Slm_Grn_Death);		
	}
	else if color_num=2
	{
		target.sprite_index=Slm_Blu_Idol
		variable_instance_set(target, "s_idol", Slm_Blu_Idol);
		variable_instance_set(target, "s_sleep", Slm_Blu_Sleep);
		variable_instance_set(target, "s_death", Slm_Blu_Death);		
	}
	else if color_num=3
	{
		target.sprite_index=Slm_Pur_Idol
		variable_instance_set(target, "s_idol", Slm_Pur_Idol);
		variable_instance_set(target, "s_sleep", Slm_Pur_Sleep);
		variable_instance_set(target, "s_death", Slm_Pur_Death);		
	}
	else if color_num=4
	{
		target.sprite_index=Slm_Red_Idol
		variable_instance_set(target, "s_idol", Slm_Red_Idol);
		variable_instance_set(target, "s_sleep", Slm_Red_Sleep);
		variable_instance_set(target, "s_death", Slm_Red_Death);		
	}
	else if color_num=5
	{
		target.sprite_index=Slm_Orn_Idol
		variable_instance_set(target, "s_idol", Slm_Orn_Idol);
		variable_instance_set(target, "s_sleep", Slm_Orn_Sleep);
		variable_instance_set(target, "s_death", Slm_Orn_Death);		
	}
	else if color_num=6
	{
		target.sprite_index=Slm_Yel_Idol
		variable_instance_set(target, "s_idol", Slm_Yel_Idol);
		variable_instance_set(target, "s_sleep", Slm_Yel_Sleep);
		variable_instance_set(target, "s_death", Slm_Yel_Death);		
	}
	else if color_num=7
	{
		target.sprite_index=Slm_Wht_Idol
		variable_instance_set(target, "s_idol", Slm_Wht_Idol);
		variable_instance_set(target, "s_sleep", Slm_Wht_Sleep);
		variable_instance_set(target, "s_death", Slm_Wht_Death);		
	}
	else if color_num=8
	{
		target.sprite_index=Slm_Blk_Idol
		variable_instance_set(target, "s_idol", Slm_Blk_Idol);
		variable_instance_set(target, "s_sleep", Slm_Blk_Sleep);
		variable_instance_set(target, "s_death", Slm_Blk_Death);		
	}

}
