
if isfishing=-1
{
	var hook_x=x-80
	var hook_y=y+40
	var sway = sin(current_time / 200 + x) * 2;
	draw_set_colour(c_white)
	draw_line(x, y, hook_x + sway, hook_y);
}

if isfishing=10
{
	draw_set_colour(c_aqua)
	draw_rectangle(catchx,catchy,catchx+catchw,catchy+catchw,true)
	draw_set_colour(c_white)
	draw_sprite(target_fish,target_frame,target_fishx,target_fishy)
	target_frame+=target_frame_speed
	
	draw_circle(hookx,hooky,20,true)
}


