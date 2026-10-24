var data = global.FISH_GROUPS[fish_group][fish_index]
var hovered = point_in_rectangle(mouse_x, mouse_y, x, y, x+button_size, y+button_size)

//Fish, a little faded unless the mouse is over it
draw_sprite_ext(data.sprite, floor(fish_frame), x, y, 1, 1, 0, c_white, hovered ? 1 : 0.8)

//Name underneath
draw_set_font(global.fnt_Gloop_small)
draw_set_color(hovered ? c_yellow : c_white)
draw_text(x + (button_size-string_width(data.name))/2, y+button_size+2, data.name)
draw_set_color(c_white)
