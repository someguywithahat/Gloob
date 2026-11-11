/*
	The log on the beach in the north fishing room (rm_fishingUp).  Same look as the Spr_Obs_2x1_Log that was there
	(set its frame, scale and position in the room editor).
	When the boat bumps it with Honey stuck to it (obj_fishing_honey), Gloop and Honey hop onto it and sit together.
	Click the empty boat to get Gloop back in.
*/

//---- Settings ----
depth_layer = "Assets_1" //Draws at this layer's depth, where the log used to be
wood_top = 13            //How far down the sprite the slimes sit (sprite pixels; the wood's top edge is at 10)
seat_gap = 18            //Gloop sits this far left of the middle, Honey this far right
bump_margin = 10         //The boat counts as hitting it this far out from its edges

image_speed = 0
var log_layer = layer_get_id(depth_layer)
if log_layer<>-1
	depth = layer_get_depth(log_layer)

/// The middle of the log, and where each slime sits (their feet)
log_mid_x = function() { return (bbox_left+bbox_right)/2 }
seat_y = function() { return y + wood_top*image_yscale }
gloop_seat_x = function() { return log_mid_x() - seat_gap }
honey_seat_x = function() { return log_mid_x() + seat_gap }

/// True if the boat is touching the log
boat_hits = function(boat)
{
	var across = boat.bbox_right>=bbox_left-bump_margin and boat.bbox_left<=bbox_right+bump_margin
	var down = boat.bbox_bottom>=bbox_top-bump_margin and boat.bbox_top<=bbox_bottom+bump_margin
	return across and down;
}
