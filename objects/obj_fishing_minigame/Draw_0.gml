//---- Pond ----
draw_set_alpha(0.9)
draw_set_color(box_color)
draw_rectangle(box_x, box_y, box_x+box_size, box_y+box_size, false)
draw_set_alpha(1)
draw_set_color(c_white)
draw_rectangle(box_x, box_y, box_x+box_size, box_y+box_size, true)

//---- Whirlpool (Bowl): darker water in the middle, spiral arms turning, and splashes.  Under the net and the fish ----
if fish.move=FISH_MOVE.WHIRLPOOL
{
	var whirl_old_scissor = gpu_get_scissor()
	gpu_set_scissor(box_x, box_y, box_size, box_size)
	if whirl_amount>0
	{
		var R = box_size*whirl_radius
		//Deeper water toward the middle (overlapping circles get darker)
		draw_set_color(make_colour_rgb(40,90,170))
		draw_set_alpha(0.08*whirl_amount)
		for (var k = 1; k <= 4; k++)
			draw_circle(whirl_x, whirl_y, R*k/4, false)
		//Spiral arms, curling in from the edge to the middle
		draw_set_color(c_white)
		var arm_steps = 16
		for (var arm = 0; arm < whirl_arms; arm++)
		{
			var prev_x = 0
			var prev_y = 0
			for (var s = 0; s <= arm_steps; s++)
			{
				var f = s/arm_steps //0 at the edge, 1 in the middle
				var r = R*(1 - f*0.95)
				var a = whirl_angle + arm*360/whirl_arms + f*whirl_twist*whirl_dir
				var px = whirl_x + lengthdir_x(r, a)
				var py = whirl_y + lengthdir_y(r, a)
				if s>0
				{
					draw_set_alpha(whirl_amount*0.6*sin(f*pi)) //Fades in from the edge and out at the middle
					draw_line_width(prev_x, prev_y, px, py, 2)
				}
				prev_x = px
				prev_y = py
			}
		}
		//Faint edge
		draw_set_alpha(0.25*whirl_amount)
		draw_circle(whirl_x, whirl_y, R, true)
		draw_set_alpha(1)
	}
	//Splashes.  Spr_Ripple is 32x32 with a top left origin, so center it
	var splash_half = sprite_get_width(Spr_Ripple)/2
	for (var i = 0; i < array_length(whirl_splashes); i++)
		draw_sprite(Spr_Ripple, floor(whirl_splashes[i].frame), whirl_splashes[i].x-splash_half, whirl_splashes[i].y-splash_half)
	gpu_set_scissor(whirl_old_scissor)
	draw_set_color(c_white)
}

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

//---- Lightning trail (Volt): a crackling bolt that fades.  Under the fish ----
if fish.move=FISH_MOVE.LIGHTNING
{
	for (var i = 1; i < array_length(bolt_trail); i++)
	{
		var from = bolt_trail[i-1]
		var to = bolt_trail[i]
		var fade = min(from.life, to.life)/bolt_trail_life
		//Each end jitters a little every frame, so it crackles
		var jitter = 1.5*fade
		var x1 = from.x + random_range(-jitter, jitter)
		var y1 = from.y + random_range(-jitter, jitter)
		var x2 = to.x + random_range(-jitter, jitter)
		var y2 = to.y + random_range(-jitter, jitter)
		//Soft glow, then a bright core
		draw_set_color(bolt_trail_color)
		draw_set_alpha(fade*0.35)
		draw_line_width(x1, y1, x2, y2, 6)
		draw_set_color(c_white)
		draw_set_alpha(fade)
		draw_line_width(x1, y1, x2, y2, 2)
	}
	draw_set_alpha(1)
	draw_set_color(c_white)
}

//---- Embers (Scald) on the water.  Spr_Flame is 16x16 with a top left origin, so center it.  Under the fish ----
if fish.move=FISH_MOVE.EMBERS
{
	var ember_half = sprite_get_width(Spr_Flame)/2
	for (var i = 0; i < array_length(embers); i++)
	{
		var ember = embers[i]
		var burn = ember_strength(ember)
		var pop_in = min(ember.age/6, 1) //Pops in when dropped
		var ember_scale = burn*pop_in
		draw_sprite_ext(Spr_Flame, floor(ember.frame), ember.x-ember_half*ember_scale, ember.y-ember_half*ember_scale, ember_scale, ember_scale, 0, c_white, burn)
	}
}

