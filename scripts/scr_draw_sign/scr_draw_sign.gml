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
		
			draw_sprite_ext(Signage, 8, xx+flowerLoc,  yy+h*spacer, scale, scale, 0, c_white, 1)
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


function scr_draw_sign_Highscore()
{
	scr_draw_sign(200,pauseMenuY,1000,500,3,10,0,4)	
}

function scr_draw_sign_HighscorePrompt()
{
	scr_draw_sign(500,410,340,140,2,0,2,4)
	draw_sprite_ext(Spr_Slm_Idol,1,660,560,4,4,0,c_white,1)
	clicked_quickstart=scr_draw_menu_item(560,430,"New High Score!",noone)	
	clicked_quickstart=scr_draw_menu_item(560,460,"Enter Initials:",noone)	
	clicked_quickstart=scr_draw_menu_item(580,490,"_ _ _",noone)	
}
