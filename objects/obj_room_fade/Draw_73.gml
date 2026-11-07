//Draw End, at the lowest depth, so it covers everything in the room, menus included.  Covers the camera's view (or the whole room with no view)
var vx = 0
var vy = 0
var vw = room_width
var vh = room_height
if view_enabled and view_visible[0]
{
	var cam = view_camera[0]
	vx = camera_get_view_x(cam)
	vy = camera_get_view_y(cam)
	vw = camera_get_view_width(cam)
	vh = camera_get_view_height(cam)
}

if fade_alpha<=0
	exit
shader_reset()
gpu_set_blendmode(bm_normal)
draw_set_alpha(fade_alpha)
draw_set_color(fade_color)
draw_rectangle(vx-2, vy-2, vx+vw+2, vy+vh+2, false)
draw_set_alpha(1)
draw_set_color(c_white)