//---- Ice walls (Cold): a long glowing block of ice, drawn in code.  On top of the net, under the fish ----
if fish.move=FISH_MOVE.ICE_WALLS
{
	var glow_width = sprite_get_width(spr_effect_glow)
	for (var i = 0; i < array_length(ice_walls); i++)
	{
		var wall = ice_walls[i]
		var shape = ice_shape(wall)
		var L = shape.half_length
		var T = shape.half_thick
		if T<0.5
			continue
		var fade = ice_strength(wall)
		var forming = wall.growing ? 0.45 : 1 //See-through while it's still forming

		//Soft glow, stretched along the wall
		gpu_set_blendmode(bm_add)
		draw_sprite_ext(spr_effect_glow, 0, shape.cx, shape.cy, (L*2 + T*2*ice_glow)/glow_width, T*2*ice_glow*1.4/glow_width, shape.angle, fish_data.light, 0.5*fade)
		gpu_set_blendmode(bm_normal)

		//Body: pale blue, a little see-through.  Then a lighter middle
		var inset = min(3, T*0.5)
		for (var ice_pass = 0; ice_pass < 2; ice_pass++)
		{
			var l = L - ice_pass*inset
			var t = T - ice_pass*inset
			draw_set_alpha(((ice_pass=0) ? 0.75 : 0.6)*fade*forming)
			draw_set_color((ice_pass=0) ? make_colour_rgb(160,215,250) : make_colour_rgb(215,242,255))
			draw_primitive_begin(pr_trianglestrip)
			draw_vertex(ice_point_x(shape, -l, -t), ice_point_y(shape, -l, -t))
			draw_vertex(ice_point_x(shape, l, -t), ice_point_y(shape, l, -t))
			draw_vertex(ice_point_x(shape, -l, t), ice_point_y(shape, -l, t))
			draw_vertex(ice_point_x(shape, l, t), ice_point_y(shape, l, t))
			draw_primitive_end()
		}
		if wall.growing
			continue

		//Shine streaks along the top edge, and a frosty outline
		draw_set_color(c_white)
		draw_set_alpha(0.85*fade)
		draw_line_width(ice_point_x(shape, -L*0.8, -T*0.45), ice_point_y(shape, -L*0.8, -T*0.45), ice_point_x(shape, -L*0.15, -T*0.45), ice_point_y(shape, -L*0.15, -T*0.45), 2)
		draw_line_width(ice_point_x(shape, L*0.05, -T*0.45), ice_point_y(shape, L*0.05, -T*0.45), ice_point_x(shape, L*0.3, -T*0.45), ice_point_y(shape, L*0.3, -T*0.45), 2)
		draw_set_alpha(0.9*fade)
		var corners_x = [ice_point_x(shape, -L, -T), ice_point_x(shape, L, -T), ice_point_x(shape, L, T), ice_point_x(shape, -L, T)]
		var corners_y = [ice_point_y(shape, -L, -T), ice_point_y(shape, L, -T), ice_point_y(shape, L, T), ice_point_y(shape, -L, T)]
		for (var k = 0; k < 4; k++)
			draw_line(corners_x[k], corners_y[k], corners_x[(k+1) mod 4], corners_y[(k+1) mod 4])
	}
	draw_set_alpha(1)
	draw_set_color(c_white)
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
			draw_sprite_ext(fish.sprite, floor(fish.frame), draw_x+copies_x[cx], draw_y+copies_y[cy], fish.facing*fish.scale, fish.scale*fish.flip_y, fish.angle, fish.tint, fish.alpha)
}

