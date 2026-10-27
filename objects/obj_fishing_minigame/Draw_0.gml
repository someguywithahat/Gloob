//---- Pond ----
draw_set_alpha(0.9)
draw_set_color(box_color)
draw_rectangle(box_x, box_y, box_x+box_size, box_y+box_size, false)
draw_set_alpha(1)
draw_set_color(c_white)
draw_rectangle(box_x, box_y, box_x+box_size, box_y+box_size, true)

//---- Catch bowl (the circle the player steers), drawn under everything else so the fish swims over it ----
//Spr_Catch_net has a top left origin, so scale its visible ring to the circle's size and center it on the circle
var bowl_ring = sprite_get_bbox_right(Spr_Catch_net) - sprite_get_bbox_left(Spr_Catch_net) + 1
var bowl_scale = circle_radius*2/bowl_ring
var bowl_draw_x = circle_x - sprite_get_width(Spr_Catch_net)/2*bowl_scale
var bowl_draw_y = circle_y - sprite_get_height(Spr_Catch_net)/2*bowl_scale
draw_sprite_ext(Spr_Catch_net, 0, bowl_draw_x, bowl_draw_y, bowl_scale, bowl_scale, 0, c_white, 1)
//Glows yellow while the bar is filling (fish inside, or outside for a stick-to-circle fish)
if catching
{
	gpu_set_blendmode(bm_add)
	draw_sprite_ext(Spr_Catch_net, 0, bowl_draw_x, bowl_draw_y, bowl_scale, bowl_scale, 0, c_yellow, catch_glow)
	gpu_set_blendmode(bm_normal)
}

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

//---- Gift (Marigold): the flower waiting to be picked.  spr_effect_marigold has a top left origin, so center it ----
if fish.move=FISH_MOVE.GIFT and !gift_carrying
{
	var flower_scale = gift_flower_scale*gift_flower_grow
	var flower_x = gift_flower_x - sprite_get_width(spr_effect_marigold)/2*flower_scale
	var flower_y = gift_flower_y - sprite_get_height(spr_effect_marigold)/2*flower_scale
	draw_sprite_ext(spr_effect_marigold, floor(gift_flower_frame), flower_x, flower_y, flower_scale, flower_scale, 0, c_white, 1)
}

