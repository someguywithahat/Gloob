if fade_state="out"
{
	fade_alpha += 1/fade_out_frames
	if fade_alpha>=1
	{
		fade_alpha = 1
		fade_state = "hold"
		fade_timer = fade_hold_frames
		show_debug_message("[fade] black, going to "+room_get_name(fade_target))
		room_goto(fade_target)
		fade_target = noone
	}
}
else if fade_state="hold"
{
	fade_alpha = 1
	fade_timer--
	if fade_timer<=0
		fade_state = "in"
}
else if fade_state="in"
{
	fade_alpha -= 1/fade_in_frames
	if fade_alpha<=0
	{
		fade_alpha = 0
		fade_state = ""
	}
}
