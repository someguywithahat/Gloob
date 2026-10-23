function scr_draw_sign(xx, yy, width, height, scale, hasChains, hasPost, hasFlowers)
{
	
	var spacer = sprite_get_width(Signage)*scale
	var sWidth = round(width/spacer)
	var sHeight = round(height/spacer)
	
	
	
	for( var w=0; w<=sWidth; w++)
	{
		for( var h=0; h<=sHeight; h++)
		{
			if h=0
			{
				if w=0
					draw_sprite_ext(Signage, 0, xx+w*spacer, yy+h*spacer, scale, scale, 0, c_white, 1)
				else if w<sWidth
					draw_sprite_ext(Signage, 1, xx+w*spacer, yy+h*spacer, scale, scale, 0, c_white, 1)
				else 
					draw_sprite_ext(Signage, 0, xx+w*spacer+spacer, yy+h*spacer, -scale, scale, 0, c_white, 1)
			}
			else if h<sHeight
			{
				if w=0
					draw_sprite_ext(Signage, 2, xx+w*spacer, yy+h*spacer, scale, scale, 0, c_white, 1)
				else if w<sWidth
					draw_sprite_ext(Signage, 3, xx+w*spacer, yy+h*spacer, scale, scale, 0, c_white, 1)
				else 
					draw_sprite_ext(Signage, 2, xx+w*spacer+spacer, yy+h*spacer, -scale, scale, 0, c_white, 1)
			}
			else 
			{
				if w=0
					draw_sprite_ext(Signage, 4, xx+w*spacer, yy+h*spacer, scale, scale, 0, c_white, 1)
				else if w<sWidth
					draw_sprite_ext(Signage, 5, xx+w*spacer, yy+h*spacer, scale, scale, 0, c_white, 1)
				else 
					draw_sprite_ext(Signage, 4, xx+w*spacer+spacer, yy+h*spacer, -scale, scale, 0, c_white, 1)
			}
		}
	}
	
	if hasChains>0{
		var chain2 = sWidth-1		
		for( var c=1; c<=hasChains; c++)
		{
		
			draw_sprite_ext(Signage, 6, xx+(1*spacer), yy-(c*spacer-8), scale, scale, 0, c_white, 1)
			draw_sprite_ext(Signage, 6, xx+(chain2*spacer), yy-(c*spacer+-8), scale, scale, 0, c_white, 1)
		}		
	}
	
	if hasPost>0{
		var postLoc = (((sWidth+1)*spacer)/2)-(spacer/2)
		for( var c=0; c<hasPost; c++)
		{
		
			draw_sprite_ext(Signage, 10, xx+postLoc, yy+((sHeight+1+c)*spacer)-8, scale, scale, 0, c_white, 1)
		}
		draw_sprite_ext(Signage, 11, xx+postLoc, yy+((sHeight+1+hasPost)*spacer)-8, scale, scale, 0, c_white, 1)
	}

	
	if hasFlowers>0{
		if hasFlowers=1
			hasFlowers=sHeight
		var flowerLoc = ((sWidth)*spacer)
		for( var h=0; h<=hasFlowers; h++)
		{
			if global.weather<>3{
				draw_sprite_ext(Signage, 8, xx+flowerLoc,  yy+h*spacer, scale, scale, 0, c_white, 1)
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
				draw_sprite_ext(Signage, 8, xx+flowerLoc,  yy+h*spacer, scale, scale, 0, c_white, 1)
				// End shader
				shader_reset();
			}
		}
	}



}





function scr_draw_grass_sign(xx, yy, text, scale)

{
	draw_set_font(global.fnt_Gloop)
	//var w = string_width(text)
	var alignment_mod=8
	var width = string_width(text)+alignment_mod*2
	var height = string_height(text)+alignment_mod*2
	
	
	var spacer = sprite_get_width(Signage)*scale
	var sWidth = round(width/spacer)
	var sHeight = round(height/spacer)
	
	
	var textCenter=(((sWidth+1)*spacer)-string_width(text)) /2
	//layer = layer_get_id("AboveEverything");
	
	for( var w=0; w<=sWidth; w++)
	{
		for( var h=0; h<=sHeight; h++)
		{
			if h=0
			{
				if w=0
					draw_sprite_ext(Signage, 15, xx+w*spacer, yy+h*spacer, scale, scale, 0, c_white, 1)
				else if w<sWidth
					draw_sprite_ext(Signage, 16, xx+w*spacer, yy+h*spacer, scale, scale, 0, c_white, 1)
				else 
					draw_sprite_ext(Signage, 15, xx+w*spacer+spacer, yy+h*spacer, -scale, scale, 0, c_white, 1)
			}
			else if h<sHeight
			{
				if w=0
					draw_sprite_ext(Signage, 18, xx+w*spacer+spacer, yy+h*spacer, -scale, scale, 0, c_white, 1)
				else if w<sWidth
					draw_sprite_ext(Signage, 17, xx+w*spacer, yy+h*spacer, scale, scale, 0, c_white, 1)
				else 
					draw_sprite_ext(Signage, 18, xx+w*spacer, yy+h*spacer, scale, scale, 0, c_white, 1)
			}
			else 
			{
				if w=0
					draw_sprite_ext(Signage, 15, xx+w*spacer, yy+h*spacer, scale, -scale, 0, c_white, 1)
				else if w<sWidth
					draw_sprite_ext(Signage, 16, xx+w*spacer, yy+h*spacer, scale, -scale, 0, c_white, 1)
				else 
					draw_sprite_ext(Signage, 15, xx+w*spacer+spacer, yy+h*spacer, -scale, -scale, 0, c_white, 1)
			}
		}
	}
	
	draw_set_colour(c_white)
	draw_text(xx+textCenter, yy+alignment_mod, text);


}