//---- Anglerfish (Glow): the lure's stalk, curving up from its head and out to the lure.  The lure itself is drawn
//after the darkness so it stays bright ----
if fish.move=FISH_MOVE.ANGLER
{
	var stalk_x = angler_anchor_x(fish)
	var stalk_y = angler_anchor_y(fish)
	var bend_x = stalk_x //Curves up first, then over to the lure
	var bend_y = stalk_y - 18
	var prev_x = stalk_x
	var prev_y = stalk_y
	draw_set_color(make_colour_rgb(70,110,70))
	draw_set_alpha(fish.alpha) //Just as hard to see as the body
	for (var s = 1; s <= 8; s++)
	{
		var t = s/8
		var px = sqr(1-t)*stalk_x + 2*(1-t)*t*bend_x + sqr(t)*angler_lure_x
		var py = sqr(1-t)*stalk_y + 2*(1-t)*t*bend_y + sqr(t)*angler_lure_y
		draw_line_width(prev_x, prev_y, px, py, 1)
		prev_x = px
		prev_y = py
	}
	draw_set_alpha(1)
	draw_set_color(c_white)
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

//---- Dark ponds: in dark rooms (the fishing cave), and always for the anglerfish (Glow).  Lit by the circle and the fish ----
var lighting = instance_find(obj_lighting, 0)
var room_dark = lighting<>noone and lighting.always_night
if room_dark or fish.move=FISH_MOVE.ANGLER or shadow_amount>0
{
	if !surface_exists(pond_light_surf)
		pond_light_surf = surface_create(box_size, box_size)
	surface_set_target(pond_light_surf)
	//Uses the room's obj_lighting settings when there is one
	var light_strength = room_dark ? lighting.night_amount : 1
	var pond_sky = room_dark ? lighting.sky_color(lighting.night_amount) : ((fish.move=FISH_MOVE.ANGLER) ? angler_dark_color : c_white)
	draw_clear(merge_colour(pond_sky, shadow_dark_color, shadow_amount)) //Even darker while Coal has the lights out
	var lantern_color = (lighting<>noone) ? lighting.boat_light_color : pond_lantern_color
	var fish_light_radius = (lighting<>noone) ? lighting.fish_light_radius : pond_fish_light_radius
	var fish_light_strength = (lighting<>noone) ? lighting.fish_light_strength : pond_fish_light_strength
	gpu_set_blendmode(bm_add)
	//The circle: a lantern about the size of the circle (positions are relative to the pond's corner)
	//(Coal puts it out)
	pond_light(circle_x-box_x, circle_y-box_y, circle_radius*circle_light_size, lantern_color, light_strength*(1-shadow_amount))
	//The fish glows in its own color (light in scr_fish_data).  The anglerfish's body doesn't: its lure does instead
	if !fish.hidden and fish.move<>FISH_MOVE.ANGLER
		pond_light(fish.x-box_x, fish.y-box_y, fish_light_radius*max(fish.scale, 1), fish_data.light,
			light_strength*fish_light_strength*fish.alpha*(1-shadow_amount), spr_effect_glow) //A fading ghost's glow fades too.  Coal puts its own out too
	//The anglerfish's lure lights up the water around it, just enough to make out the dark body behind it
	if fish.move=FISH_MOVE.ANGLER
		pond_light(angler_lure_x-box_x, angler_lure_y-box_y, angler_lure_light, fish_data.light, light_strength, spr_effect_glow)
	//Lightning trail (Volt) glows as it fades, and each new bolt flashes the whole pond
	if fish.move=FISH_MOVE.LIGHTNING
	{
		for (var i = 0; i < array_length(bolt_trail); i += 2)
		{
			var bit = bolt_trail[i]
			pond_light(bit.x-box_x, bit.y-box_y, bolt_trail_light, bolt_trail_color, light_strength*bit.life/bolt_trail_life, spr_effect_glow)
		}
		if bolt_flash>0
			pond_light(box_size/2, box_size/2, box_size, bolt_flash_color, light_strength*bolt_flash)
	}
	//A whirlpool (Bowl) glows faintly in the fish's color
	if fish.move=FISH_MOVE.WHIRLPOOL and whirl_amount>0
		pond_light(whirl_x-box_x, whirl_y-box_y, box_size*whirl_radius, fish_data.light, light_strength*0.4*whirl_amount, spr_effect_glow)
	//Ice walls (Cold) glow in the fish's color
	if fish.move=FISH_MOVE.ICE_WALLS
	{
		for (var i = 0; i < array_length(ice_walls); i++)
		{
			//A row of lights along the wall
			var shape = ice_shape(ice_walls[i])
			var glow_strength = light_strength*0.8*ice_strength(ice_walls[i])
			var lights = max(1, ceil(shape.half_length*2/20))
			for (var k = 0; k <= lights; k++)
			{
				var along = lerp(-shape.half_length, shape.half_length, k/lights)
				pond_light(ice_point_x(shape, along, 0)-box_x, ice_point_y(shape, along, 0)-box_y, shape.half_thick*2*ice_glow, fish_data.light, glow_strength, spr_effect_glow)
			}
		}
	}
	//Embers (Scald) glow in the fish's color
	if fish.move=FISH_MOVE.EMBERS
		for (var i = 0; i < array_length(embers); i++)
			pond_light(embers[i].x-box_x, embers[i].y-box_y, ember_light, fish_data.light, light_strength*ember_strength(embers[i]), spr_effect_glow)
	gpu_set_blendmode(bm_normal)
	surface_reset_target()

	//Multiply it over the pond, then put the pond's outline back on top
	gpu_set_blendmode_ext(bm_dest_colour, bm_zero)
	draw_surface(pond_light_surf, box_x, box_y)
	gpu_set_blendmode(bm_normal)
	draw_set_color(c_white)
	draw_rectangle(box_x, box_y, box_x+box_size, box_y+box_size, true)
}

//---- Anglerfish (Glow): the lure, bright on top of the dark ----
if fish.move=FISH_MOVE.ANGLER
{
	var pulse = 0.85 + 0.15*sin(current_time/150)
	var glow_scale = angler_lure_glow*2/sprite_get_width(spr_effect_glow)*pulse
	gpu_set_blendmode(bm_add)
	draw_sprite_ext(spr_effect_glow, 0, angler_lure_x, angler_lure_y, glow_scale, glow_scale, 0, fish_data.light, 0.8)
	gpu_set_blendmode(bm_normal)
	draw_set_color(merge_colour(c_white, fish_data.light, 0.3))
	draw_circle(angler_lure_x, angler_lure_y, 2.5, false)
	draw_set_color(c_white)
}

//---- Green bar: fills up from the bottom ----
var bar_top = box_y + box_size*(1-bar_fill)
draw_set_color(c_black)
draw_set_alpha(0.4)
draw_rectangle(bar_x, box_y, bar_x+bar_width, box_y+box_size, false)
draw_set_alpha(1)
//Turns orange while embers (Scald) are slowing it down
draw_set_color(merge_colour(c_lime, c_orange, 1-bar_grow_mult))
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
