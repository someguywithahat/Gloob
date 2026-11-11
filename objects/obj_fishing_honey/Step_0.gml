//Asleep: loops the snoring part of the sleep animation (frames 20-50), like the sideline slimes
anim += 8/game_get_speed(gamespeed_fps)
if anim>50
	anim = 20

//Gloop sails past: a heart above his head
var boat = instance_find(obj_gloopFishing, 0)
if boat<>noone
{
	var dist = point_distance(boat.center_x(), boat.center_y(), x+16, y+20)
	if armed and dist<=pass_distance
	{
		armed = false
		//Over the slime in the boat (spr_boat_test flips with the boat).  The heart is 16x16, top left origin
		var head_x = (boat.facing>0) ? boat.x+boat.slime_in_boat_x+16 : boat.x+boat.sprite_width-boat.slime_in_boat_x-16
		var head_y = boat.y+boat.slime_in_boat_y+8 //Top of his body
		var heart = instance_create_layer(head_x-8, head_y-20, "Instances", obj_effect_heart)
		heart.depth = boat.depth-1
	}
	else if !armed and dist>=rearm_distance
		armed = true
}
