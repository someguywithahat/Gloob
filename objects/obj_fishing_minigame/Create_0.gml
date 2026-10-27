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
bar_fill = 0.3 //0-1.  Set from the fish's start_bar (scr_fish_data) once the fish is picked
bar_grow = 0.25/60 //Per step while the fish is caught.  Set from the fish's bar_grow (scr_fish_data)
bar_shrink = 0.2/60 //Per step while it isn't.  Set from the fish's bar_shrink (scr_fish_data)

//---- Player circle: follows the mouse with slow acceleration and deceleration ----
circle_radius = 52
circle_x = box_x + box_size/2
circle_y = box_y + box_size/2
circle_vx = 0
circle_vy = 0
circle_accel = 0.3 //How quickly it speeds up or slows down
circle_max_speed = 4
circle_follow = 0.06 //How hard it pulls toward the mouse.  Lower = lazier near the mouse
catching = false //True while the bar is filling
catch_glow = 0.35 //How strongly the catch bowl (Spr_Catch_Bowl) lights up yellow while catching

//---- Crowd of decoy fish (Hold) ----
crowd = [] //The decoys.  Filled in by swim_crowd
crowd_draw_slot = 0 //Where the real fish is drawn among the decoys

//---- Fishing line (Poled) drags a hooked circle ----
hook_pull_x = 0 //Pixels per step this step
hook_pull_y = 0
circle_hooked = false //True while hooked: the circle only gets half its usual acceleration

//---- Wind (Gail's gusts push the circle) ----
wind_amount = 0 //-1 full gust left, 1 full gust right

//---- The fish in the fishing room this round is for (obj_gloopFish).  It leaves the water when it's caught ----
source_fish = noone

//---- Dark rooms (the fishing cave): the pond is dark too ----
//Uses the room's obj_lighting (always-night) for the night color and the fish glow settings
pond_light_surf = -1
circle_light_size = 1.1 //The circle's light, as a multiple of its radius.  spr_effect_glow_harder is solid to about 85% of its size, so 1.1 lines the bright part up with the circle

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
	//Every fish starts in the middle of the pond
	var start_x = box_x + box_size/2
	var start_y = box_y + box_size/2

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
		zig_dir: choose(-1, 1), //Zigzag, fly and orbit: which way it's going right now
		angle: 0, //Rotation in degrees, around the fish's center (wobble)
		bounce: 0.5, //How much speed it keeps bouncing off the pond's sides (1 = all of it)
		phase: random(360), //Wobble and flapping: where it is in its back-and-forth
		orbit_angle: random(360), //Orbit: where it is around the middle
		golf_state: 0, //Golf: 0 sinking, 1 sitting on the bottom, 2 flying
		golf_timer: 0,
		mode: 0, //Charge, fake-out, grid hop, hole hop: which step of its pattern it's on
		mode_timer: 0,
		mode_x: start_x, //Fake-out: where it started from.  Grid hop: where it's hopping to
		mode_y: start_y,
		scale: 1, //Drawn size (hole hop shrinks into its hole)
		hidden: false, //Hole hop: underground.  Can't be caught, and the bar holds still
		paddle_left_y: start_y, //Pong: paddle positions
		paddle_right_y: start_y,
		setup: false, //Set true by swim functions that need to do something on their first step
		no_walls: false, //Bowling: lets it roll out through the top of the pond
		pins: [], //Bowling: the rack of pins
		rolls: 0, //Bowling: rolls since the pins were last set up
		flip_y: 1, //-1 draws the fish upside down (float up)
		manual_frame: false, //True when the swim function picks the animation frame itself (grow), so Step doesn't animate it
		hook_state: 0, //Hooked: 0 waiting, 1 casting, 2 hooked the circle, 3 reeling the line back in
		hook_timer: 0,
		hook_anchor_x: 0, //Hooked: where the line comes in from, on an edge of the pond
		hook_anchor_y: 0,
		hook_x: 0, //Hooked: where the hook is
		hook_y: 0,
		hook_target_x: 0, //Hooked: where the cast is aimed
		hook_target_y: 0,
		face_lock: 0 //0 = face the way it's moving.  1 or -1 = always face right or left (wall jump clings to a wall)
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
	//Starts in the middle, so drop to the bottom first
	var bottom_y = box_y + box_size - sprite_get_height(fish.sprite)/2
	if fish.y<bottom_y-1
	{
		fish.vx = approach_speed(fish.vx, 0, fish.accel, fish.decel)
		fish.vy = approach_speed(fish.vy, fish.max_speed, fish.accel, fish.decel)
		return;
	}
	var want_vx = clamp((fish.goal_x-fish.x)*0.1, -fish.max_speed, fish.max_speed)
	fish.vx = approach_speed(fish.vx, want_vx, fish.accel, fish.decel)
	fish.vy = 0
	fish.y = bottom_y
}

