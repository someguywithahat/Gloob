//Moused over: the catch net under it, at half size.  Faded out when it can't be caught (too far away, or no tickets)
if hovered
{
	var can_catch = in_range and has_ticket
	var net_scale = 0.5
	var net_x = (bbox_left+bbox_right)/2 - sprite_get_width(Spr_Catch_net)/2*net_scale
	var net_y = (bbox_top+bbox_bottom)/2 - sprite_get_height(Spr_Catch_net)/2*net_scale
	draw_sprite_ext(Spr_Catch_net, 0, net_x, net_y, net_scale, net_scale, 0, can_catch ? c_white : c_gray, can_catch ? 1 : 0.35)
}

//Face the way it's swimming.  The sprite has a top left origin, so shift it back over when it's flipped
var facing = (vx<0) ? -1 : 1
if !jumping
{
	var draw_x = (facing<0) ? x+sprite_width : x
	draw_sprite_ext(sprite_index, image_index, draw_x, y, facing, 1, 0, c_white, image_alpha)
	exit
}

//---- In the air: shadow on the water, and the fish up above it, tilted along its arc ----
var t = jump_time/jump_frames
var lift = jump_lift()
var size = 1 + jump_grow*sin(pi*t)
var mid_x = x + sprite_width/2
var mid_y = y + sprite_height/2

var shadow_w = sprite_width*0.45*(1 - 0.4*lift/jump_height)
draw_set_color(c_black)
draw_set_alpha(0.25*(1 - 0.5*lift/jump_height))
draw_ellipse(mid_x-shadow_w, mid_y+2, mid_x+shadow_w, mid_y+8, false)
draw_set_alpha(1)
draw_set_color(c_white)

//Turn around the middle: rotate the top left corner (-half, -half) by the angle, like obj_lilypad does
var a = jump_facing*lerp(jump_tilt, -jump_tilt, t)
var half_w = sprite_width/2*size*jump_facing
var half_h = sprite_height/2*size
var corner_x = -half_w*dcos(a) + -half_h*dsin(a)
var corner_y =  half_w*dsin(a) + -half_h*dcos(a)
draw_sprite_ext(sprite_index, image_index, mid_x+corner_x, mid_y-lift+corner_y, jump_facing*size, size, a, c_white, image_alpha)