//---- Decoy crowd (Hold): drawn in two halves, with the real fish slipped in between ----
var crowd_from = 0
var crowd_to = min(crowd_draw_slot, array_length(crowd))
if fish.move=FISH_MOVE.CROWD
{
	var half_decoy = sprite_get_width(crowd_sprite)/2
	for (var i = crowd_from; i < crowd_to; i++)
	{
		var decoy = crowd[i]
		draw_sprite_ext(crowd_sprite, floor(decoy.frame), decoy.x-half_decoy*decoy.facing, decoy.y-half_decoy, decoy.facing, 1, 0, c_white, 1)
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

//---- Gift (Marigold): the flower in her mouth, held by the bottom of its stem, and the hearts floating up ----
if fish.move=FISH_MOVE.GIFT
{
	if gift_carrying
	{
		var carry_x = gift_mouth_x(fish) - sprite_get_width(spr_effect_marigold)/2*gift_flower_scale
		var carry_y = fish.y + 2 - sprite_get_height(spr_effect_marigold)*gift_flower_scale
		draw_sprite_ext(spr_effect_marigold, floor(gift_flower_frame), carry_x, carry_y, gift_flower_scale, gift_flower_scale, 0, c_white, 1)
	}
	//spr_effect_heart is 16x16 with a top left origin.  Pops in big, then shrinks a little and fades as it rises
	var heart_half = sprite_get_width(spr_effect_heart)/2
	for (var i = 0; i < array_length(gift_hearts); i++)
	{
		var heart = gift_hearts[i]
		var age = 1 - heart.life/gift_heart_life //0 new, 1 gone
		var heart_scale = (age<0.15) ? lerp(0.5, 1.4, age/0.15) : lerp(1.4, 1, (age-0.15)/0.85)
		var heart_alpha = (age<0.6) ? 1 : 1 - (age-0.6)/0.4
		draw_sprite_ext(spr_effect_heart, 0, heart.x - heart_half*heart_scale, heart.y - heart_half*heart_scale, heart_scale, heart_scale, 0, c_white, heart_alpha)
	}
}

//---- Rest of the decoy crowd (Hold), on top of the real fish ----
crowd_from = min(crowd_draw_slot, array_length(crowd))
crowd_to = array_length(crowd)
if fish.move=FISH_MOVE.CROWD
{
	var half_decoy = sprite_get_width(crowd_sprite)/2
	for (var i = crowd_from; i < crowd_to; i++)
	{
		var decoy = crowd[i]
		draw_sprite_ext(crowd_sprite, floor(decoy.frame), decoy.x-half_decoy*decoy.facing, decoy.y-half_decoy, decoy.facing, 1, 0, c_white, 1)
	}
}

//---- Fishing line and hook (Poled) ----
if fish.move=FISH_MOVE.HOOKED and fish.hook_state<>0
{
	draw_set_color(make_colour_rgb(40,40,50))
	draw_line_width(fish.hook_anchor_x, fish.hook_anchor_y, fish.hook_x, fish.hook_y, 1)
	//spr_effect_hook is 6x10 with a top left origin.  The line ties on at the top middle, so hang it from there,
	//turned so the top points back up the line
	var hook_scale = 2
	var line_dir = point_direction(fish.hook_x, fish.hook_y, fish.hook_anchor_x, fish.hook_anchor_y)
	var hook_angle = line_dir - 90
	var tie_x = sprite_get_width(spr_effect_hook)/2*hook_scale
	var hook_draw_x = fish.hook_x - tie_x*dcos(hook_angle)
	var hook_draw_y = fish.hook_y + tie_x*dsin(hook_angle)
	draw_sprite_ext(spr_effect_hook, 0, hook_draw_x, hook_draw_y, hook_scale, hook_scale, hook_angle, c_white, 1)
}

gpu_set_scissor(old_scissor)

//---- Dark rooms (the fishing cave): darken the pond, lit by the circle and the fish's own glow ----
var lighting = instance_find(obj_lighting, 0)
if lighting<>noone and lighting.always_night
{
	if !surface_exists(pond_light_surf)
		pond_light_surf = surface_create(box_size, box_size)
	surface_set_target(pond_light_surf)
	draw_clear(lighting.sky_color(lighting.night_amount))
	gpu_set_blendmode(bm_add)
	var light_strength = lighting.night_amount
	//The circle: a lantern about the size of the circle (positions are relative to the pond's corner)
	lighting.add_light(circle_x-box_x, circle_y-box_y, circle_radius*circle_light_size, lighting.boat_light_color, light_strength)
	//The fish glows in its own color (light in scr_fish_data)
	if !fish.hidden
		lighting.add_light(fish.x-box_x, fish.y-box_y, lighting.fish_light_radius*max(fish.scale, 1), fish_data.light,
			light_strength*lighting.fish_light_strength, spr_effect_glow)
	gpu_set_blendmode(bm_normal)
	surface_reset_target()

	//Multiply it over the pond, then put the pond's outline back on top
	gpu_set_blendmode_ext(bm_dest_colour, bm_zero)
	draw_surface(pond_light_surf, box_x, box_y)
	gpu_set_blendmode(bm_normal)
	draw_set_color(c_white)
	draw_rectangle(box_x, box_y, box_x+box_size, box_y+box_size, true)
}

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

//---- Hint above the pond (Hold) ----
if result=0 and fish.move=FISH_MOVE.CROWD
{
	draw_set_font(global.fnt_Gloop)
	draw_set_color(c_white)
	draw_text(box_x + (box_size-string_width(crowd_message))/2, box_y - string_height(crowd_message) - 10, crowd_message)
}

//---- Result ----
if result<>0
{
	draw_set_font(global.fnt_Gloop)
	var text = (result=1) ? "Caught a " + fish.name + "!" : "The " + fish.name + " got away..."
	draw_text(box_x + (box_size-string_width(text))/2, box_y - string_height(text) - 10, text)
}
draw_set_color(c_white)