/// Float up: rises to the top of the pond and stays there
swim_float_up = function(fish)
{
	var top_y = box_y + sprite_get_height(fish.sprite)/2
	var want_vy = clamp((top_y-fish.y)*0.1, -fish.max_speed, 0)
	fish.vy = approach_speed(fish.vy, want_vy, fish.accel, fish.decel)
	fish.vx = approach_speed(fish.vx, 0, fish.accel, fish.decel)
	fish.flip_y = -1 //Belly up
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

wobble_angle = 20 //Wobble: how far it rocks either way, in degrees
wobble_speed = 40 //Wobble: degrees through its rock per step (higher = faster rocking)

/// Wobble: moves constantly, rocking back and forth in rapid mini rotations
swim_wobble = function(fish)
{
	swim_constant(fish)
	fish.phase += wobble_speed
	fish.angle = dsin(fish.phase)*wobble_angle
}

fly_height_min = 30 //Fly: cruising height range, measured down from the top of the pond
fly_height_max = 90
fly_flap = 18 //Fly: how far it bobs up and down while flapping
fly_flap_speed = 8 //Fly: degrees through its flap per step

/// Fly: glides back and forth across the top of the pond like a bird, bobbing as it flaps.
/// Turns around near each side and picks a new cruising height
swim_fly_top = function(fish)
{
	var margin = 40
	if (fish.zig_dir<0 and fish.x<=box_x+margin) or (fish.zig_dir>0 and fish.x>=box_x+box_size-margin)
	{
		fish.zig_dir *= -1
		fish.goal_y = box_y + random_range(fly_height_min, fly_height_max)
	}
	//goal_y starts in the middle of the pond, so the first trip also flies it up to the top
	if fish.goal_y>box_y+fly_height_max
		fish.goal_y = box_y + random_range(fly_height_min, fly_height_max)
	fish.vx = approach_speed(fish.vx, fish.zig_dir*fish.max_speed, fish.accel, fish.decel)

	fish.phase += fly_flap_speed
	var cruise_y = fish.goal_y + dsin(fish.phase)*fly_flap
	var want_vy = clamp((cruise_y-fish.y)*0.2, -fish.max_speed, fish.max_speed)
	fish.vy = approach_speed(fish.vy, want_vy, fish.accel, fish.decel)
}

orbit_radius = 110 //Orbit: how far from the middle it circles

/// Orbit: circles the middle of the pond.  Starts in the middle and spirals out to its circle
swim_orbit = function(fish)
{
	//Move the spot on the circle along at the fish's top speed
	fish.orbit_angle += fish.zig_dir * fish.max_speed/orbit_radius * 180/pi
	var center_x = box_x + box_size/2
	var center_y = box_y + box_size/2
	var spot_x = center_x + lengthdir_x(orbit_radius, fish.orbit_angle)
	var spot_y = center_y + lengthdir_y(orbit_radius, fish.orbit_angle)

	//Swim along the circle, pulled toward the spot so it doesn't drift off it
	var along = fish.orbit_angle + 90*fish.zig_dir
	var want_vx = lengthdir_x(fish.max_speed, along) + (spot_x-fish.x)*0.15
	var want_vy = lengthdir_y(fish.max_speed, along) + (spot_y-fish.y)*0.15
	//Don't rush out of the middle faster than 1.5x top speed
	var want_speed = point_distance(0, 0, want_vx, want_vy)
	var speed_cap = fish.max_speed*1.5
	if want_speed>speed_cap
	{
		want_vx *= speed_cap/want_speed
		want_vy *= speed_cap/want_speed
	}
	fish.vx = approach_speed(fish.vx, want_vx, fish.accel, fish.decel)
	fish.vy = approach_speed(fish.vy, want_vy, fish.accel, fish.decel)
}

golf_gravity = 0.15 //Golf: how fast it falls back down after a shot
golf_launch = 3 //Golf: shot speed, as a multiple of max_speed
golf_bounce = 0.9 //Golf: speed kept bouncing off the sides while flying

/// Golf: sinks to the bottom, sits for a moment, then shoots up at an angle and bounces off the walls
swim_golf = function(fish)
{
	var bottom_y = box_y + box_size - sprite_get_height(fish.sprite)/2
	switch(fish.golf_state)
	{
		case 0: //Sinking to the bottom
			fish.bounce = 0.5
			fish.vx = approach_speed(fish.vx, 0, fish.accel, fish.decel)
			fish.vy = approach_speed(fish.vy, fish.max_speed*0.5, fish.accel, fish.decel)
			if fish.y>=bottom_y-1
			{
				fish.golf_state = 1
				fish.golf_timer = irandom_range(40, 90)
			}
			break

		case 1: //Sitting on the bottom, waiting for the shot
			fish.vx = approach_speed(fish.vx, 0, fish.accel, fish.decel)
			fish.vy = 0
			fish.y = bottom_y
			fish.golf_timer--
			if fish.golf_timer<=0
			{
				//Fore!  Shoot up at an angle
				var shot_dir = random_range(55, 125)
				var shot_speed = fish.max_speed*golf_launch
				fish.vx = lengthdir_x(shot_speed, shot_dir)
				fish.vy = lengthdir_y(shot_speed, shot_dir)
				fish.golf_state = 2
				fish.golf_timer = irandom_range(120, 200) //Flight time before it settles down again
				fish.bounce = golf_bounce
			}
			break

		case 2: //Flying: falls under gravity and bounces hard off the walls (the bounce happens in Step)
			fish.vy += golf_gravity
			fish.golf_timer--
			if fish.golf_timer<=0
				fish.golf_state = 0
			break
	}
}

flee_range = 150 //Flee: how close the circle can get before it runs

/// Flee: runs away from the circle when it gets close, otherwise wanders slowly
swim_flee = function(fish)
{
	if point_distance(circle_x, circle_y, fish.x, fish.y)>flee_range
	{
		//Calm: wander at half speed
		fish.goal_timer--
		if fish.goal_timer<=0 or point_distance(fish.x, fish.y, fish.goal_x, fish.goal_y)<10
		{
			pick_goal(fish)
			fish.goal_timer = irandom_range(60, 120)
		}
		swim_toward_goal(fish, fish.max_speed*0.5)
		return;
	}
	//Run straight away from the circle, leaning a little toward the middle so it doesn't just hide in a corner
	var away = point_direction(circle_x, circle_y, fish.x, fish.y)
	var want_vx = lengthdir_x(fish.max_speed, away) + (box_x+box_size/2-fish.x)*0.01
	var want_vy = lengthdir_y(fish.max_speed, away) + (box_y+box_size/2-fish.y)*0.01
	fish.vx = approach_speed(fish.vx, want_vx, fish.accel, fish.decel)
	fish.vy = approach_speed(fish.vy, want_vy, fish.accel, fish.decel)
}

charge_speed = 2.5 //Charge: rush speed, as a multiple of max_speed
charge_time = 40 //Charge: steps it keeps going in a straight line (long enough to overshoot the circle)

/// Charge: slows down and sizes up the circle, then rushes straight at it and overshoots right through it
swim_charge = function(fish)
{
	if !fish.setup
	{
		fish.setup = true
		fish.mode_timer = irandom_range(40, 90)
	}
	fish.mode_timer--
	if fish.mode=0
	{
		//Sizing up the circle
		fish.vx = approach_speed(fish.vx, 0, fish.accel, fish.decel)
		fish.vy = approach_speed(fish.vy, 0, fish.accel, fish.decel)
		if fish.mode_timer<=0
		{
			var dir = point_direction(fish.x, fish.y, circle_x, circle_y)
			fish.vx = lengthdir_x(fish.max_speed*charge_speed, dir)
			fish.vy = lengthdir_y(fish.max_speed*charge_speed, dir)
			fish.mode = 1
			fish.mode_timer = charge_time
		}
	}
	else if fish.mode_timer<=0
	{
		//Charge over.  No steering during it, so it went straight through
		fish.mode = 0
		fish.mode_timer = irandom_range(40, 90)
	}
}

fake_out_chance = 0.6 //Fake-out: chance each trip is a fake

/// Fake-out: heads for a spot, and most of the time stops halfway and doubles back to where it started
swim_fake_out = function(fish)
{
	//Brief stop at the turnaround
	if fish.wait_timer>0
	{
		fish.wait_timer--
		fish.vx = approach_speed(fish.vx, 0, fish.accel, fish.decel)
		fish.vy = approach_speed(fish.vy, 0, fish.accel, fish.decel)
		return;
	}
	//New trip.  mode 2 = this trip is a fake, mode 1 = it's for real
	if fish.mode=0 or point_distance(fish.x, fish.y, fish.goal_x, fish.goal_y)<10
	{
		fish.mode_x = fish.x
		fish.mode_y = fish.y
		pick_goal(fish)
		fish.mode = (random(1)<fake_out_chance) ? 2 : 1
	}
	//Halfway on a fake: stop and head back
	var trip_length = point_distance(fish.mode_x, fish.mode_y, fish.goal_x, fish.goal_y)
	if fish.mode=2 and point_distance(fish.mode_x, fish.mode_y, fish.x, fish.y)>=trip_length/2
	{
		fish.goal_x = fish.mode_x
		fish.goal_y = fish.mode_y
		fish.mode = 1
		fish.wait_timer = 12
	}
	swim_toward_goal(fish, fish.max_speed)
}

grid_hop_size = 32 //Grid hop: one grid space, same as the game board

/// Grid hop: sits, then hops 1-3 grid spaces straight or diagonally, like a slime on the game board
swim_grid_hop = function(fish)
{
	if fish.mode=0
	{
		//Sitting between hops
		fish.vx = 0
		fish.vy = 0
		fish.scale = 1
		fish.mode_timer--
		if fish.mode_timer>0
			return;
		//Line up with the grid, then pick a direction and distance that stays in the pond
		var half_space = grid_hop_size/2
		var from_x = box_x + half_space + round((fish.x-box_x-half_space)/grid_hop_size)*grid_hop_size
		var from_y = box_y + half_space + round((fish.y-box_y-half_space)/grid_hop_size)*grid_hop_size
		repeat(20)
		{
			var dir_x = irandom_range(-1, 1)
			var dir_y = irandom_range(-1, 1)
			if dir_x=0 and dir_y=0
				continue
			var spaces = irandom_range(1, 3)
			var to_x = from_x + dir_x*spaces*grid_hop_size
			var to_y = from_y + dir_y*spaces*grid_hop_size
			if to_x>box_x+half_space and to_x<box_x+box_size-half_space and to_y>box_y+half_space and to_y<box_y+box_size-half_space
			{
				fish.mode_x = to_x
				fish.mode_y = to_y
				fish.mode = 1
				break
			}
		}
		return;
	}
	//Hopping: a quick straight move to the new space, puffed up a little like it's in the air
	var hop_speed = fish.max_speed*1.5
	fish.scale = 1.2
	if point_distance(fish.x, fish.y, fish.mode_x, fish.mode_y)<=hop_speed
	{
		fish.x = fish.mode_x
		fish.y = fish.mode_y
		fish.vx = 0
		fish.vy = 0
		fish.mode = 0
		fish.mode_timer = irandom_range(20, 45)
		return;
	}
	var dir = point_direction(fish.x, fish.y, fish.mode_x, fish.mode_y)
	fish.vx = lengthdir_x(hop_speed, dir)
	fish.vy = lengthdir_y(hop_speed, dir)
}

hole_shrink_steps = 20 //Hole hop: steps to dive in or pop out

/// Hole hop: swims for a while, shrinks down into a hole, hides underground, then pops out of a new hole somewhere else.
/// The new hole shows up while it's hidden, so the player can get there first
swim_hole_hop = function(fish)
{
	if !fish.setup
	{
		fish.setup = true
		fish.mode_timer = irandom_range(120, 200)
	}
	fish.mode_timer--
	switch(fish.mode)
	{
		case 0: //Swimming around
			swim_constant(fish)
			if fish.mode_timer<=0
			{
				fish.mode = 1
				fish.mode_timer = hole_shrink_steps
			}
			break

		case 1: //Diving into the hole
			fish.vx = approach_speed(fish.vx, 0, fish.accel, fish.decel)
			fish.vy = approach_speed(fish.vy, 0, fish.accel, fish.decel)
			fish.scale = max(0, fish.mode_timer/hole_shrink_steps)
			if fish.mode_timer<=0
			{
				//Underground.  Move to where it'll pop out
				fish.hidden = true
				pick_goal(fish)
				fish.x = fish.goal_x
				fish.y = fish.goal_y
				fish.vx = 0
				fish.vy = 0
				fish.mode = 2
				fish.mode_timer = irandom_range(40, 80)
			}
			break

		case 2: //Hidden
			if fish.mode_timer<=0
			{
				fish.hidden = false
				fish.mode = 3
				fish.mode_timer = hole_shrink_steps
			}
			break

		case 3: //Popping out
			fish.scale = 1 - max(0, fish.mode_timer/hole_shrink_steps)
			if fish.mode_timer<=0
			{
				fish.scale = 1
				fish.mode = 0
				fish.mode_timer = irandom_range(120, 200)
			}
			break
	}
}

mirror_safe_radius = 70 //Mirror: if the circle sits this close to the middle, the fish slips away instead

/// Mirror: swims to the opposite side of the pond from the circle.
/// The middle mirrors onto itself, so if the circle camps there the fish slips out to the side away from it
swim_mirror = function(fish)
{
	var center_x = box_x + box_size/2
	var center_y = box_y + box_size/2
	var target_x = center_x - (circle_x-center_x)
	var target_y = center_y - (circle_y-center_y)
	if point_distance(circle_x, circle_y, center_x, center_y)<mirror_safe_radius
	{
		var away = point_direction(circle_x, circle_y, fish.x, fish.y)
		target_x = center_x + lengthdir_x(box_size*0.35, away)
		target_y = center_y + lengthdir_y(box_size*0.35, away)
	}
	var want_vx = clamp((target_x-fish.x)*0.1, -fish.max_speed, fish.max_speed)
	var want_vy = clamp((target_y-fish.y)*0.1, -fish.max_speed, fish.max_speed)
	fish.vx = approach_speed(fish.vx, want_vx, fish.accel, fish.decel)
	fish.vy = approach_speed(fish.vy, want_vy, fish.accel, fish.decel)
}

wind_push = 0.5 //Wind: pixels per step a full gust pushes the circle (only while the circle isn't moving left or right)

/// Wind: swims like dash and wait.  Every so often a gust blows left or right across the pond.
/// wind_amount goes from -1 (full gust left) to 1 (full gust right).  Step uses it to nudge the circle
swim_wind = function(fish)
{
	swim_dash_wait(fish)
	if !fish.setup
	{
		fish.setup = true
		fish.mode_timer = irandom_range(90, 150)
	}
	fish.mode_timer--
	if fish.mode=0
	{
		//Calm: any gust dies down
		wind_amount = lerp(wind_amount, 0, 0.05)
		if fish.mode_timer<=0
		{
			fish.mode = 1
			fish.mode_timer = irandom_range(60, 100)
			fish.mode_x = choose(-1, 1) //Gust direction: left or right
		}
	}
	else
	{
		//Gust: builds up
		wind_amount = lerp(wind_amount, fish.mode_x, 0.05)
		if fish.mode_timer<=0
		{
			fish.mode = 0
			fish.mode_timer = irandom_range(150, 250)
		}
	}
}

paddle_width = 8 //Pong: paddle size
paddle_height = 60
paddle_inset = 16 //Pong: gap between each paddle and its side of the pond
paddle_follow = 0.8 //Pong: paddle speed as a fraction of the fish's.  Below 1 so a steep shot can slip past
pong_max_angle = 55 //Pong: steepest bounce off the end of a paddle, in degrees
pong_min_angle = 15 //Pong: every bounce slopes at least this much, so it never comes back dead flat
pong_spin = 15 //Pong: random extra angle on each hit

/// Pong: the fish is the ball.  It keeps a steady speed, bounces off the top and bottom, and two paddles
/// knock it back and forth.  Each paddle aims to hit with a random spot along its length (not the middle),
/// and hitting near the end of a paddle sends the fish off at a steeper angle
swim_pong = function(fish)
{
	fish.bounce = 1
	if !fish.setup
	{
		fish.setup = true
		var serve = choose(random_range(-40, 40), random_range(140, 220)) //Left or right
		fish.vx = lengthdir_x(fish.max_speed, serve)
		fish.vy = lengthdir_y(fish.max_speed, serve)
		fish.mode_x = pong_pick_aim() //Where each paddle means to hit it (offset from the paddle's middle)
		fish.mode_y = pong_pick_aim()
	}
	
	//Paddles slide so their aim spot meets the ball when it's coming their way, and back to the middle when it's leaving
	var center_y = box_y + box_size/2
	var paddle_speed = fish.max_speed*paddle_follow
	var left_target = (fish.vx<0) ? fish.y-fish.mode_x : center_y
	var right_target = (fish.vx>0) ? fish.y-fish.mode_y : center_y
	fish.paddle_left_y += clamp(left_target-fish.paddle_left_y, -paddle_speed, paddle_speed)
	fish.paddle_right_y += clamp(right_target-fish.paddle_right_y, -paddle_speed, paddle_speed)
	fish.paddle_left_y = clamp(fish.paddle_left_y, box_y+paddle_height/2, box_y+box_size-paddle_height/2)
	fish.paddle_right_y = clamp(fish.paddle_right_y, box_y+paddle_height/2, box_y+box_size-paddle_height/2)
	
	//Hit a paddle?
	var half_fish = sprite_get_width(fish.sprite)/2
	var left_face = box_x + paddle_inset + paddle_width
	var right_face = box_x + box_size - paddle_inset - paddle_width
	if fish.vx<0 and fish.x-half_fish<=left_face and fish.x>box_x+paddle_inset
		and abs(fish.y-fish.paddle_left_y)<=paddle_height/2+half_fish
	{
		pong_hit(fish, 1, fish.paddle_left_y)
		fish.mode_x = pong_pick_aim()
	}
	if fish.vx>0 and fish.x+half_fish>=right_face and fish.x<box_x+box_size-paddle_inset
		and abs(fish.y-fish.paddle_right_y)<=paddle_height/2+half_fish
	{
		pong_hit(fish, -1, fish.paddle_right_y)
		fish.mode_y = pong_pick_aim()
	}
	
	//Steady speed, like a Pong ball
	var current_speed = point_distance(0, 0, fish.vx, fish.vy)
	if current_speed>0
	{
		fish.vx *= fish.max_speed/current_speed
		fish.vy *= fish.max_speed/current_speed
	}
}

/// Pong: a random spot along the paddle to hit the ball with, toward one end or the other (never dead center)
pong_pick_aim = function()
{
	return choose(-1, 1) * random_range(0.3, 0.9) * paddle_height/2
}

/// Pong: knocks the fish back the other way.  out_x is 1 to send it right, -1 to send it left
pong_hit = function(fish, out_x, paddle_y)
{
	var offset = clamp((fish.y-paddle_y)/(paddle_height/2), -1, 1) //-1 top end, 1 bottom end
	var slope = offset*pong_max_angle + random_range(-pong_spin, pong_spin)
	//Never flat: push small slopes out to the minimum
	if abs(slope)<pong_min_angle
		slope = (slope<0 ? -1 : 1)*pong_min_angle
	slope = clamp(slope, -pong_max_angle, pong_max_angle)
	var out_dir = (out_x>0) ? -slope : 180+slope
	fish.vx = lengthdir_x(fish.max_speed, out_dir)
	fish.vy = lengthdir_y(fish.max_speed, out_dir)
}

/// Stick to circle: chases the middle of the player's circle.  This fish is caught backwards:
/// the bar fills while it's OUTSIDE the circle, so the player has to outrun it (see Step)
swim_stick_to_circle = function(fish)
{
	var want_vx = clamp((circle_x-fish.x)*0.1, -fish.max_speed, fish.max_speed)
	var want_vy = clamp((circle_y-fish.y)*0.1, -fish.max_speed, fish.max_speed)
	fish.vx = approach_speed(fish.vx, want_vx, fish.accel, fish.decel)
	fish.vy = approach_speed(fish.vy, want_vy, fish.accel, fish.decel)
}

bowling_pin_gap = 14 //Bowling: space between pins in a row
bowling_row_gap = 16 //Bowling: space between rows of pins
bowling_pins_top = 34 //Bowling: how far the back row of pins is from the top of the pond
bowling_lane = 40 //Bowling: how far above the bottom of the pond it lines up its shot
bowling_roll_speed = 2 //Bowling: roll speed, as a multiple of max_speed
bowling_aim_error = 25 //Bowling: how far off the middle of the rack a shot can be aimed (pixels)
bowling_hit_radius = 14 //Bowling: how close the ball (or a flying pin) gets to a pin to knock it over
bowling_rolls_per_frame = 2 //Bowling: rolls before the pins are set back up (or sooner after a strike)

/// Bowling: sets up a fresh rack of 10 pins in a triangle near the top.  Back row of 4 at the top, head pin at the bottom
bowling_rack = function(fish)
{
	fish.pins = []
	fish.rolls = 0
	var center_x = box_x + box_size/2
	for (var row = 0; row < 4; row++)
	{
		var count = 4-row
		for (var i = 0; i < count; i++)
		{
			array_push(fish.pins, {
				x: center_x + (i-(count-1)/2)*bowling_pin_gap, //Center of the pin
				y: box_y + bowling_pins_top + row*bowling_row_gap,
				vx: 0,
				vy: 0,
				angle: 0,
				spin: 0,
				alpha: 1,
				standing: true
			})
		}
	}
}

/// Bowling: knocks a pin over, sending it flying away from whatever hit it (the ball or another pin)
bowling_knock = function(pin, hit_x, hit_y, push_x, push_y)
{
	pin.standing = false
	pin.vx = push_x*0.6 + (pin.x-hit_x)*0.25 + random_range(-0.5, 0.5)
	pin.vy = push_y*0.6 + (pin.y-hit_y)*0.25 + random_range(-0.5, 0)
	pin.spin = random_range(-20, 20)
	bowling_clatter = true
}

/// Bowling: knocked pins fly, spin and fade.  A flying pin can knock over the pins it runs into
bowling_update_pins = function(fish)
{
	bowling_clatter = false
	for (var i = 0; i < array_length(fish.pins); i++)
	{
		var pin = fish.pins[i]
		if pin.standing or pin.alpha<=0
			continue
		pin.x += pin.vx
		pin.y += pin.vy
		pin.vx *= 0.95
		pin.vy *= 0.95
		pin.angle += pin.spin
		pin.spin *= 0.97
		pin.alpha -= 1/60
		//Knock over neighbors while it's still moving fast
		if point_distance(0, 0, pin.vx, pin.vy)>1
		{
			for (var j = 0; j < array_length(fish.pins); j++)
			{
				var other_pin = fish.pins[j]
				if other_pin.standing and point_distance(pin.x, pin.y, other_pin.x, other_pin.y)<bowling_hit_radius*0.7
					bowling_knock(other_pin, pin.x, pin.y, pin.vx, pin.vy)
			}
		}
	}
}

/// Bowling: comes down to the bottom, lines up a shot, rolls up through the pins and off the top of the pond.
/// While it's gone the bar holds still.  Then it comes back at the bottom for another roll
swim_bowling = function(fish)
{
	var half_fish = sprite_get_width(fish.sprite)/2
	var lane_y = box_y + box_size - bowling_lane
	if !fish.setup
	{
		fish.setup = true
		bowling_rack(fish)
		fish.goal_x = box_x + box_size/2 + random_range(-60, 60)
		fish.goal_y = lane_y
	}
	bowling_update_pins(fish)
	
	switch(fish.mode)
	{
		case 0: //Heading down to the lane at the bottom
			fish.no_walls = false
			fish.goal_y = lane_y
			swim_toward_goal(fish, fish.max_speed)
			if point_distance(fish.x, fish.y, fish.goal_x, fish.goal_y)<4
			{
				fish.mode = 1
				fish.mode_timer = irandom_range(40, 80)
			}
			break
			
		case 1: //Lining up the shot
			fish.vx = approach_speed(fish.vx, 0, fish.accel, fish.decel)
			fish.vy = approach_speed(fish.vy, 0, fish.accel, fish.decel)
			fish.mode_timer--
			if fish.mode_timer<=0
			{
				//Bowl!  Aim at the rack (give or take), straight up and out the top
				var roll_speed = fish.max_speed*bowling_roll_speed
				var aim_x = box_x + box_size/2 + random_range(-bowling_aim_error, bowling_aim_error)
				var steps_to_pins = max(1, (fish.y-(box_y+bowling_pins_top))/roll_speed)
				fish.vx = (aim_x-fish.x)/steps_to_pins
				fish.vy = -roll_speed
				fish.no_walls = true
				fish.mode = 2
			}
			break
			
		case 2: //Rolling: keeps its speed, knocks over any pins it hits, then rolls off the top
			for (var i = 0; i < array_length(fish.pins); i++)
			{
				var pin = fish.pins[i]
				if pin.standing and point_distance(fish.x, fish.y, pin.x, pin.y)<bowling_hit_radius
					bowling_knock(pin, fish.x, fish.y, fish.vx, fish.vy)
			}
			if fish.y<box_y-half_fish
			{
				fish.hidden = true
				fish.vx = 0
				fish.vy = 0
				fish.mode = 3
				fish.mode_timer = irandom_range(40, 70)
				fish.rolls++
			}
			break
			
		case 3: //Off the top of the pond.  The bar holds still
			fish.mode_timer--
			if fish.mode_timer<=0
			{
				//New frame after enough rolls, or right away after a strike
				var any_standing = false
				for (var p = 0; p < array_length(fish.pins); p++)
					if fish.pins[p].standing
						any_standing = true
				if fish.rolls>=bowling_rolls_per_frame or !any_standing
					bowling_rack(fish)
				
				//Back at the bottom for the next roll
				fish.hidden = false
				fish.no_walls = false
				fish.x = box_x + box_size/2 + random_range(-80, 80)
				fish.y = lane_y
				fish.mode = 1
				fish.mode_timer = irandom_range(40, 80)
			}
			break
	}
	
	if bowling_clatter
	{
		var snd = audio_play_sound(snd_bonk, 1, false)
		audio_sound_pitch(snd, random_range(1.4, 1.8))
		audio_sound_gain(snd, 0.5, 0)
	}
}
bowling_clatter = false //Set when a pin gets knocked over this step, so the clatter sound plays once

grow_fat_scale = 2 //Grow: drawn size when fat
grow_fat_speed = 0.5 //Grow: speed and acceleration multiplier when fat
grow_hold_min = 120 //Grow: steps it stays tiny or fat before switching
grow_hold_max = 240

/// Grow: switches between tiny and fat.  Holds the sprite's tiny frame (2) or fat frame (0), and plays
/// frames 0-2 to shrink or 3-5 to grow.  Fat is drawn twice as big and swims at half speed and acceleration
swim_grow = function(fish)
{
	fish.manual_frame = true
	if !fish.setup
	{
		fish.setup = true
		fish.mode = choose(0, 2) //Start tiny or fat
		fish.mode_timer = irandom_range(grow_hold_min, grow_hold_max)
	}
	var frame_step = sprite_get_speed(fish.sprite)/game_get_speed(gamespeed_fps)
	var fatness = 0 //0 tiny, 1 fat
	switch(fish.mode)
	{
		case 0: //Tiny
			fish.frame = 2
			fatness = 0
			fish.mode_timer--
			if fish.mode_timer<=0
			{
				fish.mode = 1
				fish.frame = 3
			}
			break
			
		case 1: //Growing: frames 3 to 5
			fish.frame += frame_step
			fatness = clamp((fish.frame-3)/3, 0, 1)
			if fish.frame>=6
			{
				fish.mode = 2
				fish.mode_timer = irandom_range(grow_hold_min, grow_hold_max)
			}
			break
			
		case 2: //Fat
			fish.frame = 0
			fatness = 1
			fish.mode_timer--
			if fish.mode_timer<=0
				fish.mode = 3
			break
			
		case 3: //Shrinking: frames 0 to 2
			fish.frame += frame_step
			fatness = 1 - clamp(fish.frame/3, 0, 1)
			if fish.frame>=3
			{
				fish.mode = 0
				fish.mode_timer = irandom_range(grow_hold_min, grow_hold_max)
			}
			break
	}
	fish.scale = lerp(1, grow_fat_scale, fatness)
	
	//Swims like moving constantly, but slower and lazier the fatter it is
	var speed_mult = lerp(1, grow_fat_speed, fatness)
	fish.goal_timer--
	if fish.goal_timer<=0 or point_distance(fish.x, fish.y, fish.goal_x, fish.goal_y)<10
	{
		pick_goal(fish)
		fish.goal_timer = irandom_range(30, 90)
	}
	var dir = point_direction(fish.x, fish.y, fish.goal_x, fish.goal_y)
	var want_speed = min(fish.max_speed*speed_mult, point_distance(fish.x, fish.y, fish.goal_x, fish.goal_y)*0.1)
	fish.vx = approach_speed(fish.vx, lengthdir_x(want_speed, dir), fish.accel*speed_mult, fish.decel*speed_mult)
	fish.vy = approach_speed(fish.vy, lengthdir_y(want_speed, dir), fish.accel*speed_mult, fish.decel*speed_mult)
}

wrap_turn = 4 //Wrap: how much its heading can wander each step, in degrees

/// Wrap: swims along a slowly wandering heading at full speed.  No walls: when its middle goes past one side
/// of the pond it comes back in from the opposite side.  Draw shows a second copy near the edges so it slides across
swim_wrap = function(fish)
{
	fish.no_walls = true
	if !fish.setup
	{
		fish.setup = true
		fish.orbit_angle = random(360) //Heading
	}
	fish.orbit_angle += random_range(-wrap_turn, wrap_turn)
	fish.vx = approach_speed(fish.vx, lengthdir_x(fish.max_speed, fish.orbit_angle), fish.accel, fish.decel)
	fish.vy = approach_speed(fish.vy, lengthdir_y(fish.max_speed, fish.orbit_angle), fish.accel, fish.decel)
	
	//Wrap around (the move happens in Step, so check where it's about to be)
	var next_x = fish.x + fish.vx
	var next_y = fish.y + fish.vy
	if next_x<box_x
		fish.x += box_size
	else if next_x>=box_x+box_size
		fish.x -= box_size
	if next_y<box_y
		fish.y += box_size
	else if next_y>=box_y+box_size
		fish.y -= box_size
}

hook_wait_min = 50 //Hooked: steps between casts
hook_wait_max = 100
hook_cast_speed = 6 //Hooked: how fast the hook flies out
hook_reel_speed = 8 //Hooked: how fast the line reels back in
hook_catch = 0.8 //Hooked: how close to the middle of the circle the hook has to get to catch it (fraction of the circle's radius)
hook_hold_min = 90 //Hooked: steps it holds on to the circle
hook_hold_max = 150
hook_pull = 2.2 //Hooked: pixels per step the line drags the circle toward its edge (the circle tops out at 4)
hook_tug = 1.5 //Hooked: random jerks on the line while it's hooked

/// Hooked: swims around normally.  Every so often a fishing line comes in from a random spot on a random edge and
/// casts its hook at the circle.  If the hook gets to the middle of the circle, the line drags the circle toward
/// its edge with random tugs, and the circle only gets half its usual acceleration until the line lets go
swim_hooked = function(fish)
{
	swim_constant(fish)
	hook_pull_x = 0
	hook_pull_y = 0
	circle_hooked = false
	if !fish.setup
	{
		fish.setup = true
		fish.hook_timer = irandom_range(hook_wait_min, hook_wait_max)
	}
	
	switch(fish.hook_state)
	{
		case 0: //Waiting for the next cast
			fish.hook_timer--
			if fish.hook_timer<=0
			{
				//Line comes in from a random spot on a random edge
				switch(irandom(3))
				{
					case 0: fish.hook_anchor_x = random_range(box_x, box_x+box_size); fish.hook_anchor_y = box_y; break
					case 1: fish.hook_anchor_x = random_range(box_x, box_x+box_size); fish.hook_anchor_y = box_y+box_size; break
					case 2: fish.hook_anchor_x = box_x; fish.hook_anchor_y = random_range(box_y, box_y+box_size); break
					case 3: fish.hook_anchor_x = box_x+box_size; fish.hook_anchor_y = random_range(box_y, box_y+box_size); break
				}
				fish.hook_x = fish.hook_anchor_x
				fish.hook_y = fish.hook_anchor_y
				//Aim at where the circle is right now.  Overshoot a bit so a circle that holds still gets hooked
				var aim_dir = point_direction(fish.hook_x, fish.hook_y, circle_x, circle_y)
				var aim_dist = point_distance(fish.hook_x, fish.hook_y, circle_x, circle_y) + circle_radius
				fish.hook_target_x = fish.hook_x + lengthdir_x(aim_dist, aim_dir)
				fish.hook_target_y = fish.hook_y + lengthdir_y(aim_dist, aim_dir)
				fish.hook_state = 1
				var cast_snd = audio_play_sound(snd_flap, 1, false)
				audio_sound_pitch(cast_snd, 1.3)
			}
			break
			
		case 1: //Casting: the hook flies toward where the circle was
			var cast_dir = point_direction(fish.hook_x, fish.hook_y, fish.hook_target_x, fish.hook_target_y)
			fish.hook_x += lengthdir_x(hook_cast_speed, cast_dir)
			fish.hook_y += lengthdir_y(hook_cast_speed, cast_dir)
			if point_distance(fish.hook_x, fish.hook_y, circle_x, circle_y)<circle_radius*hook_catch
			{
				fish.hook_state = 2
				fish.hook_timer = irandom_range(hook_hold_min, hook_hold_max)
				var hooked_snd = audio_play_sound(snd_boing, 1, false)
				audio_sound_pitch(hooked_snd, 1.4)
			}
			else if point_distance(fish.hook_x, fish.hook_y, fish.hook_target_x, fish.hook_target_y)<=hook_cast_speed
				fish.hook_state = 3 //Missed
			break
			
		case 2: //Hooked: drag the circle toward the edge the line comes from, with random tugs
			fish.hook_x = circle_x
			fish.hook_y = circle_y
			var pull_dir = point_direction(circle_x, circle_y, fish.hook_anchor_x, fish.hook_anchor_y)
			hook_pull_x = lengthdir_x(hook_pull, pull_dir) + random_range(-hook_tug, hook_tug)
			hook_pull_y = lengthdir_y(hook_pull, pull_dir) + random_range(-hook_tug, hook_tug)
			circle_hooked = true
			fish.hook_timer--
			if fish.hook_timer<=0
				fish.hook_state = 3 //Lets go
			break
			
		case 3: //Reeling the line back in to its edge
			var reel_dir = point_direction(fish.hook_x, fish.hook_y, fish.hook_anchor_x, fish.hook_anchor_y)
			fish.hook_x += lengthdir_x(hook_reel_speed, reel_dir)
			fish.hook_y += lengthdir_y(hook_reel_speed, reel_dir)
			if point_distance(fish.hook_x, fish.hook_y, fish.hook_anchor_x, fish.hook_anchor_y)<=hook_reel_speed
			{
				fish.hook_state = 0
				fish.hook_timer = irandom_range(hook_wait_min, hook_wait_max)
			}
			break
	}
}

crowd_count = 50 //Crowd: how many decoy fish
crowd_sprite = Spr_Fish_Gold //Crowd: what the decoys look like.  Spr_Fish_Hold is Spr_Fish_Gold's first frame, without the animation
crowd_hold_speed = 0.4 //Crowd: the real fish's speed and acceleration, as a fraction of its own from scr_fish_data (it barely moves)
crowd_decoy_speed = 2.5 //Crowd: decoy top speed in pixels per step (much faster than the real fish)
crowd_decoy_accel = 0.3 //Crowd: decoy acceleration and deceleration
crowd_circle_size = 0.5 //Crowd: the player's circle radius is multiplied by this for this catch
crowd_message = "Find the still one"

/// Crowd: a Where's Waldo fish.  It hides at a random spot in a crowd of animated decoys that look just like it.
/// The real fish never animates and barely moves while the decoys dart around, so it's the one to track.  Only it can be caught
swim_crowd = function(fish)
{
	fish.manual_frame = true
	fish.frame = 0
	if !fish.setup
	{
		fish.setup = true
		circle_radius *= crowd_circle_size //Smaller circle for this one
		fish.max_speed *= crowd_hold_speed
		fish.accel *= crowd_hold_speed
		fish.decel *= crowd_hold_speed
		
		//Hide somewhere random instead of the middle
		var margin = 20
		fish.x = random_range(box_x+margin, box_x+box_size-margin)
		fish.y = random_range(box_y+margin, box_y+box_size-margin)
		fish.goal_x = fish.x
		fish.goal_y = fish.y
		
		//The decoys: much faster than the real fish, scattered all over, each partway through its animation
		crowd = []
		repeat(crowd_count)
		{
			var decoy = make_fish({ name: "", sprite: crowd_sprite, accel: crowd_decoy_accel, decel: crowd_decoy_accel, max_speed: crowd_decoy_speed, move: FISH_MOVE.CONSTANT })
			decoy.x = random_range(box_x+margin, box_x+box_size-margin)
			decoy.y = random_range(box_y+margin, box_y+box_size-margin)
			decoy.goal_x = decoy.x
			decoy.goal_y = decoy.y
			decoy.frame = random(sprite_get_number(crowd_sprite))
			decoy.facing = choose(-1, 1)
			array_push(crowd, decoy)
		}
		crowd_draw_slot = irandom(crowd_count) //So the real fish isn't always drawn on top
	}
	swim_constant(fish)
	
	//Move the decoys (same swimming as the real fish, just faster)
	var half_decoy = sprite_get_width(crowd_sprite)/2
	var frame_step = sprite_get_speed(crowd_sprite)/game_get_speed(gamespeed_fps)
	for (var i = 0; i < array_length(crowd); i++)
	{
		var decoy = crowd[i]
		swim_constant(decoy)
		decoy.x += decoy.vx
		decoy.y += decoy.vy
		if decoy.x<box_x+half_decoy or decoy.x>box_x+box_size-half_decoy
		{
			decoy.x = clamp(decoy.x, box_x+half_decoy, box_x+box_size-half_decoy)
			decoy.vx *= -0.5
		}
		if decoy.y<box_y+half_decoy or decoy.y>box_y+box_size-half_decoy
		{
			decoy.y = clamp(decoy.y, box_y+half_decoy, box_y+box_size-half_decoy)
			decoy.vy *= -0.5
		}
		if abs(decoy.vx)>0.3
			decoy.facing = sign(decoy.vx)
		decoy.frame += frame_step
	}
}

goat_hop_height = 40 //Wall jump: how far up each hop goes
goat_hop_out = 14 //Wall jump: how far each hop pushes off the wall
goat_hop_steps = 16 //Wall jump: steps per hop
goat_cling_min = 3 //Wall jump: steps it clings to the wall between hops
goat_cling_max = 9
goat_jump_at = 0.7 //Wall jump: how far up the wall (0 bottom, 1 top) it climbs before leaping across
goat_jump_arc = 70 //Wall jump: how high the leap across arcs
goat_jump_steps = 50 //Wall jump: steps the leap across takes

/// Wall jump: swims to the bottom of a side wall, then climbs it in little wall-jump hops (pushing off and landing
/// higher), clinging nose-up between hops.  About 70% of the way up it leaps across to the bottom of the other wall.
///   mode 0 heading to the first wall, 1 clinging, 2 hopping up, 3 leaping across
///   zig_dir is the wall it's on (-1 left, 1 right).  mode_x/mode_y is where the current hop or leap started
swim_wall_jump = function(fish)
{
	var half_fish = sprite_get_width(fish.sprite)/2
	var bottom_y = box_y + box_size - half_fish
	var wall_x = (fish.zig_dir<0) ? box_x+half_fish : box_x+box_size-half_fish
	var target_x = fish.x
	var target_y = fish.y
	
	switch(fish.mode)
	{
		case 0: //Heading to the bottom of a wall (zig_dir starts as a random side)
			fish.goal_x = wall_x
			fish.goal_y = bottom_y
			swim_toward_goal(fish, fish.max_speed)
			if point_distance(fish.x, fish.y, wall_x, bottom_y)<4
			{
				fish.mode = 1
				fish.mode_timer = irandom_range(goat_cling_min, goat_cling_max)
			}
			return;
			
		case 1: //Clinging to the wall, nose up, belly against it
			target_x = wall_x
			fish.mode_timer--
			if fish.mode_timer<=0
			{
				fish.mode_x = fish.x
				fish.mode_y = fish.y
				fish.mode_timer = 0 //Now counts 0 to 1 through the hop or leap
				var climbed = (bottom_y-fish.y)/(box_size-half_fish*2)
				fish.mode = (climbed>=goat_jump_at) ? 3 : 2
			}
			break
			
		case 2: //Hopping up: pushes off the wall in an arc and lands higher up
			fish.mode_timer = min(fish.mode_timer + 1/goat_hop_steps, 1)
			target_x = wall_x - fish.zig_dir*goat_hop_out*sin(fish.mode_timer*pi)
			target_y = fish.mode_y - goat_hop_height*fish.mode_timer
			if fish.mode_timer>=1
			{
				fish.mode = 1
				fish.mode_timer = irandom_range(goat_cling_min, goat_cling_max)
			}
			break
			
		case 3: //Leaping across to the bottom of the other wall
			fish.mode_timer = min(fish.mode_timer + 1/goat_jump_steps, 1)
			var other_wall_x = (fish.zig_dir<0) ? box_x+box_size-half_fish : box_x+half_fish
			target_x = lerp(fish.mode_x, other_wall_x, fish.mode_timer)
			target_y = lerp(fish.mode_y, bottom_y, fish.mode_timer) - sin(fish.mode_timer*pi)*goat_jump_arc
			if fish.mode_timer>=1
			{
				fish.zig_dir *= -1 //Now on the other wall
				fish.mode = 1
				fish.mode_timer = irandom_range(goat_cling_min, goat_cling_max)
			}
			break
	}
	
	//Move exactly to this step's spot (Step adds the speed on)
	fish.vx = target_x - fish.x
	fish.vy = target_y - fish.y
	
	//On the wall: nose up with its belly against the wall.  Leaping: level, facing the way it's flying
	if fish.mode=3
	{
		fish.angle = 0
		fish.face_lock = -fish.zig_dir
	}
	else
	{
		fish.angle = 90*fish.zig_dir
		fish.face_lock = fish.zig_dir
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
		case FISH_MOVE.WOBBLE:            swim_wobble(fish);          break
		case FISH_MOVE.FLY_TOP:           swim_fly_top(fish);         break
		case FISH_MOVE.ORBIT:             swim_orbit(fish);           break
		case FISH_MOVE.GOLF:              swim_golf(fish);            break
		case FISH_MOVE.FLEE:              swim_flee(fish);            break
		case FISH_MOVE.CHARGE:            swim_charge(fish);          break
		case FISH_MOVE.FAKE_OUT:          swim_fake_out(fish);        break
		case FISH_MOVE.GRID_HOP:          swim_grid_hop(fish);        break
		case FISH_MOVE.HOLE_HOP:          swim_hole_hop(fish);        break
		case FISH_MOVE.MIRROR:            swim_mirror(fish);          break
		case FISH_MOVE.WIND:              swim_wind(fish);            break
		case FISH_MOVE.PONG:              swim_pong(fish);            break
		case FISH_MOVE.STICK_TO_CIRCLE:   swim_stick_to_circle(fish); break
		case FISH_MOVE.BOWLING:           swim_bowling(fish);         break
		case FISH_MOVE.GROW:              swim_grow(fish);            break
		case FISH_MOVE.WRAP:              swim_wrap(fish);            break
		case FISH_MOVE.HOOKED:            swim_hooked(fish);          break
		case FISH_MOVE.CROWD:             swim_crowd(fish);           break
		case FISH_MOVE.WALL_JUMP:         swim_wall_jump(fish);       break
	}
}

fish = make_fish(fish_data)
bar_fill = fish_data.start_bar
//The table gives these per second.  The bar changes every step
bar_grow = fish_data.bar_grow/game_get_speed(gamespeed_fps)
bar_shrink = fish_data.bar_shrink/game_get_speed(gamespeed_fps)