function scr_draw_grass_leaves_area(xx, yy, x_tiles, y_tiles, scale)
{
	
	var leaf_sprite=Spr_Garden_path
	
	if global.weather=global.FALL
		leaf_sprite=Spr_Leaf_path
	else if global.weather=global.WINTER
		leaf_sprite=Spr_Snow_path
	else if global.weather=global.SPRING
		leaf_sprite=Spr_Grass_path
	
	
	//var sWidth = width
	var spacer = sprite_get_width(leaf_sprite)
	
	for( var w=0; w<=x_tiles; w++)
	{
		for( var h=0; h<=y_tiles; h++)
		{
			if h=0
			{
				if w=0
					draw_sprite_ext(leaf_sprite, 0, xx+w*spacer, yy+h*spacer, scale, scale, 0, c_white, 1)
				else if w<x_tiles
					draw_sprite_ext(leaf_sprite, 2, xx+w*spacer, yy+h*spacer, scale, scale, 0, c_white, 1)
				else 
					draw_sprite_ext(leaf_sprite, 0, xx+w*spacer+spacer, yy+h*spacer, -scale, scale, 0, c_white, 1)
			}
			else if h<y_tiles
			{
				if w=0
					draw_sprite_ext(leaf_sprite, 3, xx+w*spacer, yy+h*spacer, scale, scale, 0, c_white, 1)
				else if w<x_tiles
					draw_sprite_ext(leaf_sprite, 4, xx+w*spacer, yy+h*spacer, scale, scale, 0, c_white, 1)
				else if w=x_tiles
					draw_sprite_ext(leaf_sprite, 3, xx+w*spacer+spacer, yy+h*spacer, -scale, scale, 0, c_white, 1)
			}
			else 
			{
				if w=0
					draw_sprite_ext(leaf_sprite, 0, xx+w*spacer,        yy+h*spacer+spacer, scale, -scale, 0, c_white, 1)
				else if w<x_tiles
					draw_sprite_ext(leaf_sprite, 2, xx+w*spacer,        yy+h*spacer+spacer, scale, -scale, 0, c_white, 1)
				else if w=x_tiles
					draw_sprite_ext(leaf_sprite, 0, xx+w*spacer+spacer, yy+h*spacer+spacer, -scale, -scale, 0, c_white, 1)
			}
		}
	}
}


function scr_draw_sign_Highscore()
{
	scr_draw_sign(200,pauseMenuY,1000,500,3,10,0,4)	
}

function scr_draw_sign_HighscorePrompt()
{
	scr_draw_sign(500,410,340,140,2,0,2,4)
	draw_sprite_ext(Spr_Slm_Idol,1,660,560,4,4,0,c_white,1)
	scr_draw_menu_item(560,430,"New High Score!",noone)	
	scr_draw_menu_item(560,460,"Enter Initials:",noone)	
	scr_draw_menu_item(560,490,"___",noone)	
	
	draw_sprite(Arrow,1,680,490)
	draw_sprite(Slm_All_Base_Expressions,0,710,490)
	draw_sprite(Arrow,3,740,490)
}


