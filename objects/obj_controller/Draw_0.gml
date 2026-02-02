

if room == rm_gameScreen{
		
	scr_draw_menu_item(1170,20,"Goal "+string(season_goal_percentage*100)+"%",noone)
	if season_goal>0
		scr_draw_menu_item(1170,56,string(season_goal)+ " left",noone)
	else {
		scr_draw_menu_item(1130,56,"Goal Reached",noone)
		if game_over_status<1
			clicked_end_day = scr_draw_menu_item(1170,92,"End Day?",clicked_end_day)
	}
	
	//scr_draw_score(score_xx, score_yy, remaining_grid)
	//scr_draw_score(score_xx+80, score_yy, grid_size)
	
	if global.weather<>3{
		for(var s=0; s<7; s++){
			draw_sprite(spr_gridOutline_Lg,0,start_x-(spacing),128*s)
			draw_sprite(spr_gridOutline_Lg,0,start_x +((cols-1)*spacing),128*s)
		
		}
	}
	else
	{	
		// Start shader
		shader_set(shd_palette_swap);
		// Set uniforms
		var u_palette_orig = shader_get_sampler_index(shd_palette_swap, "palette_orig");
		var u_palette_swap = shader_get_sampler_index(shd_palette_swap, "palette_swap");
		var u_color_count  = shader_get_uniform(shd_palette_swap, "color_count");
		// Bind your palette sprites as textures
		texture_set_stage(u_palette_orig, sprite_get_texture(spr_palette_seasons_index, 0));
		texture_set_stage(u_palette_swap, sprite_get_texture(spr_palette_seasons_all, 1));
		// Send color count
		shader_set_uniform_f(u_color_count, 6.0);
		// Draw the sprite
		for(var s=0; s<7; s++){
			draw_sprite(spr_gridOutline_Lg,0,start_x-(spacing),128*s)
			draw_sprite(spr_gridOutline_Lg,0,start_x +((cols-1)*spacing),128*s)		
		}
		// End shader
		shader_reset();
	}


	if game_over_status=20
	{
		scr_draw_sign(1120,310,200,60,2,0,2,4)
		clicked_restart=scr_draw_menu_item(1150,325,"Restart",clicked_restart)	
		clicked_main_menu=scr_draw_menu_item(1150,355,"Main Menu",clicked_main_menu)	
		
	}
	
}


if room== rm_titleScreen
{
	scr_draw_sign(500,410,340,140,2,0,2,4)
	
	
	
	clicked_quickstart=scr_draw_menu_item(600,440,"QUICKSTART",clicked_quickstart)	
	clicked_character_select=scr_draw_menu_item(550,472,"CHARACTER SELECT",clicked_character_select)
	clicked_scoreRoom=scr_draw_menu_item(590,504,"High Scores",clicked_scoreRoom)
	clicked_debugRoom=scr_draw_menu_item(1,1,"Debug Room",clicked_debugRoom)
	clicked_characterSelect=scr_draw_menu_item(1100,740,"Character Select",clicked_characterSelect)
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

if isNight<>0
{
    draw_set_color(c_black);
    draw_set_alpha(isNightShader); // 0 = transparent, 1 = solid
    draw_rectangle(0, 0, display_get_width(), display_get_height(), false);
    draw_set_alpha(1); // reset alpha
}

//if room == rm_testRoom1{
//	scr_draw_sign(500,410,340,140,2,0,2,4)
//	draw_sprite_ext(Spr_Slm_Idol,1,660,560,4,4,0,c_white,1)
//	clicked_quickstart=scr_draw_menu_item(560,430,"New High Score!",noone)	
//	clicked_quickstart=scr_draw_menu_item(560,460,"Enter Initials:",noone)	
//	clicked_quickstart=scr_draw_menu_item(580,490,"_ _ _",noone)	
	
//}

