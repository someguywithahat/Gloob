//---- Falling down the waterfall (rm_fishingUp): tumbles until it lands in the water below ----
if falling
{
	fall_vy += fall_gravity
	y += fall_vy
	x += vx*0.4
	//Spins every which way: the spin speed keeps changing at random
	fall_spin = clamp(fall_spin + random_range(-fall_spin_change, fall_spin_change), -fall_spin_max, fall_spin_max)
	fall_angle += fall_spin
	if y+sprite_height/2>=fall_land_y
	{
		//Splash!  Back in the water, swimming away from the falls
		y = fall_land_y-sprite_height/2
		falling = false
		layer = home_layer
		vx = random_range(-1, 1)
		vy = random_range(0.4, 1)
		turn_timer = irandom_range(60, 120)
		add_splash(x+sprite_width/2, y+sprite_height/2)
	}
	update_splashes()
	hovered = false
	in_range = false
	exit
}

//---- Wander: pick a new direction every so often ----
turn_timer--
if turn_timer<=0
{
	vx = random_range(-1, 1)
	vy = random_range(-0.3, 0.3)
	turn_timer = irandom_range(60, 180)
}

//---- Swim away from the boat when it gets close ----
var my_x = (bbox_left+bbox_right)/2
var my_y = (bbox_top+bbox_bottom)/2
var boat = instance_nearest(my_x, my_y, obj_gloopFishing)
if boat<>noone
{
	var boat_x = (boat.bbox_left+boat.bbox_right)/2
	var boat_y = (boat.bbox_top+boat.bbox_bottom)/2
	if point_distance(my_x, my_y, boat_x, boat_y)<flee_range
	{
		vx += sign(my_x-boat_x)*flee_push
		vy += sign(my_y-boat_y)*flee_push
	}
}

//---- And from the slimes splashing around up top (obj_fishing_splasher) ----
var splasher = instance_nearest(my_x, my_y, obj_fishing_splasher)
if splasher<>noone and point_distance(my_x, my_y, splasher.mid_x(), splasher.mid_y())<splasher.scare_range
{
	vx += sign(my_x-splasher.mid_x())*splasher.scare_push
	vy += sign(my_y-splasher.mid_y())*splasher.scare_push
}
vx = clamp(vx, -max_speed, max_speed)
vy = clamp(vy, -max_speed, max_speed)

//---- Stay in the water: turn around at the shore and at the edges of the room ----
if place_meeting(x+vx, y, obj_gloopFishingWall) or x+vx<0 or x+vx+sprite_width>room_width
	vx *= -1
if place_meeting(x, y+vy, obj_gloopFishingWall) or y+vy<0 or y+vy+sprite_height>room_height
	vy *= -1

//---- The waterfall (obj_gloopFishingWaterfallTop): up top, the water only goes one way: over the edge ----
var top_area = instance_position(my_x, my_y, obj_gloopFishingWaterfallTop)
if top_area<>noone
{
	//Up top: the sides and top of the area are like the shore
	if my_x+vx<top_area.bbox_left or my_x+vx>top_area.bbox_right
		vx *= -1
	if my_y+vy<top_area.bbox_top
		vy *= -1
	//Swimming off the bottom edge: over the falls, if there's water below to land in (otherwise it's shore)
	if my_y+vy>top_area.bbox_bottom and !jumping
	{
		var land_y = top_area.bbox_bottom + waterfall_drop
		if place_meeting(x, land_y-sprite_height/2, obj_gloopFishingWall) or land_y+sprite_height/2>room_height
			vy *= -1
		else
		{
			falling = true
			fall_vy = max(vy, 0.5)
			fall_angle = 0
			fall_spin = random_range(-fall_spin_max, fall_spin_max)*0.5
			fall_land_y = land_y
			//Above the water effect while it falls
			var fall_top_layer = layer_get_id("Instances")
			if fall_top_layer<>-1
				depth = layer_get_depth(fall_top_layer)-1
			exit
		}
	}
}
else
{
	//Down below: can't swim up the waterfall
	if position_meeting(my_x+vx, my_y, obj_gloopFishingWaterfallTop)
		vx *= -1
	if position_meeting(my_x, my_y+vy, obj_gloopFishingWaterfallTop)
		vy *= -1
}
x += vx
y += vy

//---- Now and then, jump out of the water ----
var mid_x = (bbox_left+bbox_right)/2
var mid_y = (bbox_top+bbox_bottom)/2
if jumping
{
	jump_time++
	if jump_time>=jump_frames
	{
		//Splash down, back under the water
		jumping = false
		layer = home_layer
		jump_cooldown = jump_cooldown_min
		add_splash(mid_x, mid_y)
	}
}
else if jump_cooldown>0
	jump_cooldown--
else if !hovered and !instance_exists(obj_fishing_minigame) and !is_undefined(fish_data) and random(1)<jump_chance
{
	jumping = true
	jump_time = 0
	jump_facing = (vx<0) ? -1 : 1
	//Leap forward, mostly sideways, and don't turn around in the air
	vx = jump_facing*max(abs(vx), jump_speed)
	vy = clamp(vy, -0.3, 0.3)
	turn_timer = max(turn_timer, jump_frames+1)
	//Above the water effect and the boat while it's in the air
	var top_layer = layer_get_id("Instances")
	if top_layer<>-1
		depth = layer_get_depth(top_layer)-1
	add_splash(mid_x, mid_y)
}

//Splashes play through once, then go away
update_splashes()

//---- Mouse over it: shows the net under it.  Click to try to catch it, if the boat is close enough ----
var fish_x = (bbox_left+bbox_right)/2
var fish_y = (bbox_top+bbox_bottom)/2
hovered = !jumping and !instance_exists(obj_fishing_minigame) and !is_undefined(fish_data) and position_meeting(mouse_x, mouse_y, id)
in_range = false
if boat<>noone
	in_range = point_distance(fish_x, fish_y, (boat.bbox_left+boat.bbox_right)/2, (boat.bbox_top+boat.bbox_bottom)/2)<=catch_range
//Catching it costs a fishing ticket, so you need one to try
has_ticket = variable_global_exists("fishing_tickets") and global.fishing_tickets>0
if hovered and in_range and has_ticket and mouse_check_button_pressed(mb_left)
{
	global.fishing_test_fish = fish_data //obj_fishing_minigame picks this up and clears it
	var game = instance_create_depth(0, 0, -15000, obj_fishing_minigame)
	game.source_fish = id //Caught fish leave the water
}
