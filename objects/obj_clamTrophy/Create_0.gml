/*
	Trophy clam on the island in rm_fishingCenter.  Each one belongs to one fish from group 0.
	It stays shut until that fish has been caught, then opens to show the fish in its bowl (Spr_Bowl_<fish name>).
	Made by scr_fishing_spawn_clams, which calls set_fish.  Catches are saved (scr_fish_mark_caught), so it stays open.

	Spr_Shell: frame 0 closed, 1-6 the lid lifts, 7 the lid comes off, 8-14 it opens up.  14 is fully open
*/
image_speed = 0 //Animated by hand below
fish_data = undefined
bowl_sprite = Spr_Empty_Bowl
bowl_frame = 0

shell_frame = 0
is_open = false
opening = false
open_speed = 2 //Opening animation speed, as a multiple of Spr_Shell's own speed
bowl_start_frame = 7 //Shell frame the bowl starts growing on (when the lid comes off)
mouth_y = -20 //Where the bottom of the bowl sits, from the clam's origin (the bottom middle of the shell)

/// Sets which fish this clam belongs to (a row from scr_fish_data).  A fish that's already been caught starts it open
set_fish = function(data)
{
	fish_data = data
	var bowl = asset_get_index("Spr_Bowl_" + data.name)
	if bowl<>-1
		bowl_sprite = bowl
	if scr_fish_is_caught(data.name)
	{
		is_open = true
		shell_frame = sprite_get_number(Spr_Shell)-1
	}
}

/// How grown the bowl is: 0 flat (lid just coming off) to 1 full size (fully open)
bowl_size = function()
{
	var last = sprite_get_number(Spr_Shell)-1
	return clamp((shell_frame-bowl_start_frame)/(last-bowl_start_frame), 0, 1)
}
