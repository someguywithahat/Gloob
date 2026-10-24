if is_undefined(fish_data)
	exit

//Its fish was just caught: open up (after the minigame closes, so the player sees it)
if !is_open and !opening and scr_fish_is_caught(fish_data.name) and !instance_exists(obj_fishing_minigame)
{
	opening = true
	shell_frame = 0
	audio_play_sound(snd_achievement, 1, false)
}

if opening
{
	shell_frame += open_speed*sprite_get_speed(Spr_Shell)/game_get_speed(gamespeed_fps)
	var last = sprite_get_number(Spr_Shell)-1
	if shell_frame>=last
	{
		shell_frame = last
		opening = false
		is_open = true
	}
}

//The fish swims around in its bowl once it's showing
if is_open or opening
	bowl_frame += sprite_get_speed(bowl_sprite)/game_get_speed(gamespeed_fps)
