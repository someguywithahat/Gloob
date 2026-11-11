/*
	Honey, the yellow slime, asleep on the shore of the north fishing room (rm_fishingUp).  She never wakes up.
	When the boat sails past her, a heart floats up above Gloop's head (obj_effect_heart), once each time he goes by.
	The instance's x, y is the top left of her 32x32 sprite.
*/

//---- Settings ----
color_index = global.YELLOW
pass_distance = 80 //The boat this close (middle to middle) counts as passing her
rearm_distance = 180 //It has to get this far away again before the next pass makes another heart

image_speed = 0 //Animated by hand
anim = 20 //Already asleep: starts in the snoring part of the sleep animation
armed = true //Ready to make a heart the next time the boat passes

//---- The boat bumps her: she sticks to the front of it, surprised.  Bump the log (obj_fishing_log) and she and
//Gloop hop onto it and sit together.  When Gloop gets back in the boat, she dozes off on the log ----
bow_x = 66          //Where she clings to the boat: her left edge, from the boat's left edge (facing right)
bow_y = 14          //Her top, from the boat's top
hop_frames = 40     //Hopping onto the log
hop_height = 30
sit_face_time = 30  //Sitting with Gloop: heart eyes this long after landing (half a second), then the idle animation
state = "sleep"     //"sleep", "stuck", "hop", "sit"
state_time = 0
hop_x0 = x
hop_y0 = y
hop_x1 = x
hop_y1 = y
the_log = noone

set_state = function(new_state)
{
	state = new_state
	state_time = 0
}

/// Where she clings to the boat (top left of her sprite).  The boat's sprite flips with it
cling_x = function(boat) { return (boat.facing>0) ? boat.x+bow_x : boat.x+boat.sprite_width-bow_x-32 }
cling_y = function(boat) { return boat.y+bow_y }
