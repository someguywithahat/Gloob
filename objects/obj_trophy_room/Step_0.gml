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

//Click: one hop toward the cursor.  Hold: keeps hopping each time he lands, until he gets there
if (pressed or held) and !gloop.leaving and gloop.state="stand" and gloop.rest<=0
	hop_toward(gloop, mouse_x, mouse_y, pressed)
