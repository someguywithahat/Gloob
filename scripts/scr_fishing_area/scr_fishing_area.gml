/*
	The fishing area: rm_fishingCenter in the middle, with rm_fishingUp, rm_fishingDown, rm_fishingLeft and rm_fishingRight
	around it.  Sail the boat (obj_gloopFishing) off an edge to go to the room on that side.  The outer rooms only
	connect back to the center.

	Each room has its own fish group from scr_fish_data:
		Center 0, Up 1, Left 2, Right 3, Down 4
	rm_fishingDown is a dark cave (obj_lighting in always-night mode)

	obj_controller's Room Start event calls scr_fishing_room_start, which puts the boat in place and spawns the fish.
*/

#macro FISHING_FISH_MIN 10 //Fish spawned in each fishing room
#macro FISHING_FISH_MAX 14
#macro FISHING_EDGE_MARGIN 24 //How far in from the edge the boat starts when it sails into a room (more than its exit_distance, so it doesn't sail straight back out)

/// Layout of a fishing room, or undefined if rm isn't one.
///   group                 -- fish group (scr_fish_data)
///   up/down/left/right    -- room on that side, or noone
///   enter_*               -- where the boat comes in on each side (the middle of the boat), lined up with the gap in
///                            the shoreline.  enter_top/enter_bottom are x positions, enter_left/enter_right are y positions
function scr_fishing_room_info(rm){
	switch(rm)
	{
		case rm_fishingCenter: return { group: 0, up: rm_fishingUp, down: rm_fishingDown, left: rm_fishingLeft, right: rm_fishingRight,
			enter_top: 800, enter_bottom: 560, enter_left: 336, enter_right: 416 }
		case rm_fishingUp:     return { group: 1, up: noone, down: rm_fishingCenter, left: noone, right: noone,
			enter_top: 683, enter_bottom: 683, enter_left: 384, enter_right: 384 }
		case rm_fishingLeft:   return { group: 2, up: noone, down: noone, left: noone, right: rm_fishingCenter,
			enter_top: 683, enter_bottom: 683, enter_left: 384, enter_right: 384 }
		case rm_fishingRight:  return { group: 3, up: noone, down: noone, left: rm_fishingCenter, right: noone,
			enter_top: 683, enter_bottom: 683, enter_left: 384, enter_right: 384 }
		case rm_fishingDown:   return { group: 4, up: rm_fishingCenter, down: noone, left: noone, right: noone,
			enter_top: 683, enter_bottom: 683, enter_left: 384, enter_right: 384 }
	}
	return undefined
}

/// Sail into another fishing room.  enter_side is the side of the new room the boat comes in on ("top", "bottom", "left", "right")
function scr_fishing_go(next_room, enter_side){
	global.fishing_enter_side = enter_side
	room_goto(next_room)
}

/// Called when any room starts.  In a fishing room: puts the boat in place and fills the water with fish
function scr_fishing_room_start(){
	var info = scr_fishing_room_info(room)
	if is_undefined(info)
		return;

	//The boat.  rm_fishingCenter has one placed in the room editor; the other rooms get one made
	var boat = instance_find(obj_gloopFishing, 0)
	if boat=noone
		boat = instance_create_layer(room_width/2, room_height/2, "Instances", obj_gloopFishing)

	//Sailing in from another fishing room: start at the edge it came in on
	var side = variable_global_exists("fishing_enter_side") ? global.fishing_enter_side : ""
	global.fishing_enter_side = ""
	if side<>""
		with(boat)
			place_at_edge(side, info)

	//Fish from this room's group
	repeat(irandom_range(FISHING_FISH_MIN, FISHING_FISH_MAX))
		scr_fishing_spawn_fish(info.group, boat)

	//Trophy clams on the center island
	if room=rm_fishingCenter
		scr_fishing_spawn_clams()

	//The cave is always dark.  Same night lighting as the game board, lit by the boat and the fish
	if room=rm_fishingDown
	{
		var lighting = instance_create_layer(0, 0, "Instances", obj_lighting)
		lighting.always_night = true
		lighting.night_amount = lighting.max_night //Already dark when you sail in
	}
}

#macro CLAM_LEFT 460 //Trophy clams: the island in rm_fishingCenter is x 384-896, y 192-576
#macro CLAM_TOP 340 //(clam positions are the bottom middle of each shell)
#macro CLAM_SPACING_X 120
#macro CLAM_SPACING_Y 170

/// Puts the 8 trophy clams on the center island, two rows of four, one for each fish in group 0 (in table order)
function scr_fishing_spawn_clams(){
	var fish_list = global.FISH_GROUPS[0]
	for (var i = 0; i < array_length(fish_list); i++)
	{
		var clam = instance_create_layer(CLAM_LEFT + (i mod 4)*CLAM_SPACING_X, CLAM_TOP + (i div 4)*CLAM_SPACING_Y, "Instances", obj_clamTrophy)
		clam.set_fish(fish_list[i])
	}
}

/// Spawns one fish from a fish group somewhere in the water (not on land, and not right under the boat)
function scr_fishing_spawn_fish(group, boat){
	var data = scr_fish_random(group)
	var w = sprite_get_width(data.sprite)
	var h = sprite_get_height(data.sprite)
	repeat(40)
	{
		var fish_x = random_range(20, room_width-w-20)
		var fish_y = random_range(20, room_height-h-20)
		if collision_rectangle(fish_x-8, fish_y-8, fish_x+w+8, fish_y+h+8, obj_gloopFishingWall, false, true)<>noone
			continue
		if instance_exists(boat) and point_distance(fish_x, fish_y, boat.x, boat.y)<150
			continue
		var fish = instance_create_layer(fish_x, fish_y, "Instances_Underwater", obj_gloopFish)
		fish.set_fish(data)
		return fish
	}
	return noone
}
