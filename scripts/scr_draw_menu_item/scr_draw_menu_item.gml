//Text that turns green when hovered.  Returns 0 if hovered, or 1 if just clicked
function scr_draw_menu_item(xx,yy,text,hover_or_click){
	//draw_set_font(fnt_menu);
	draw_set_font(global.fnt_Gloop)
	
	//var w = string_width(text)
	var w = string_width(text)
	var h = string_height(text)
	var clicked = 0
	
	
	draw_set_color(c_white);	
	if (mouse_x > xx-4 && mouse_x < xx+w+4 &&
    mouse_y > yy-4 && mouse_y < yy+h+4) and hover_or_click<>noone
	{
		draw_set_color(c_lime);
		if hover_or_click<0{
			hover_or_click=0
		}
		
		if mouse_check_button_pressed(mb_left)
		{
			var snd = audio_play_sound(snd_slime_move, 1, false);
			audio_sound_pitch(snd, random_range(0.9, 1.2));
			hover_or_click=1
		}
		
	} 
	else 
		hover_or_click=-1
	draw_text(xx, yy, text);
	
	return hover_or_click	
}


//Image that turns green when hovered.  Returns 0 if hovered, or 1 if just clicked
function scr_draw_menu_spr(xx, yy, spr, spr_index, hover_or_click){

	var w = sprite_get_width(spr)
	var h = sprite_get_height(spr)
	var clicked = 0
	var draw_color = c_white
	
	

	if (mouse_x > xx+1 && mouse_x < xx+w-1 &&
    mouse_y > yy+1 && mouse_y < yy+h-1) and hover_or_click<>noone
	{
		draw_color = c_lime
		if hover_or_click<0{
			hover_or_click=0
		}
		
		if mouse_check_button_pressed(mb_left)
		{
			var snd = audio_play_sound(snd_slime_move, 1, false);
			audio_sound_pitch(snd, random_range(0.9, 1.2));
			hover_or_click=1
		}
		
	} 
	else 
		hover_or_click=-1
	
	draw_sprite_ext(spr, spr_index, xx, yy,1,1,0,draw_color,1)
	
	return hover_or_click	
}




function scr_draw_text(xx,yy,text,centered){
	draw_set_font(global.fnt_Gloop)
	
	var w = string_width(text)
	var h = string_height(text)

	if centered=1
		xx-=(w/2)
	
	draw_set_color(c_white);	

	draw_text(xx, yy, text);	
}