//Drawn in Draw End (Draw GUI doesn't show in this project), above everything but the room fade
shader_reset()
gpu_set_blendmode(bm_normal)
draw_set_alpha(1)

//While fading in and back out, the game shows underneath
if phase<>"fade_in" and phase<>"fade_back"
{
	var cx = floor(cam)

	//---- The scene, small ----
	if !surface_exists(surf)
		surf = surface_create(view_w+1, view_h) //1 pixel wider, so the view can pan smoothly
	surface_set_target(surf)
	draw_clear(make_colour_rgb(150, 210, 255))

	//Sky
	draw_rectangle_colour(0, 0, view_w+1, ground_y, make_colour_rgb(110, 180, 250), make_colour_rgb(110, 180, 250),
		make_colour_rgb(190, 230, 255), make_colour_rgb(190, 230, 255), false)

	//Clouds, drifting slowly (and moving less than the ground as the view pans)
	draw_set_colour(c_white)
	for (var i = 0; i < array_length(clouds); i++)
	{
		var cl = clouds[i]
		var cloud_x = round(cl.x - cam*0.4 + time*0.02) mod (view_w+40) - 30
		draw_rectangle(cloud_x, cl.y, cloud_x+cl.w, cl.y+3, false)
		draw_rectangle(cloud_x+2, cl.y-2, cloud_x+round(cl.w*0.6), cl.y, false)
		draw_rectangle(cloud_x+round(cl.w*0.4), cl.y-4, cloud_x+round(cl.w*0.8), cl.y-1, false)
	}

	//Hills in the distance
	draw_set_colour(make_colour_rgb(125, 200, 120))
	for (var xx = 0; xx <= view_w; xx++)
	{
		var wx = xx + cam*0.6
		var hill_y = round(72 - 5*sin(wx*0.045) - 3*sin(wx*0.11+1))
		draw_rectangle(xx, hill_y, xx, ground_y, false)
	}

	//Grass, with tufts and flowers
	draw_set_colour(make_colour_rgb(96, 190, 80))
	draw_rectangle(0, ground_y, view_w+1, view_h, false)
	draw_set_colour(make_colour_rgb(140, 220, 110))
	draw_rectangle(0, ground_y, view_w+1, ground_y, false)
	for (var xx = 0; xx <= view_w; xx++)
	{
		var wx = xx + cx
		if wx mod 9=0
		{
			draw_set_colour(make_colour_rgb(70, 160, 60))
			draw_point(xx, ground_y-1)
		}
		if (wx*37) mod 41=3
		{
			draw_set_colour(ball_colors[wx mod array_length(ball_colors)])
			draw_point(xx, ground_y+4)
		}
		if (wx*53) mod 47=7
		{
			draw_set_colour(c_white)
			draw_point(xx, ground_y+8)
		}
	}

	//Back row, buried in the balls
	draw_slime_layer(0, cx)
	draw_pit_balls(cx, -999)
	//Front row, buried in the front balls
	draw_slime_layer(1, cx)
	draw_pit_balls(cx, front_cut)

	//The tub: blue with a yellow rim and corner posts
	var l = pit_l - cx
	var r = pit_r - cx
	draw_set_colour(make_colour_rgb(45, 90, 180))
	draw_rectangle(l, pit_wall_y, r, ground_y+4, false)
	draw_set_colour(make_colour_rgb(70, 130, 230))
	draw_rectangle(l, pit_wall_y, r, ground_y+1, false)
	draw_set_colour(make_colour_rgb(130, 180, 255))
	draw_rectangle(l+2, pit_wall_y+3, r-2, pit_wall_y+3, false)
	draw_set_colour(make_colour_rgb(250, 210, 80))
	draw_rectangle(l-1, pit_wall_y, r+1, pit_wall_y+1, false)
	draw_rectangle(l-2, 62, l, ground_y+4, false)
	draw_rectangle(r, 62, r+2, ground_y+4, false)
	for (var sx = l+8; sx < r-4; sx += 12) //Stars along the side
	{
		draw_point(sx, 78)
		draw_point(sx-1, 78)
		draw_point(sx+1, 78)
		draw_point(sx, 77)
		draw_point(sx, 79)
	}

	//Out of the pit: on the field, and flying
	draw_slime_layer(2, cx)

	//Splashes
	for (var i = 0; i < array_length(flying_balls); i++)
	{
		var b = flying_balls[i]
		draw_ball(round(b.x)-cx, round(b.y), b.c)
	}

	//Confetti, fluttering
	for (var i = 0; i < array_length(confetti); i++)
	{
		var c = confetti[i]
		var cfx = round(c.x)-cx
		var cfy = round(c.y)
		draw_set_colour(c.c)
		if (c.t div 8) mod 2=0
			draw_rectangle(cfx, cfy, cfx+1, cfy, false)
		else
			draw_rectangle(cfx, cfy, cfx, cfy+1, false)
	}

	surface_reset_target()
	draw_set_colour(c_white)

	//---- Scaled up 8 times, crisp ----
	var old_filter = gpu_get_texfilter()
	gpu_set_texfilter(false)
	draw_surface_ext(surf, -(cam-cx)*scene_scale, 0, scene_scale, scene_scale, 0, c_white, 1)
	gpu_set_texfilter(old_filter)

	//---- Congratulations ----
	if phase="celebrate" or (phase="fade_out" and celebrate_time>0)
	{
		draw_set_font(global.fnt_Gloop)
		draw_set_halign(fa_left)
		draw_set_valign(fa_top)

		//Pops in, then each letter bobs in rainbow colors
		var msg = "Congratulations!"
		var k = min(1, celebrate_time/25)
		var pop = 1 + 2.70158*power(k-1, 3) + 1.70158*power(k-1, 2) //Overshoots a little
		var sc = 3*pop
		var lx = room_width/2 - string_width(msg)*sc/2
		var ly = 60 + string_height(msg)*(3-sc)/2
		for (var i = 1; i <= string_length(msg); i++)
		{
			var ch = string_char_at(msg, i)
			var letter_col = make_colour_hsv((time*2 + i*16) mod 256, 110, 255)
			draw_text_transformed_colour(lx, ly + sin(time*0.12 - i*0.5)*10, ch, sc, sc, 0,
				letter_col, letter_col, letter_col, letter_col, 1)
			lx += string_width(ch)*sc
		}

		var sub = "You made it through all four seasons!"
		draw_set_halign(fa_center)
		var sub_alpha = clamp((celebrate_time-20)/30, 0, 1)
		draw_text_transformed_colour(room_width/2, 60 + string_height(msg)*3 + 16, sub, 1.5, 1.5, 0,
			c_white, c_white, c_white, c_white, sub_alpha)

		if celebrate_time>prompt_delay
		{
			var blink = 0.55 + 0.45*sin(time*0.08)
			draw_text_transformed_colour(room_width/2, room_height-56, "Click to keep playing", 1.2, 1.2, 0,
				c_white, c_white, c_white, c_white, blink)
		}
		draw_set_halign(fa_left)
	}
}

//---- Black, for fading ----
if fade>0
{
	draw_set_colour(c_black)
	draw_set_alpha(fade)
	draw_rectangle(0, 0, room_width, room_height, false)
	draw_set_alpha(1)
	draw_set_colour(c_white)
}
