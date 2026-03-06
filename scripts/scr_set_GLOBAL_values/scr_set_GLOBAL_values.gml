
function scr_set_GLOBAL_values(){
	scr_set_global_values_accessory()
	scr_gloop_strings()
	scr_shop_items()
	global.FALL = 3
	global.WINTER = 1
	global.SPRING = 2
	global.SUMMER = 0
	
	global.music_volume=1
	global.sfx_volume=1
	
	global.BLACK=0
	global.BLUE=1
	global.GREEN=2
	global.ORANGE=3
	global.PURPLE=4
	global.RED=5
	global.WHITE=6
	global.YELLOW=7
	global.RAINBOW=8
	
/*
PU_SPRITES[0]=Spr_Pu_Hat_Sign
PU_SPRITES[1]=Spr_Pu_Tel_Fairy_Sign
PU_SPRITES[2]=Spr_Pu_RB_SM_Full
PU_SPRITES[3]=Spr_Pu_Crown_Sign
PU_SPRITES[4]=Spr_Pu_Shroom_Sign
PU_SPRITES[5]=Spr_Pu_Bubble_Sign
PU_SPRITES[6]=Spr_Pu_Bee_sign
PU_SPRITES[7]=Spr_Pu_Fish_Sign
PU_SPRITES[8]=Spr_Pu_Grass_Sign
*/
	global.PU_SIGN=0
	global.PU_FAIRY=1
	global.PU_RAINBOW=2
	global.PU_CROWN=3
	global.PU_SHROOM=4
	global.PU_BUBBLE=5
	global.PU_BEE=6
	global.PU_FISH=7
	global.PU_GRASS=8
	
	global.mouseDrag=0
	
	global.controller_default_season_goal_percentage=0.05
}