/*
	Trophy clam.  Place these in the fishing rooms in the room editor.  Each one belongs to one fish.
	It stays shut until that fish has been caught, then opens to show the fish in its bowl (Spr_Bowl_<fish name>).
	Catches are saved (scr_fish_mark_caught), so it stays open.

	Set in the instance's creation code:
		fish_index -- which fish in the group, 0-7 (scr_fish_data order)
		fish_group -- optional.  Leave it at -1 to use the room's fish group (scr_fishing_room_info)

	Spr_Shell: frame 0 closed, 1-6 the lid lifts, 7 the lid comes off, 8-14 it opens up.  14 is fully open
*/
image_speed = 0 //Animated by hand below
fish_index = 0 //Which fish in the group (set in creation code)
fish_group = -1 //-1 = this room's fish group
fish_data = undefined //Looked up on the first step, after creation code has run
bowl_sprite = Spr_Empty_Bowl
bowl_frame = 0

shell_frame = 0
is_open = false
opening = false
open_speed = 2 //Opening animation speed, as a multiple of Spr_Shell's own speed
bowl_start_frame = 7 //Shell frame the bowl starts growing on (when the lid comes off)
mouth_y = -20 //Where the bottom of the bowl sits, from the clam's origin (the bottom middle of the shell)
bowl_lower = 0.3 //Then moved down this much of the bowl's height, so it sits lower in the mouth

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
