var gloop = instance_find(obj_trophy_gloop, 0)
var following = gloop<>noone and !gloop.leaving

//---- Camera: zoomed in on Gloop while he's out, the whole room otherwise ----
zoom = lerp(zoom, following ? zoom_in : 1, zoom_speed)
if abs(zoom-1)<0.002
	zoom = 1
var view_w = room_width/zoom
var view_h = room_height/zoom
var want_x = following ? gloop.x : room_width/2
var want_y = following ? gloop.y-follow_above : room_height/2
view_cx = lerp(view_cx, want_x, pan_speed)
view_cy = lerp(view_cy, want_y, pan_speed)
var left = clamp(view_cx-view_w/2, 0, room_width-view_w)
var top = clamp(view_cy-view_h/2, 0, room_height-view_h)
camera_set_view_size(cam, view_w, view_h)
camera_set_view_pos(cam, left, top)

//---- Clicks ----
if scr_room_fading_out()
	exit
var pressed = mouse_check_button_pressed(mb_left)
var held = mouse_check_button(mb_left)

//Exit sign: back to the dock, where Gloop hops back in his boat (scr_fishing_room_start)
if pressed and exit_hover()
{
	var snd = audio_play_sound(snd_slime_move, 1, false)
	audio_sound_pitch(snd, random_range(0.9, 1.2))
	global.fishing_from_dock = true
	scr_room_goto(exit_room)
	exit
}

//No Gloop yet: clicking a shelf brings him in, jumping in from the nearer side of the room
if gloop=noone
{
	var shelf = shelf_at(mouse_x, mouse_y)
	if pressed and shelf>=0
	{
		var from_left = mouse_x<room_width/2
		gloop = instance_create_layer(from_left ? -40 : room_width+40, shelf_ys[shelf]+40, "Instances", obj_trophy_gloop)
		gloop.jump_to(from_left ? shelf_left+entry_in : shelf_right-entry_in, shelf_ys[shelf], 70)
	}
	exit
}

//Clicking the bowl he's standing on, for a fish with a click sound (see obj_trophy_gloop's click_sounds):
//plays it instead of hopping.  Holding the button after doesn't hop either, until it's let go
if !held
	click_used = false
if pressed and gloop.state="stand"
{
	var bowl = instance_position(mouse_x, mouse_y, obj_trophy_bowl)
	if bowl<>noone and gloop.reacting_to(bowl) and variable_struct_exists(gloop.click_sounds, bowl.fish_name)
	{
		audio_play_sound(gloop.click_sounds[$ bowl.fish_name], 1, false)
		click_used = true
	}
}

//Click: one hop toward the cursor.  Hold: keeps hopping each time he lands, until he gets there
if (pressed or held) and !click_used and !gloop.leaving and gloop.state="stand" and gloop.rest<=0
	hop_toward(gloop, mouse_x, mouse_y, pressed)
