

if room == rm_gameScreen{
	
	remaining_grid=0
	with(obj_gridNumber)
	{
		if wall=0
			other.remaining_grid+=activeNumber
	}
	
	
	scr_draw_score(score_xx, score_yy, remaining_grid)
	scr_draw_score(score_xx+80, score_yy, grid_size)
	
	
	//var score_percentage = 0.0+ (remaining_grid/grid_size) 
	
	//var spr = Trl_Grn_Mid
	////spr.image_angle=90
	//var frame = 0; // or image_index
	//var half_height = (sprite_get_height(spr) *score_percentage)*4;
	
	//draw_set_color(c_black);
	//draw_rectangle(score_xx+160,score_yy,score_xx+160+spacing, score_yy+(spacing*2),false)
	//// Draw only the bottom half:
	//draw_sprite_part(
	//    spr,
	//    frame,
	//    0,              // left edge (x offset within sprite)
	//    half_height,    // start halfway down
	//    sprite_get_width(spr),
	//    half_height,    // draw the bottom half height
	//    score_xx+160,
	//    score_yy+(spacing) // adjust so it lines up nicely
	//);
	
	
	//var spr = Trl_Grn_Mid
	//// Save current scissor state
	////gpu_set_scissor(true);

	//// Define the clipping area (screen rectangle where drawing is allowed)
	//gpu_set_scissor(20, 20, sprite_get_width(spr), sprite_get_height(spr) / 2);

	//// Draw your rotated sprite as usual
	//draw_sprite_ext(spr, 1, 20, 20, 1, 1, 90, c_white, 1);

	//// Disable scissor so other draw calls aren’t clipped
	////gpu_set_scissor(false);

	
}


if room== rm_titleScreen
{

	clicked_quickstart=scr_draw_menu_item(600,440,"QUICKSTART",clicked_quickstart)	
	clicked_character_select=scr_draw_menu_item(550,480,"CHARACTER SELECT",clicked_character_select)
	clicked_debugRoom=scr_draw_menu_item(1,1,"Debug Room",clicked_debugRoom)
	

}