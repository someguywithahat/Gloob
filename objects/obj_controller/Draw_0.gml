

if room == rm_gameScreen{
	
	remaining_grid=0
	with(obj_gridNumber)
	{
		if wall=0
			other.remaining_grid+=activeNumber
	}
	
	
	scr_draw_score(score_xx, score_yy, remaining_grid)
	scr_draw_score(score_xx+80, score_yy, grid_size)
}