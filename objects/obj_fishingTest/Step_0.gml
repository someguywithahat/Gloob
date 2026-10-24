fish_frame += sprite_get_speed(Spr_Fish_Gold)/game_get_speed(gamespeed_fps)

//Click: play a round with this exact fish
if mouse_check_button_pressed(mb_left) and !instance_exists(obj_fishing_minigame)
	and point_in_rectangle(mouse_x, mouse_y, x, y, x+button_size, y+button_size)
{
	global.fishing_test_fish = global.FISH_GROUPS[fish_group][fish_index] //obj_fishing_minigame picks this up and clears it
	instance_create_depth(0, 0, -15000, obj_fishing_minigame)
}
