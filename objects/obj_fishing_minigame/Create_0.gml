/*
	Fishing minigame.  A light blue pond square with a fish swimming around and a circle that follows the mouse.
	Keep the fish inside the circle to fill the green bar on the left.
		Bar full  -> caught it
		Bar empty -> it got away

	Started by obj_controller when F is pressed in rm_fishingTest.  Removes itself when the round is over.

	Different fish: each fish is a struct with its sprite, speed and a swim function (see make_fish below).
	Add a new swim function and a new make_fish call for a fish that swims differently.
*/
depth=-15000 //Above everything in the room

//---- Pond square: centered, half the screen tall ----
box_size = room_height/2
box_x = (room_width-box_size)/2
box_y = (room_height-box_size)/2
box_color = make_colour_rgb(160,215,255)

//---- Green catch bar, to the left of the pond ----
bar_width = 16
bar_gap = 14 //Space between the bar and the pond
bar_x = box_x - bar_gap - bar_width
bar_fill = 0.1 //0-1.  Starts at 10%
bar_grow = 0.25/60 //Per step while the fish is in the circle (about 4 seconds from empty to full)
bar_shrink = 0.05/60 //Per step while it isn't (about 2 seconds to lose the starting 10%)

//---- Player circle: follows the mouse with slow acceleration and deceleration ----
circle_radius = 52
circle_x = box_x + box_size/2
circle_y = box_y + box_size/2
circle_vx = 0
circle_vy = 0
circle_accel = 0.18 //How quickly it speeds up or slows down
circle_max_speed = 4
circle_follow = 0.06 //How hard it pulls toward the mouse.  Lower = lazier near the mouse
fish_in_circle = false

//---- Ending ----
result = 0 //0 = playing, 1 = caught, -1 = got away
end_timer = 0
end_time = 90 //Steps the result shows before the minigame closes


/// Gold fish: darts to a random spot, swims there fast, picks another.  Speed and acceleration beat the circle's
make_fish = function(sprite, max_speed, accel, swim)
{
	return {
		sprite: sprite,
		x: box_x + box_size/2, //Center of the fish
		y: box_y + box_size/2,
		vx: 0,
		vy: 0,
		max_speed: max_speed,
		accel: accel,
		frame: 0,
		facing: 1,
		//Where it's swimming to, and for how long before it changes its mind
		goal_x: box_x + box_size/2,
		goal_y: box_y + box_size/2,
		goal_timer: 0,
		swim: swim //Called every step to move the fish
	}
}

/// Swim pattern: random darting.  Picks a random spot every so often and swims there
swim_random = function(fish)
{
	fish.goal_timer--
	if fish.goal_timer<=0 or point_distance(fish.x, fish.y, fish.goal_x, fish.goal_y)<10
	{
		var margin = 20
		fish.goal_x = random_range(box_x+margin, box_x+box_size-margin)
		fish.goal_y = random_range(box_y+margin, box_y+box_size-margin)
		fish.goal_timer = irandom_range(30, 90)
	}

	//Speed up toward the goal, slowing down as it gets close
	var dir = point_direction(fish.x, fish.y, fish.goal_x, fish.goal_y)
	var dist = point_distance(fish.x, fish.y, fish.goal_x, fish.goal_y)
	var want_speed = min(fish.max_speed, dist*0.1)
	var want_vx = lengthdir_x(want_speed, dir)
	var want_vy = lengthdir_y(want_speed, dir)
	fish.vx += clamp(want_vx-fish.vx, -fish.accel, fish.accel)
	fish.vy += clamp(want_vy-fish.vy, -fish.accel, fish.accel)
}

fish = make_fish(Spr_Fish_Gold, 4.5, 0.4, swim_random)
