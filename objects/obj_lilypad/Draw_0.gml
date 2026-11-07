var half = sprite_get_width(sprite_index)/2

//Ripples on the water from bumps
draw_set_color(c_white)
for (var i = 0; i < array_length(ripples); i++)
{
	var r = ripples[i]
	var t = r.age/40
	draw_set_alpha((1-t)*0.45)
	draw_ellipse(r.x-10-t*14, r.y-6-t*8, r.x+10+t*14, r.y+6+t*8, true)
}
draw_set_alpha(1)

//The pad, rotated around its middle.  Rotate the top left corner (-half, -half) by the angle
var a = turn + sin(sway_time*0.03)*sway_amount
var corner_x = -half*dcos(a) + -half*dsin(a)
var corner_y =  half*dsin(a) + -half*dcos(a)
draw_sprite_ext(sprite_index, image_index, pad_x+corner_x, pad_y+corner_y, 1, 1, a, c_white, 1)
