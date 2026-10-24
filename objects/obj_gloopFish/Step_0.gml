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

//---- Click it to try to catch it ----
if mouse_check_button_pressed(mb_left) and !instance_exists(obj_fishing_minigame) and !is_undefined(fish_data)
	and position_meeting(mouse_x, mouse_y, id)
{
	global.fishing_test_fish = fish_data //obj_fishing_minigame picks this up and clears it
	var game = instance_create_depth(0, 0, -15000, obj_fishing_minigame)
	game.source_fish = id //Caught fish leave the water
}
