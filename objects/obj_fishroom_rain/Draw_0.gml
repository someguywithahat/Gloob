//A little darker while it rains.  The drops draw over this
if dim_alpha>0
{
	draw_set_colour(c_black)
	draw_set_alpha(dim_alpha)
	draw_rectangle(0, 0, room_width, room_height, false)
	draw_set_alpha(1)
	draw_set_colour(c_white)
}
