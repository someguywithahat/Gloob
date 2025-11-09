if (weather_alpha>0) {
    draw_set_color(c_black);
    draw_set_alpha(weather_alpha); // 0 = transparent, 1 = solid
    draw_rectangle(0, 0, display_get_width(), display_get_height(), false);
    draw_set_alpha(1); // reset alpha
}


toggle_snow=scr_draw_menu_item(text_xx,670,"Toggle Snow",toggle_snow)	
toggle_rain=scr_draw_menu_item(text_xx,700,"Toggle Rain",toggle_rain)	
toggle_leaves=scr_draw_menu_item(text_xx,730,"Toggle Fall",toggle_leaves)	