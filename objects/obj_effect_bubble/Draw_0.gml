//x/y is the bubble's center.  In Spr_Pu_Bubble the bubble sits at (32,32) and the origin is (16,16),
//so draw 16 pixels (scaled) up and left of the center
var offset = 16*bubble_scale
draw_sprite_ext(Spr_Pu_Bubble, floor(frame), x-offset, y-offset, bubble_scale, bubble_scale, 0, c_white, 1)
