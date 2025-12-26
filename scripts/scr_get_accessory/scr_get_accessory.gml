/*
	To add an accessory, do the following
		Update global.MAX_ACCESSORY
		Add another else if statement
		update the sa_*** variables
*/
function scr_set_global_values_accessory(){
	//The total amount of accessories in the game.  
	global.MAX_ACCESSORY=5
}

//sets accessory
function scr_get_accessory(){	
	if has_accessory=1
	{
		sa = Spr_Acc_Cat
		sa_idol = Spr_Acc_Cat_Idol
		sa_sleep = Spr_Acc_Cat_Sleep
		sa_death = Spr_Acc_Cat_Stun
		sa_jump = Spr_Acc_Cat_Move_Jump
		sa_roll = Spr_Acc_Cat_Move_Roll
		sa_roll_R = Spr_Acc_Cat_Move_Spin
		sa_teleport = Spr_Acc_Cat_Tele
		sa_slurp = Spr_Acc_Cat_Move_Slurp
	}
	else if has_accessory=2
	{
		sa = Spr_Acc_Glasses
		sa_idol = Spr_Acc_Glasses_Idol
		sa_sleep = Spr_Acc_Glasses_Sleep
		sa_death = Spr_Acc_Glasses_Stun
		sa_jump = Spr_Acc_Glasses_Move_Jump
		sa_roll = Spr_Acc_Glasses_Move_Roll
		sa_roll_R = Spr_Acc_Glasses_Move_Spin
		sa_teleport = Spr_Acc_Glasses_Tele
		sa_slurp = Spr_Acc_Glasses_Move_Slurp
	}
	else if has_accessory=3
	{
		sa = Spr_Acc_Stash
		sa_idol = Spr_Acc_Stash_Idol
		sa_sleep = Spr_Acc_Stash_Sleep
		sa_death = Spr_Acc_Stash_Stun
		sa_jump = Spr_Acc_Stash_Move_Jump
		sa_roll = Spr_Acc_Stash_Move_Roll
		sa_roll_R = Spr_Acc_Stash_Move_Spin
		sa_teleport = Spr_Acc_Stash_Tele
		sa_slurp = Spr_Acc_Stash_Move_Slurp
	}
else if has_accessory=4
	{
		sa = Spr_Acc_Suns
		sa_idol = Spr_Acc_Suns_Idol
		sa_sleep = Spr_Acc_Suns_Sleep
		sa_death = Spr_Acc_Suns_Stun
		sa_jump = Spr_Acc_Suns_Move_Jump
		sa_roll = Spr_Acc_Suns_Move_Roll
		sa_roll_R = Spr_Acc_Suns_Move_Spin
		sa_teleport = Spr_Acc_Suns_Tele
		sa_slurp = Spr_Acc_Suns_Move_Slurp
	}
else if has_accessory=5
	{
		sa = Spr_Acc_Horns
		sa_idol = Spr_Acc_Horns_Idol
		sa_sleep = Spr_Acc_Horns_Sleep
		sa_death = Spr_Acc_Horns_Stun
		sa_jump = Spr_Acc_Horns_Move_Jump
		sa_roll = Spr_Acc_Horns_Move_Roll
		sa_roll_R = Spr_Acc_Horns_Move_Spin
		sa_teleport = Spr_Acc_Horns_Tele
		sa_slurp = Spr_Acc_Horns_Move_Slurp
	}
	///////////////////INSERT NEW SPRITES HERE///////////////////
	//else if has_accessory=3
	//{
	//	sa = Spr_Acc_Glasses					--Accessory Icon
	//	sa_idol = Spr_Acc_Glasses_Idol			--Idol
	//	sa_sleep = Spr_Acc_Glasses_Sleep		--Sleep
	//	sa_death = Spr_Acc_Glasses_Stun			--Stun
	//	sa_jump = Spr_Acc_Glasses_Move_Jump		--Jump
	//	sa_roll = Spr_Acc_Glasses_Move_Roll		--Roll
	//	sa_roll_R = Spr_Acc_Glasses_Move_Spin	--Spin
	//	sa_teleport = Spr_Acc_Glasses_Tele		--Tele
	//	sa_slurp = Spr_Acc_Glasses_Move_Slurp	--Slurp
	//}
	
	else 
	{	
		//No accessory code
		sa = spr_effect_heart
		sa_idol = noone
		sa_sleep = noone
		sa_death = noone
		sa_jump = noone
		sa_roll = noone
		sa_roll_R = noone
		sa_teleport = noone
		sa_slurp = noone
	}
}