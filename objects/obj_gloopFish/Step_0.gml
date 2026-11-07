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
vx = clamp(vx, -max_speed, max_speed)
vy = clamp(vy, -max_speed, max_speed)

//---- Stay in the water: turn around at the shore and at the edges of the room ----
if place_meeting(x+vx, y, obj_gloopFishingWall) or x+vx<0 or x+vx+sprite_width>room_width
	vx *= -1
if place_meeting(x, y+vy, obj_gloopFishingWall) or y+vy<0 or y+vy+sprite_height>room_height
	vy *= -1
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
for (var i = array_length(splashes)-1; i >= 0; i--)
{
	splashes[i].frame += 0.25
	if splashes[i].frame>=sprite_get_number(Spr_Ripple)
	{
		layer_sprite_destroy(splashes[i].el)
		array_delete(splashes, i, 1)
	}
	else
		layer_sprite_index(splashes[i].el, floor(splashes[i].frame))
}

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
