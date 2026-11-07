//Draw GUI End: on top of everything, menus included
if fade_alpha<=0
	exit
shader_reset()
gpu_set_blendmode(bm_normal)
draw_set_alpha(fade_alpha)
draw_set_color(fade_color)
draw_rectangle(-1, -1, display_get_gui_width()+1, display_get_gui_height()+1, false)
draw_set_alpha(1)
draw_set_color(c_white)
