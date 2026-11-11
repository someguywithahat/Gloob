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
