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

//Docking: sail into a dock (rm_fishingRight) and the slime hops out onto it, then it's off to the dock's room
dock_state = 0 //0 sailing, 1 hopping out, 2 standing on the dock, 3 back from the dock's room: hopping back in
dock_armed = true //False right after hopping back in, until the boat has moved off the dock
board_wait = 30 //Back from the dock's room: steps standing on the dock before hopping in
dock_time = 0
dock_hop_frames = 40 //Steps the hop takes
dock_hop_height = 36
dock_wait = 40 //Steps on the dock before the room changes
dock_room = noone
slime_color = global.GREEN //The slime in spr_boat_test
slime_in_boat_x = 32 //Where the slime sits in spr_boat_test (top left of a 32x32 slime sprite), when facing right
slime_in_boat_y = 13
slime_x = 0 //The slime while it's out of the boat (top left of its sprite)
slime_y = 0
hop_x0 = 0
hop_y0 = 0
hop_x1 = 0
hop_y1 = 0

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

/// Hit the dock: the slime hops out of the boat onto it.  d is the dock from scr_fishing_room_info
start_docking = function(d)
{
	dock_state = 1
	dock_time = 0
	dock_room = d.room
	//Where the slime is in the boat (the sprite flips with the boat)
	hop_x0 = (facing>0) ? x+slime_in_boat_x : x+sprite_width-slime_in_boat_x-32
	hop_y0 = y+slime_in_boat_y
	//Feet on the dock
	hop_x1 = d.land_x-16
	hop_y1 = d.land_y-32
	slime_x = hop_x0
	slime_y = hop_y0
	sprite_index = spr_boat_empty
	//The boat gets pushed back a little by the jump
	xx = -0.8
	yy = 0
	var snd = audio_play_sound(snd_boing, 1, false)
	audio_sound_pitch(snd, 1.1)
}

/// Back from the dock's room (the trophy room): the empty boat waits beside the dock with the slime on it,
/// then the slime hops back in.  d is the dock from scr_fishing_room_info
start_boarding = function(d)
{
	//Boat right up against the dock, facing it
	facing = 1
	sprite_index = spr_boat_test
	x += (d.x1-6) - bbox_right
	y += (d.y1+d.y2)/2 - center_y()
	xx = 0
	yy = 0
	sprite_index = spr_boat_empty
	//From the dock to the seat in the boat
	hop_x0 = d.land_x-16
	hop_y0 = d.land_y-32
	hop_x1 = x+slime_in_boat_x
	hop_y1 = y+slime_in_boat_y
	slime_x = hop_x0
	slime_y = hop_y0
	dock_state = 3
	dock_time = 0
	dock_armed = false
}

/// Honey's stuck to the boat and it bumped the log (obj_fishing_log, see obj_fishing_honey): Gloop hops out onto the
/// log and sits with her (dock_state 4).  Click the empty boat to get him back in
normal_depth = depth //Back to this once he's in the boat again
log_face_time = 30 //Happy face this long after he lands on the log (half a second), then the idle animation
start_log = function(log_inst)
{
	dock_state = 4
	dock_time = 0
	//From his seat in the boat to his spot on the log
	hop_x0 = (facing>0) ? x+slime_in_boat_x : x+sprite_width-slime_in_boat_x-32
	hop_y0 = y+slime_in_boat_y
	hop_x1 = log_inst.gloop_seat_x()-16
	hop_y1 = log_inst.seat_y()-32
	slime_x = hop_x0
	slime_y = hop_y0
	sprite_index = spr_boat_empty
	//The jump pushes the boat back, away from the log
	xx = sign(center_x()-log_inst.log_mid_x())*0.8
	yy = 0
	//Above the log, so he's drawn sitting on it
	depth = log_inst.depth-2
	var snd = audio_play_sound(snd_boing, 1, false)
	audio_sound_pitch(snd, 1.1)
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