/// @function scr_draw_goal_sign(xx, yy, hover_or_click)
/// @description The hanging sign in the top right of the game screen.
///   Line 1: percent of the grid needed for today
///   Line 2: slime bar showing how far through the goal you are, from this season's icon to the next season's icon
///   Line 3: points still needed to end the day, or the End Day button once the goal is reached
/// @returns the End Day button state from scr_draw_menu_item (pass in clicked_end_day)
function scr_draw_goal_sign(xx, yy, hover_or_click)
{
	var controller = global.controller

	//Frames in spr_Seasons and the season that follows, both indexed by global.weather (SUMMER 0, WINTER 1, SPRING 2, FALL 3)
	var season_icon = [0, 4, 6, 2]
	var next_season = [global.FALL, global.SPRING, global.SUMMER, global.WINTER]

	var goal_total = max(1, round(controller.grid_size*controller.season_goal_percentage))
	var progress = clamp((goal_total - controller.season_goal)/goal_total, 0, 1)
	var goal_reached = controller.season_goal<=0

	//Lay the rows out from the font height, then size the sign to fit
	draw_set_font(global.fnt_Gloop)
	var text_h = string_height("0")
	var pad = 10
	var gap = 8
	var icon_size = sprite_get_width(spr_Seasons)
	var content_h = pad + text_h + gap + icon_size + gap + text_h + pad

	var tile = sprite_get_width(Signage)
	var sign_tiles_wide = 13
	var sign_tiles_high = ceil(content_h/tile) - 1
	var sign_w = (sign_tiles_wide+1)*tile
	scr_draw_sign(xx, yy, sign_tiles_wide*tile, sign_tiles_high*tile, 1, 2, 0, 0)

	var center_x = xx + sign_w/2
	var row1_y = yy + pad
	var row2_y = row1_y + text_h + gap
	//The bar and the bottom line sit this far above their natural spot.  The season icons stay put
	var lift = 16
	var row3_y = row2_y + icon_size + gap - lift

	//Line 1
	scr_draw_text(center_x, row1_y, "Goal "+string(round(controller.season_goal_percentage*100))+"%", 1)

	//Line 2: season icons with the slime bar between them
	var icon_inset = tile
	draw_sprite(spr_Seasons, season_icon[global.weather], xx+icon_inset, row2_y)
	draw_sprite(spr_Seasons, season_icon[next_season[global.weather]], xx+sign_w-icon_inset-icon_size, row2_y)

	var bar_x1 = xx + icon_inset + icon_size + 6
	var bar_x2 = xx + sign_w - icon_inset - icon_size - 6
	var bar_y1 = row2_y + 3 - lift
	var bar_y2 = row2_y + icon_size - 3 - lift
	var bar_h = bar_y2 - bar_y1

	draw_set_alpha(0.55)
	draw_set_color(make_color_rgb(40, 60, 70))
	draw_roundrect_ext(bar_x1, bar_y1, bar_x2, bar_y2, bar_h, bar_h, false)
	draw_set_alpha(1)
	var fill_x1 = bar_x1 + 4
	var fill_x2 = fill_x1 + (bar_x2 - bar_x1 - 8)*progress
	if fill_x2-fill_x1>=1
	{
		//Player 1's slime color.  The fill is drawn from single pixels of the slime palette so the palette swap shader recolors it
		var player_one_color = 2
		with(obj_gloop_score)
			if player=0
				player_one_color = clamp(gloop_color_index, 0, 7)

		shader_set(shd_palette_swap)
		var u_palette_orig = shader_get_sampler_index(shd_palette_swap, "palette_orig")
		var u_palette_swap = shader_get_sampler_index(shd_palette_swap, "palette_swap")
		var u_color_count  = shader_get_uniform(shd_palette_swap, "color_count")
		texture_set_stage(u_palette_orig, sprite_get_texture(spr_palette_index, 0))
		texture_set_stage(u_palette_swap, sprite_get_texture(spr_palette_all, player_one_color))
		shader_set_uniform_f(u_color_count, 6.0)

		//Stretching one pixel only keeps its exact color if the texture isn't smoothed
		var smoothing = gpu_get_texfilter()
		gpu_set_texfilter(false)
		var fw = fill_x2 - fill_x1
		var fy1 = bar_y1 + 1
		var fh = bar_y2 - bar_y1 - 2
		draw_sprite_part_ext(spr_palette_index, 0, 2, 0, 1, 1, fill_x1, fy1, fw, fh, c_white, 1)         //body
		draw_sprite_part_ext(spr_palette_index, 0, 0, 0, 1, 1, fill_x1, fy1, fw, 2, c_white, 1)          //glossy highlight on top
		draw_sprite_part_ext(spr_palette_index, 0, 3, 0, 1, 1, fill_x1, fy1+fh-2, fw, 2, c_white, 1)     //shade underneath
		gpu_set_texfilter(smoothing)
		shader_reset()
	}
	draw_set_color(c_white)

	//Line 3
	if !goal_reached
		scr_draw_text(center_x, row3_y, string(controller.season_goal)+" left", 1)
	else if controller.game_over_status<1
	{
		draw_set_font(global.fnt_Gloop)
		var end_day_text = "End Day?"
		hover_or_click = scr_draw_menu_item(center_x - string_width(end_day_text)/2, row3_y, end_day_text, hover_or_click)
	}
	else
		scr_draw_text(center_x, row3_y, "Goal Reached", 1)

	return hover_or_click
}
