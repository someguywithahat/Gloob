// Simple centered text button
draw_set_font(fnt_menu);
draw_set_color(c_blue);

var w = string_width(label)
var h = string_height(label)
draw_rectangle(xx1-4,yy1-4,xx1+w+4,yy1+h+4,false)


draw_set_color(c_white);


if (position_meeting(mouse_x, mouse_y, id)) {
    draw_set_color(c_lime);
}

draw_text(xx1, yy1, label);
draw_set_color(c_white);


