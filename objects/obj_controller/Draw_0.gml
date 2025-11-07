

if room == rm_gameScreen{
		
	
	scr_draw_score(score_xx, score_yy, remaining_grid)
	scr_draw_score(score_xx+80, score_yy, grid_size)
	
	for(var s=0; s<7; s++){
		draw_sprite(spr_gridOutline_Lg,0,start_x-(spacing),128*s)
		draw_sprite(spr_gridOutline_Lg,0,start_x +((cols-1)*spacing),128*s)
		
	}
	
	
	//for(var s=0; s<number_of_players; s++){
	//	scr_draw_sign(5,20+((number_of_players-1-s)*95),200,60,1,2,0,0)
		
	//}
	
}


if room== rm_titleScreen
{
	scr_draw_sign(500,410,340,140,2,0,2,4)
	
	
	
	clicked_quickstart=scr_draw_menu_item(600,440,"QUICKSTART",clicked_quickstart)	
	clicked_character_select=scr_draw_menu_item(550,480,"CHARACTER SELECT",clicked_character_select)
	clicked_debugRoom=scr_draw_menu_item(1,1,"Debug Room",clicked_debugRoom)
}

if isPaused=1
{
	scr_draw_sign(200,pauseMenuY,1000,500,3,10,0,4)	
	
	if pauseMenuY<pauseMenuyMax
		pauseMenuY=pauseMenuY+50
	else 
	{
		scr_draw_menu_item(270,200,"Resume",noone)
		scr_draw_menu_item(270,250,"Return To Main Menu",noone)
		scr_draw_menu_item(270,300,"Quit Game",noone)
		
		
		scr_draw_menu_item(270,450,"BGM",noone)
		scr_draw_menu_item(270,500,"SFX",noone)
	}
	
}
if isPaused=-1
{
	if pauseMenuY>pauseMenuyMin
		pauseMenuY=pauseMenuY-50
	else
		isPaused=0
	scr_draw_sign(200,pauseMenuY,1000,500,3,10,0,4)	
	
	
}


if room == rm_testRoom1{
	scr_draw_sign(500,410,340,140,2,0,2,4)
	draw_sprite_ext(Spr_Slm_Idol,1,660,560,4,4,0,c_white,1)
	clicked_quickstart=scr_draw_menu_item(560,430,"New High Score!",noone)	
	clicked_quickstart=scr_draw_menu_item(560,460,"Enter Initials:",noone)	
	clicked_quickstart=scr_draw_menu_item(580,490,"_ _ _",noone)	
	
}