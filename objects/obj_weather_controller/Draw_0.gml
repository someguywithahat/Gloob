if (weather_alpha>0) {
    draw_set_color(c_black);
    draw_set_alpha(weather_alpha); // 0 = transparent, 1 = solid
    draw_rectangle(0, 0, display_get_width(), display_get_height(), false);
    draw_set_alpha(1); // reset alpha
}

if(snow_alpha>0)
{
	draw_set_alpha(snow_alpha);
	draw_set_color(make_color_rgb(100, 140, 255)); // pale icy blue
	draw_rectangle(0, 0, display_get_width(), display_get_height(), false);
	draw_set_alpha(1);
	draw_set_color(c_white);
}
//if isNight<>0
if isNightShader<>0
{
    draw_set_color(c_black);
    draw_set_alpha(isNightShader); // 0 = transparent, 1 = solid
    draw_rectangle(0, 0, display_get_width(), display_get_height(), false);
    draw_set_alpha(1); // reset alpha
}

if toggle_debug_options<1
{
	toggle_debug_options=scr_draw_menu_item(text_xx,730,"Toggle Debug",toggle_debug_options)
}
else 
{
	toggle_night=scr_draw_menu_item(text_xx,610,"End Day",toggle_night)
	toggle_add_obs=scr_draw_menu_item(text_xx,640,"Add Obstacle",toggle_add_obs)	
	toggle_rain=scr_draw_menu_item(text_xx,670,"Toggle Rain",toggle_rain)	
	toggle_snow=scr_draw_menu_item(text_xx,700,"Toggle Snow",toggle_snow)	
	toggle_leaves=scr_draw_menu_item(text_xx,730,"Toggle Fall",toggle_leaves)	
}


