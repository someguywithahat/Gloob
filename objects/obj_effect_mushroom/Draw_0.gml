//Shadow on the ground, smaller while it's in the air
var shadow_w = 5 - height*0.3
draw_set_color(c_black)
draw_set_alpha(0.25)
draw_ellipse(ground_x-shadow_w, ground_y+5, ground_x+shadow_w, ground_y+8, false)
draw_set_alpha(1)
draw_set_color(c_white)

//Mushroom, lifted by the hop and facing the way it's going.
//Flipping a top left origin sprite mirrors it to the left, so shift it back over
var w = sprite_get_width(sprite_index)
var draw_x = (facing<0) ? x+w : x
draw_sprite_ext(sprite_index, image_index, draw_x, y-height, facing, 1, 0, c_white, 1)
