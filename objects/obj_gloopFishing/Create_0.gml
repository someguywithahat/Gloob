/*
	The player's boat in the fishing rooms.  Hold the left mouse button to sail toward the cursor.
	Sail off an edge of a fishing room to go to the room on that side (see scr_fishing_area).
*/
xx=0 //Speed
yy=0
max_speed=3
acceleration=0.08 //Speeding up toward the cursor
slow_down=0.04 //Gliding to a stop after letting go
facing=1
exit_distance=8 //Get the front of the boat this close to an edge with a room beyond it to sail there.  Keep it below FISHING_EDGE_MARGIN

//Fishing ticket used: shows the ticket sign and the new total above the boat for a moment
ticket_popup_time = 100 //Steps it shows
ticket_popup_timer = 0
ticket_popup_total = 0
ticket_popup_rise = 12 //Floats up this many pixels while it shows

/// Middle of the boat (its sprite has a top left origin)
center_x = function() { return (bbox_left+bbox_right)/2 }
center_y = function() { return (bbox_top+bbox_bottom)/2 }

/// Moves the boat to just inside one edge of the room, where it sailed in.  info is from scr_fishing_room_info
place_at_edge = function(side, info)
{
	var half_w = (bbox_right-bbox_left)/2
	var half_h = (bbox_bottom-bbox_top)/2
	var to_x = room_width/2
	var to_y = room_height/2
	switch(side)
	{
		case "top":    to_x = info.enter_top;    to_y = FISHING_EDGE_MARGIN+half_h; break
		case "bottom": to_x = info.enter_bottom; to_y = room_height-FISHING_EDGE_MARGIN-half_h; break
		case "left":   to_x = FISHING_EDGE_MARGIN+half_w; to_y = info.enter_left; break
		case "right":  to_x = room_width-FISHING_EDGE_MARGIN-half_w; to_y = info.enter_right; break
	}
	x += to_x - center_x()
	y += to_y - center_y()
	//Keep a little speed going into the room
	xx = (side="left") - (side="right")
	yy = (side="top") - (side="bottom")
}

/// A fishing ticket was just used: toss it away (like a lost hard hat) and show the new total above the boat
show_ticket_spent = function(total)
{
	ticket_popup_timer = ticket_popup_time
	ticket_popup_total = total
	var toss = instance_create_depth(center_x()-8, bbox_top-8, depth-1, obj_effect_dropped_hat)
	toss.sprite_index = Spr_Pu_Fish_Sign
	toss.xx = choose(-1, 1)*random_range(1.5, 2.5)
	toss.yy = -3
	var punch = audio_play_sound(snd_menu_chime, 1, false)
	audio_sound_pitch(punch, 0.8)
}
