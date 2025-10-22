//This script makes the slime move slower at the beginning and end of the jump.
function scr_get_jump_speed(nextXX, xx, prevXX, gloop_speed){
	var total_distance = abs(nextXX - prevXX)
	var progress = abs(xx - prevXX)	
	var progress_percent = progress/total_distance
	
	
	if progress_percent>.5
		progress_percent = 1-progress_percent
	if progress_percent<.2
		progress_percent=.2		
	progress_percent = progress_percent *2
	
	//show_debug_message("progress_precent" + string(progress_percent)  + " " + string(gloop_speed * progress_percent))
	return round(gloop_speed * progress_percent)

}


function scr_get_jump_speed2(gloop_frame){
	if gloop_frame = 0 //or gloop_frame =7
		return 0.5
	//else if gloop_frame = 1 or gloop_frame =6
	//	return 0.7
	else 
		return 1.3
	//show_debug_message("progress_precent" + string(progress_percent)  + " " + string(gloop_speed * progress_percent))
	//return round(gloop_speed * progress_percent)

}

//function scr_get_jump_speed2(gloop_frame){
//	if gloop_frame = 0 //or gloop_frame =7
//		return 0.8
//	//else if gloop_frame = 1 or gloop_frame =6
//	//	return 0.7
//	else 
//		return 1.3
//	//show_debug_message("progress_precent" + string(progress_percent)  + " " + string(gloop_speed * progress_percent))
//	//return round(gloop_speed * progress_percent)

//}