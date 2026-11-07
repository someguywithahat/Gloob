/// Fade to black, then go to target_room (it fades back in there).  See obj_room_fade.
/// Calling it again while it's already fading out does nothing, so double clicks only change rooms once
function scr_room_goto(target_room)
{
	var fader = scr_room_fade_get()
	if fader.fade_state="out" or fader.fade_target<>noone
		return;
	show_debug_message("[fade] fading out to "+room_get_name(target_room))
	fader.fade_target = target_room
	fader.fade_state = "out"
}

/// True while the screen is fading out to change rooms.  Good for ignoring clicks
function scr_room_fading_out()
{
	if !instance_exists(obj_room_fade)
		return false;
	return obj_room_fade.fade_state="out";
}

/// The fader, made if it doesn't exist yet
function scr_room_fade_get()
{
	if !instance_exists(obj_room_fade)
		return instance_create_depth(0, 0, -60000, obj_room_fade);
	return instance_find(obj_room_fade, 0);
}
