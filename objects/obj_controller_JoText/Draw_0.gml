//draw_set_colour(c_white);
//draw_text(20, 100, "HIYA  We can test text here");

//draw_text(20, 140, "More text");

////draw_set_font(fnt_Game);
//draw_set_colour(c_blue);
//draw_text(20, 180, "Blue Font ");

if player_count>0{
	draw_set_font(global.fnt_Gloop);
	draw_set_color(c_blue);
	
	var w = string_width(label_menu1)
	var h = string_height(label_menu1)
	draw_rectangle(xx_menu1-4,yy_menu1-4,xx_menu1+w+4,yy_menu1+h+4,false)	
	
	
	draw_set_color(c_white);	
	if (mouse_x > xx_menu1-4 && mouse_x < xx_menu1+w+4 &&
    mouse_y > yy_menu1-4 && mouse_y < yy_menu1+h+4)
	{
		draw_set_color(c_lime);
	} 
	draw_text(xx_menu1, yy_menu1, label_menu1);
	
	
	

	draw_set_color(c_blue);
	
	w = string_width(label_menu2)
	h = string_height(label_menu2)
	draw_rectangle(xx_menu2-4,yy_menu2-4,xx_menu2+w+4,yy_menu2+h+4,false)	
	
	
	draw_set_color(c_white);	
	if (mouse_x > xx_menu2-4 && mouse_x < xx_menu2+w+4 &&
    mouse_y > yy_menu2-4 && mouse_y < yy_menu2+h+4)
	{
		draw_set_color(c_lime);
	} 
	draw_text(xx_menu2, yy_menu2, label_menu2);	
	
	
	

	
}