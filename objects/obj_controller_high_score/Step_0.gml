

if scroll_left>0
{
	scroll_left=0
	if gloop_image_index>0
		gloop_image_index--
}

if scroll_right>0
{
	scroll_right=0
	if gloop_image_index<sprite_get_number(Slm_All_Base_Expressions)-1
		gloop_image_index++
}



if (keyboard_check_pressed(vk_backspace))
{	
		
	if selected_initial=3
	{
		if initial3=""
			selected_initial--
		initial3=""
	}
	else if selected_initial=2
	{
		if initial2=""
			selected_initial--
		initial2=""
	}
	else if selected_initial=1
	{
		initial1=""
	}
		
	if selected_initial>1
		selected_initial--	
	keyboard_lastchar=""
}
else 
if keyboard_lastchar !=""
{
	var c = keyboard_lastchar;
	if (c != chr(13) && c != chr(10)) 
	{ 
		if (selected_initial=1) 
		{
		    initial1 = c;
			selected_initial++
		}
		else if (selected_initial=2) 
		{
		    initial2 = c;
			selected_initial++
		}
		else if (selected_initial=3)
		{
		    initial3 = c;			
		}

	}
	keyboard_lastchar=""
	
	if (c = chr(13) or c = chr(10)) 
	{
		show_debug_message("Save High Score HERE")	
		for(var i=array_length(global.high_scores)-1;i>score_rank;i--)
		{
			global.high_scores[i].gname=global.high_scores[i-1].gname
			global.high_scores[i].gscore=global.high_scores[i-1].gscore
			global.high_scores[i].gindex=global.high_scores[i-1].gindex
			global.high_scores[i].gcolor=global.high_scores[i-1].gcolor
		}
		global.high_scores[score_rank].gname = initial1+initial2+initial3
		global.high_scores[score_rank].gscore = gloop_score
		global.high_scores[score_rank].gindex = gloop_image_index
		global.high_scores[score_rank].gcolor = gloop_color_index		
		controller.game_over_status=10
		
		scr_save_high_score()
	}
	
}