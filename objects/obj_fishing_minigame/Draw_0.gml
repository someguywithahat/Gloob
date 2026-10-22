//---- Pond ----
draw_set_alpha(0.9)
draw_set_color(box_color)
draw_rectangle(box_x, box_y, box_x+box_size, box_y+box_size, false)
draw_set_alpha(1)
draw_set_color(c_white)
draw_rectangle(box_x, box_y, box_x+box_size, box_y+box_size, true)

//---- Fish (sprite is 24x24 with a top left origin, flipped to face the way it's swimming) ----
var half_fish = sprite_get_width(fish.sprite)/2
draw_sprite_ext(fish.sprite, floor(fish.frame), fish.x-half_fish*fish.facing, fish.y-half_fish, fish.facing, 1, 0, c_white, 1)

//---- Circle: turns yellow while the fish is inside ----
draw_set_color(fish_in_circle ? c_yellow : c_white)
draw_circle(circle_x, circle_y, circle_radius, true)
draw_circle(circle_x, circle_y, circle_radius-1, true)

//---- Green bar: fills up from the bottom ----
var bar_top = box_y + box_size*(1-bar_fill)
draw_set_color(c_black)
draw_set_alpha(0.4)
draw_rectangle(bar_x, box_y, bar_x+bar_width, box_y+box_size, false)
draw_set_alpha(1)
draw_set_color(c_lime)
if bar_fill>0
	draw_rectangle(bar_x, bar_top, bar_x+bar_width, box_y+box_size, false)
draw_set_color(c_white)
draw_rectangle(bar_x, box_y, bar_x+bar_width, box_y+box_size, true)

//---- Result ----
if result<>0
{
	draw_set_font(global.fnt_Gloop)
	var text = (result=1) ? "Caught a " + fish.name + "!" : "The " + fish.name + " got away..."
	draw_text(box_x + (box_size-string_width(text))/2, box_y - string_height(text) - 10, text)
}
draw_set_color(c_white)
