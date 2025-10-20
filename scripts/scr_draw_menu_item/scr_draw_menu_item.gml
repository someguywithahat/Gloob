function scr_draw_menu_item(xx,yy,text,highlighted){
	draw_set_font(fnt_menu);
	
	var w = string_width(text)
	var h = string_height(text)
	var clicked = 0
	
	draw_set_color(c_white);
	draw_rectangle(xx-6,yy-6,xx+w+6,yy+h+6,false)	
	
	draw_set_color(c_black);
	draw_rectangle(xx-4,yy-4,xx+w+4,yy+h+4,false)	
	
	
	draw_set_color(c_white);	
	if (mouse_x > xx-4 && mouse_x < xx+w+4 &&
    mouse_y > yy-4 && mouse_y < yy+h+4)
	{
		draw_set_color(c_lime);
		
		if mouse_check_button_pressed(mb_left)
			clicked=1
		
	} 
	draw_text(xx, yy, text);
	return clicked
}