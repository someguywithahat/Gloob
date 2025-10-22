function scr_get_jump_sprite(nextXX, xx, prevXX, number_of_frames){
	var total_distance = abs(nextXX - prevXX)
	var progress = abs(xx - prevXX)	
	var progress_percent = progress/total_distance
	
	var frame = round(number_of_frames * progress_percent)
	if frame>0 and frame=number_of_frames
		frame-=1
	return round(frame)

}