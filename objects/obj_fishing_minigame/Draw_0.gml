//---- Pond ----
draw_set_alpha(0.9)
draw_set_color(box_color)
draw_rectangle(box_x, box_y, box_x+box_size, box_y+box_size, false)
draw_set_alpha(1)
draw_set_color(c_white)
draw_rectangle(box_x, box_y, box_x+box_size, box_y+box_size, true)

//---- Wind streaks while a gust is blowing (Gail) ----
var wind_power = abs(wind_amount)
if wind_power>0.05
{
	var wind_dir = sign(wind_amount) //1 blowing right, -1 blowing left
	var drift = current_time*0.25 //How fast the streaks race across
	draw_set_color(c_white)
	draw_set_alpha(min(wind_power, 1)*0.85)
	for (var i = 0; i < 20; i++)
	{
		//Spread the streaks over the pond and wrap them back around when they blow off a side
		var streak_length = 22 + (i mod 4)*8
		var streak_x = box_x + ((((i*137) + drift*wind_dir*(1 + (i mod 3)*0.4)) mod box_size) + box_size) mod box_size
		var streak_y = box_y + 10 + ((i*71) mod (box_size-20))
		draw_line_width(streak_x, streak_y, streak_x - wind_dir*streak_length, streak_y, 2)
	}
	draw_set_alpha(1)
}

//---- Holes (Holed): where it dives in, and where it'll pop out ----
if fish.move=FISH_MOVE.HOLE_HOP and fish.mode<>0
{
	draw_set_color(c_black)
	draw_set_alpha(0.5)
	draw_ellipse(fish.x-12, fish.y+2, fish.x+12, fish.y+10, false)
	draw_set_alpha(1)
}

//---- Pong paddles (Goal) ----
if fish.move=FISH_MOVE.PONG
{
	draw_set_color(c_white)
	var left_x = box_x + paddle_inset
	var right_x = box_x + box_size - paddle_inset - paddle_width
	draw_rectangle(left_x, fish.paddle_left_y-paddle_height/2, left_x+paddle_width, fish.paddle_left_y+paddle_height/2, false)
	draw_rectangle(right_x, fish.paddle_right_y-paddle_height/2, right_x+paddle_width, fish.paddle_right_y+paddle_height/2, false)
}

//Pins and fish are clipped to the pond, so a bowling fish disappears as it rolls off the top
var old_scissor = gpu_get_scissor()
gpu_set_scissor(box_x, box_y, box_size, box_size)

//---- Bowling pins (Bowled).  Spr_effect_bowlingPin is 5x13 with a top left origin, so rotate it around its middle ----
if fish.move=FISH_MOVE.BOWLING
{
	var pin_half_w = sprite_get_width(spr_effect_bowlingPin)/2
	var pin_half_h = sprite_get_height(spr_effect_bowlingPin)/2
	for (var i = 0; i < array_length(fish.pins); i++)
	{
		var pin = fish.pins[i]
		if pin.alpha<=0
			continue
		var pin_x = pin.x - pin_half_w*dcos(pin.angle) - pin_half_h*dsin(pin.angle)
		var pin_y = pin.y + pin_half_w*dsin(pin.angle) - pin_half_h*dcos(pin.angle)
		draw_sprite_ext(spr_effect_bowlingPin, 0, pin_x, pin_y, 1, 1, pin.angle, c_white, pin.alpha)
	}
}

//---- Fish (sprite is 24x24 with a top left origin, flipped to face the way it's swimming) ----
//Flipping, scaling and rotating all happen around the fish's center, so work out where the top left corner ends up
if !fish.hidden and fish.scale>0
{
	var half_fish = sprite_get_width(fish.sprite)/2
	var corner_x = -half_fish*fish.facing*fish.scale
	var corner_y = -half_fish*fish.scale*fish.flip_y //Upside down flips around the middle too
	var draw_x = fish.x + corner_x*dcos(fish.angle) + corner_y*dsin(fish.angle)
	var draw_y = fish.y - corner_x*dsin(fish.angle) + corner_y*dcos(fish.angle)
	
	//A wraparound fish near an edge is also drawn on the opposite side, so it slides out one side and in the other
	var copies_x = [0]
	var copies_y = [0]
	if fish.move=FISH_MOVE.WRAP
	{
		if fish.x<box_x+half_fish
			array_push(copies_x, box_size)
		if fish.x>box_x+box_size-half_fish
			array_push(copies_x, -box_size)
		if fish.y<box_y+half_fish
			array_push(copies_y, box_size)
		if fish.y>box_y+box_size-half_fish
			array_push(copies_y, -box_size)
	}
	for (var cx = 0; cx < array_length(copies_x); cx++)
		for (var cy = 0; cy < array_length(copies_y); cy++)
			draw_sprite_ext(fish.sprite, floor(fish.frame), draw_x+copies_x[cx], draw_y+copies_y[cy], fish.facing*fish.scale, fish.scale*fish.flip_y, fish.angle, c_white, 1)
}

gpu_set_scissor(old_scissor)

//---- Circle: turns yellow while the bar is filling (fish inside, or outside for a stick-to-circle fish) ----
draw_set_color(catching ? c_yellow : c_white)
draw_circle(circle_x, circle_y, circle_radius, true)
draw_circle(circle_x, circle_y, circle_radius-1, true)

//---- Green bar: fills up from the bottom ----
var bar_top = box_y + box_size*(1-bar_fill)
draw_set_color(c_black)
draw_set_alpha(0.4)
draw_rectangle(bar_x, box_y, bar_x+bar_width, box_y+box_size, false)
draw_set_alpha(1)
draw_set_color(c_lime)
if bar_fill>0
	draw_rectangle(bar_x, bar_top, bar_x+bar_width, box_y+box_size, false)
draw_set_color(c_white)
draw_rectangle(bar_x, box_y, bar_x+bar_width, box_y+box_size, true)

//---- Result ----
if result<>0
{
	draw_set_font(global.fnt_Gloop)
	var text = (result=1) ? "Caught a " + fish.name + "!" : "The " + fish.name + " got away..."
	draw_text(box_x + (box_size-string_width(text))/2, box_y - string_height(text) - 10, text)
}
draw_set_color(c_white)
