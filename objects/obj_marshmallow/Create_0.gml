/*
	A marshmallow on the beach (secret).  Place them anywhere in the room editor.
	Click and hold to drag it around (the boat doesn't steer while you do).  Let go and it floats back to its spot.
	Mallow (obj_fishing_splasher, the white one) follows it if it's near her, and eats it if it touches her.
	Once eaten it comes back to its spot after a little while.
	Sprite: spr_effect_Snack frame 0 (16x16, top left origin).  x, y is the top left of its spot.
*/

//---- Settings ----
return_speed = 0.15 //How quickly it floats back to its spot after you let go
respawn_time = 180  //Steps after being eaten before it's back

image_speed = 0
image_index = 0
home_x = x
home_y = y
dragging = false
grab_x = 0 //Where on it the mouse grabbed it
grab_y = 0
eaten = false
respawn_timer = 0
pop = 1 //Grows back in when it comes back (0 to 1)

//Above everything in the room, including slimes in the air
var top_layer = layer_get_id("Instances")
if top_layer<>-1
	depth = layer_get_depth(top_layer)-10

if !variable_global_exists("dragging_snack")
	global.dragging_snack = noone

/// Middle of the marshmallow
mid_x = function() { return x+8 }
mid_y = function() { return y+8 }

/// Mallow ate it.  Gone for a bit, then back at its spot
eat = function()
{
	eaten = true
	dragging = false
	if global.dragging_snack=id
		global.dragging_snack = noone
	respawn_timer = respawn_time
	x = home_x
	y = home_y
}
