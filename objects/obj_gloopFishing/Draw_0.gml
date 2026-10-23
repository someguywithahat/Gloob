//Face the way it's sailing.  The sprite has a top left origin, so shift it back over when it's flipped
var draw_x = (facing<0) ? x+sprite_width : x
draw_sprite_ext(sprite_index, image_index, draw_x, y, facing, 1, 0, c_white, image_alpha)
