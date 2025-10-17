function scr_get_jump_sprite(nextXX, xx, prevXX, number_of_frames){
	var total_distance = abs(nextXX - prevXX)
	var progress = abs(xx - prevXX)	
	var progress_percent = progress/total_distance
	
	return round(number_of_frames * progress_percent)

}