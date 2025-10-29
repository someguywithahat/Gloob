function scr_draw_sign(xx, yy, width, height)
{
	var tl=0
	var t=1
	var l=2
	var m=3
	var bl=4
	var b=5
	
	//var width=500
	//var height=200 
	
	
	
	var spacer = sprite_get_width(Signage)
	var sWidth = round(width/spacer)
	var sHeight = round(height/spacer)
	
	
	
	for( var w=0; w<=sWidth; w++)
	{
		for( var h=0; h<=sHeight; h++)
		{
			if h=0
			{
				if w=0
					draw_sprite_ext(Signage, 0, xx+w*spacer, yy+h*spacer, 1, 1, 0, c_white, 1)
				else if w<sWidth
					draw_sprite_ext(Signage, 1, xx+w*spacer, yy+h*spacer, 1, 1, 0, c_white, 1)
				else 
					draw_sprite_ext(Signage, 0, xx+w*spacer+spacer, yy+h*spacer, -1, 1, 0, c_white, 1)
			}
			else if h<sHeight
			{
				if w=0
					draw_sprite_ext(Signage, 2, xx+w*spacer, yy+h*spacer, 1, 1, 0, c_white, 1)
				else if w<sWidth
					draw_sprite_ext(Signage, 3, xx+w*spacer, yy+h*spacer, 1, 1, 0, c_white, 1)
				else 
					draw_sprite_ext(Signage, 2, xx+w*spacer+spacer, yy+h*spacer, -1, 1, 0, c_white, 1)
			}
			else 
			{
				if w=0
					draw_sprite_ext(Signage, 4, xx+w*spacer, yy+h*spacer, 1, 1, 0, c_white, 1)
				else if w<sWidth
					draw_sprite_ext(Signage, 5, xx+w*spacer, yy+h*spacer, 1, 1, 0, c_white, 1)
				else 
					draw_sprite_ext(Signage, 4, xx+w*spacer+spacer, yy+h*spacer, -1, 1, 0, c_white, 1)
			}
		}
	}
	


}