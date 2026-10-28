//Moused over: the catch net under it, at half size.  Faded out when the boat is too far away to catch it
if hovered
{
	var net_scale = 0.5
	var net_x = (bbox_left+bbox_right)/2 - sprite_get_width(Spr_Catch_net)/2*net_scale
	var net_y = (bbox_top+bbox_bottom)/2 - sprite_get_height(Spr_Catch_net)/2*net_scale
	draw_sprite_ext(Spr_Catch_net, 0, net_x, net_y, net_scale, net_scale, 0, in_range ? c_white : c_gray, in_range ? 1 : 0.35)
}

//Face the way it's swimming.  The sprite has a top left origin, so shift it back over when it's flipped
var facing = (vx<0) ? -1 : 1
var draw_x = (facing<0) ? x+sprite_width : x
draw_sprite_ext(sprite_index, image_index, draw_x, y, facing, 1, 0, c_white, image_alpha)
