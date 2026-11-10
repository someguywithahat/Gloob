//First step: find this bowl's fish (creation code has set fish_name by now)
if bowl_sprite=-1
{
	bowl_sprite = asset_get_index("Spr_Bowl_" + fish_name)
	if bowl_sprite=-1
	{
		show_debug_message("obj_trophy_bowl: no bowl sprite for fish \"" + fish_name + "\"")
		bowl_sprite = -2 //Don't look again
	}
}

caught = fish_name<>"" and scr_fish_is_caught(fish_name)

//The fish swims around in its bowl
if caught and bowl_sprite>=0
	frame += sprite_get_speed(bowl_sprite)/game_get_speed(gamespeed_fps)
