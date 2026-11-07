//Paused: just the frozen game and the pause menu
if isPaused
{
	scr_pause_draw()
	exit
}


if room == rm_gameScreen{
		
	clicked_end_day = scr_draw_goal_sign(1130, 0, clicked_end_day)
	
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
		scr_draw_sign(5,460,180,90,2,0,2,4)
		clicked_restart=scr_draw_menu_item(35,485,"Restart",clicked_restart)	
		clicked_main_menu=scr_draw_menu_item(35,515,"Main Menu",clicked_main_menu)	
		
	}
	
}


if room==rm_gameScreen
{
	layer = layer_get_id("Instances");
}


//Testing: wipe the fishing catch history so the trophy clams can be opened again
if room==rm_fishingCenter
{
	clicked_reset_fishing=scr_draw_menu_item(10,736,"Reset fishing save data",clicked_reset_fishing)
	if clicked_reset_fishing=1
	{
		clicked_reset_fishing=-1
		scr_fish_reset_caught()
	}
	//Testing: one more fishing ticket
	clicked_add_ticket=scr_draw_menu_item(10,704,"Add fishing ticket (" + string(global.fishing_tickets) + ")",clicked_add_ticket)
	if clicked_add_ticket=1
	{
		clicked_add_ticket=-1
		scr_add_fishing_tickets(1)
	}
}


if room== rm_titleScreen
{
	//"Start Game" on the sign in the room's Signs layer.  Move it with title_start_x/y (obj_controller Create)
	//Nothing is clickable while fading out to another room
	var title_active = !scr_room_fading_out()
	draw_set_font(global.fnt_Gloop)
	if scr_menu_button("Start Game", title_start_x, title_start_y-string_height("Start Game")/2, title_active)
		clicked_title_start=1 //Step goes to rm_characterSelect

	//OPTIONS and VILLAGE: the words in the room's Letters layer.  Their letters fade when hovered, like the other menus
	var over_options = title_word_hovered(title_options_box)
	var over_village = title_word_hovered(title_village_box)
	var over_lake = title_lake_hovered()
	if !title_active
	{
		over_options = false
		over_village = false
		over_lake = false
	}
	if mouse_check_button_pressed(mb_left) and over_lake and !over_village
		clicked_title_lake=1 //Step goes fishing (the fishing sign plays its own part if it was clicked too)
	if mouse_check_button_pressed(mb_left) and (over_options or over_village)
	{
		var snd = audio_play_sound(snd_slime_move, 1, false)
		audio_sound_pitch(snd, random_range(0.9, 1.2))
		if over_options
			clicked_title_options=1 //Step opens the pause menu
		else
			clicked_title_village=1 //Step goes to rm_town
	}
	//clicked_debugRoom=scr_draw_menu_item(1,1,"Debug Room",clicked_debugRoom)
	//clicked_debugRoom2=scr_draw_menu_item(300,1,"Debug Room2",clicked_debugRoom2)
	//clicked_characterSelect=scr_draw_menu_item(1100,740,"Character Select",clicked_characterSelect)
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

