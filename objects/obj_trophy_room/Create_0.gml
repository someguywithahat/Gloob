/*
	The trophy room (rm_fishingTrophy): Gloop can hop around the bowl shelves.
		- No Gloop yet: click a shelf and he jumps in onto it from the nearer side of the room.
		  The camera zooms in 2x and follows him
		- Click: he hops toward the cursor.  Hold the button and he keeps hopping until he gets there
		- Toward a spot on a shelf: hops along it, or jumps up or down to it.  Toward empty space: jumps that way
		  and lands on whatever shelf he comes down on
		- Click the far left or right edge of the room: he hops over and jumps off that side.  The camera zooms back out
	Gloop himself is obj_trophy_gloop.
*/

//---- Settings ----
zoom_in = 2           //How far the camera zooms in while Gloop is out
zoom_speed = 0.06
pan_speed = 0.1
follow_above = 40     //The camera looks this far above Gloop's feet
hop_length = 150      //Farthest one hop goes along a shelf
shelf_hop_length = 220 //Farthest a jump to another shelf goes sideways
arrive_distance = 12  //Close enough to the cursor to stop hopping
entry_in = 70         //Jumping in, he lands this far in from the end of the shelf
room_edge = 56        //Clicks this close to the left or right edge of the room send him off that side

//The shelves Gloop can stand on: the y of each shelf's top (where the bowls stand), and how far they go
shelf_ys = [152, 296, 440, 584, 728]
shelf_left = 64
shelf_right = 1298
shelf_click_above = 70 //A click this far above a shelf's top (or shelf_click_below under it) counts as clicking that shelf
shelf_click_below = 30

click_used = false //A click was used on a bowl (obj_trophy_gloop's click_sounds), so it doesn't also hop

//---- Camera ----
zoom = 1
view_cx = room_width/2  //Middle of the view
view_cy = room_height/2
view_enabled = true
view_set_visible(0, true)
view_set_wport(0, room_width)
view_set_hport(0, room_height)
cam = camera_create_view(0, 0, room_width, room_height)
view_set_camera(0, cam)

/// The shelf a click is on (its index in shelf_ys), or -1
shelf_at = function(px, py)
{
	if px<shelf_left or px>shelf_right
		return -1;
	for (var i = 0; i < array_length(shelf_ys); i++)
		if py>=shelf_ys[i]-shelf_click_above and py<=shelf_ys[i]+shelf_click_below
			return i;
	return -1;
}

/// One hop toward the cursor (px, py).  clicked is true for a fresh click, false while the button is held
hop_toward = function(g, px, py, clicked)
{
	//Left or right edge of the room: hop over there, then jump off once he's close
	if px<room_edge or px>room_width-room_edge
	{
		var side = (px<room_edge) ? -1 : 1
		var to_end = (side<0) ? g.x-shelf_left : shelf_right-g.x
		if to_end<=hop_length
			g.leave(side)
		else
			g.jump_to(g.x+side*hop_length, g.y, 30)
		return;
	}

	var shelf = shelf_at(px, py)
	if shelf>=0
	{
		var target_y = shelf_ys[shelf]
		var dx = clamp(px, shelf_left+16, shelf_right-16) - g.x
		if target_y=g.y
		{
			//Along this shelf
			if abs(dx)<arrive_distance
				return;
			g.jump_to(g.x+clamp(dx, -hop_length, hop_length), target_y, 30)
		}
		else //Up or down to that shelf
			g.jump_to(g.x+clamp(dx, -shelf_hop_length, shelf_hop_length), target_y, 60)
		return;
	}

	//Empty space: jump that way (holding: stop once he's about there)
	if !clicked and point_distance(g.x, g.y-32, px, py)<60
		return;
	g.jump_toward(px, py)
}
