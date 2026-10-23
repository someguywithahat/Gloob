/*
	Fishing minigame.  A light blue pond square with a fish swimming around and a circle that follows the mouse.
	Keep the fish inside the circle to fill the green bar on the left.
		Bar full  -> caught it
		Bar empty -> it got away

	Started by obj_controller when F is pressed in rm_fishingTest.  Removes itself when the round is over.

	The fish themselves (names, sprites, speeds, movement types) are all in scr_fish_data.
	Each movement type has a swim function below.
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
bar_fill = 0.3 //0-1.  Starts at 30%
bar_grow = 0.25/60 //Per step while the fish is in the circle (about 4 seconds from empty to full)
bar_shrink = 0.2/60 //Per step while it isn't (about 2 seconds to lose the starting 10%)

//---- Player circle: follows the mouse with slow acceleration and deceleration ----
circle_radius = 52
circle_x = box_x + box_size/2
circle_y = box_y + box_size/2
circle_vx = 0
circle_vy = 0
circle_accel = 0.3 //How quickly it speeds up or slows down
circle_max_speed = 4
circle_follow = 0.06 //How hard it pulls toward the mouse.  Lower = lazier near the mouse
fish_in_circle = false

//---- Ending ----
result = 0 //0 = playing, 1 = caught, -1 = got away
end_timer = 0
end_time = 90 //Steps the result shows before the minigame closes


//---- Which fish ----
//-1 = a random fish from any group.  Set to 0-4 to only get fish from that group (see scr_fish_data)
fish_group = -1
fish_data = (fish_group<0) ? scr_fish_random_any() : scr_fish_random(fish_group)
//obj_fishingTest asks for a specific fish
if variable_global_exists("fishing_test_fish") and !is_undefined(global.fishing_test_fish)
{
	fish_data = global.fishing_test_fish
	global.fishing_test_fish = undefined
}


/// Builds the swimming fish from its scr_fish_data row
make_fish = function(data)
{
	var start_x = box_x + box_size/2
	var start_y = box_y + box_size/2
	if data.move=FISH_MOVE.WALKING
		start_y = box_y + box_size - sprite_get_height(data.sprite)/2 //Starts on the bottom
	
	return {
		name: data.name,
		sprite: data.sprite,
		accel: data.accel,
		decel: data.decel,
		max_speed: data.max_speed,
		move: data.move,
		x: start_x, //Center of the fish
		y: start_y,
		vx: 0,
		vy: 0,
		frame: 0,
		facing: 1,
		//Where it's swimming to, and for how long before it changes its mind
		goal_x: start_x,
		goal_y: start_y,
		goal_timer: 0,
		wait_timer: 0, //Dash and wait: steps left to sit still
		zig_dir: choose(-1, 1) //Zigzag: which way the fast dart is going right now
	}
}

/// Changes one velocity toward want: accel when speeding up, decel when slowing down
approach_speed = function(current, want, accel, decel)
{
	var rate = (abs(want)>abs(current) and sign(want)=sign(current)) ? accel : decel
	if current=0
		rate = accel
	return current + clamp(want-current, -rate, rate)
}

/// Swim toward the fish's goal, slowing down as it gets close
swim_toward_goal = function(fish, top_speed)
{
	var dir = point_direction(fish.x, fish.y, fish.goal_x, fish.goal_y)
	var dist = point_distance(fish.x, fish.y, fish.goal_x, fish.goal_y)
	var want_speed = min(top_speed, dist*0.1)
	fish.vx = approach_speed(fish.vx, lengthdir_x(want_speed, dir), fish.accel, fish.decel)
	fish.vy = approach_speed(fish.vy, lengthdir_y(want_speed, dir), fish.accel, fish.decel)
}

/// A random spot in the pond
pick_goal = function(fish)
{
	var margin = 20
	fish.goal_x = random_range(box_x+margin, box_x+box_size-margin)
	fish.goal_y = random_range(box_y+margin, box_y+box_size-margin)
}


//---- Swim functions, one per FISH_MOVE ----

/// Moving constantly: always swimming toward a random spot, picking a new one every so often
swim_constant = function(fish)
{
	fish.goal_timer--
	if fish.goal_timer<=0 or point_distance(fish.x, fish.y, fish.goal_x, fish.goal_y)<10
	{
		pick_goal(fish)
		fish.goal_timer = irandom_range(30, 90)
	}
	swim_toward_goal(fish, fish.max_speed)
}

/// Dash and wait: dashes to a random spot, stops there for a moment, then dashes again
swim_dash_wait = function(fish)
{
	if fish.wait_timer>0
	{
		//Waiting: drift to a stop
		fish.wait_timer--
		fish.vx = approach_speed(fish.vx, 0, fish.accel, fish.decel)
		fish.vy = approach_speed(fish.vy, 0, fish.accel, fish.decel)
		if fish.wait_timer<=0
			pick_goal(fish)
		return;
	}
	swim_toward_goal(fish, fish.max_speed)
	if point_distance(fish.x, fish.y, fish.goal_x, fish.goal_y)<10
		fish.wait_timer = irandom_range(30, 75)
}

/// Walking: only moves left and right along the bottom of the pond
swim_walking = function(fish)
{
	fish.goal_timer--
	if fish.goal_timer<=0 or abs(fish.x-fish.goal_x)<10
	{
		var margin = 20
		fish.goal_x = random_range(box_x+margin, box_x+box_size-margin)
		fish.goal_timer = irandom_range(30, 90)
	}
	var want_vx = clamp((fish.goal_x-fish.x)*0.1, -fish.max_speed, fish.max_speed)
	fish.vx = approach_speed(fish.vx, want_vx, fish.accel, fish.decel)
	fish.vy = 0
	fish.y = box_y + box_size - sprite_get_height(fish.sprite)/2
}

/// Float up: rises to the top of the pond and stays there
swim_float_up = function(fish)
{
	var top_y = box_y + sprite_get_height(fish.sprite)/2
	var want_vy = clamp((top_y-fish.y)*0.1, -fish.max_speed, 0)
	fish.vy = approach_speed(fish.vy, want_vy, fish.accel, fish.decel)
	fish.vx = approach_speed(fish.vx, 0, fish.accel, fish.decel)
}

zig_band = 70 //Zigzag: how far each fast dart goes from the middle of its sweep
zig_slow = 0.3 //Zigzag: drift speed as a fraction of max_speed

/// Zigzag: darts rapidly back and forth on one axis while slowly drifting on the other.
/// fast_is_vertical = true for up and down darts (Rolled), false for left and right darts (Fold)
swim_zigzag = function(fish, fast_is_vertical)
{
	//Slow drift: wander toward a random spot on the other axis
	fish.goal_timer--
	if fish.goal_timer<=0
	{
		pick_goal(fish)
		fish.goal_timer = irandom_range(90, 180)
	}
	var slow_speed = fish.max_speed*zig_slow

	//Fast darts: sweep back and forth across a band, turning around at each end
	var half_fish = sprite_get_width(fish.sprite)/2
	var low, high
	if fast_is_vertical
	{
		low = max(box_y+half_fish, box_y+box_size/2-zig_band)
		high = min(box_y+box_size-half_fish, box_y+box_size/2+zig_band)
		if (fish.zig_dir<0 and fish.y<=low) or (fish.zig_dir>0 and fish.y>=high)
			fish.zig_dir *= -1
		fish.vy = approach_speed(fish.vy, fish.zig_dir*fish.max_speed, fish.accel, fish.decel)
		var want_vx = clamp((fish.goal_x-fish.x)*0.05, -slow_speed, slow_speed)
		fish.vx = approach_speed(fish.vx, want_vx, fish.accel, fish.decel)
	}
	else
	{
		low = max(box_x+half_fish, box_x+box_size/2-zig_band)
		high = min(box_x+box_size-half_fish, box_x+box_size/2+zig_band)
		if (fish.zig_dir<0 and fish.x<=low) or (fish.zig_dir>0 and fish.x>=high)
			fish.zig_dir *= -1
		fish.vx = approach_speed(fish.vx, fish.zig_dir*fish.max_speed, fish.accel, fish.decel)
		var want_vy = clamp((fish.goal_y-fish.y)*0.05, -slow_speed, slow_speed)
		fish.vy = approach_speed(fish.vy, want_vy, fish.accel, fish.decel)
	}
}

/// Moves the fish for one step using its movement type
swim = function(fish)
{
	switch(fish.move)
	{
		case FISH_MOVE.CONSTANT:          swim_constant(fish);        break
		case FISH_MOVE.DASH_WAIT:         swim_dash_wait(fish);       break
		case FISH_MOVE.WALKING:           swim_walking(fish);         break
		case FISH_MOVE.FLOAT_UP:          swim_float_up(fish);        break
		case FISH_MOVE.ZIGZAG_UP_DOWN:    swim_zigzag(fish, true);    break
		case FISH_MOVE.ZIGZAG_LEFT_RIGHT: swim_zigzag(fish, false);   break
	}
}

fish = make_fish(fish_data)
