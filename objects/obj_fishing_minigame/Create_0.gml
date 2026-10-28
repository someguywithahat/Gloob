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
bar_grow_mult = 1 //Multiplies bar_grow.  Embers (Scald) in the circle lower it

//---- Player circle: follows the mouse with slow acceleration and deceleration ----
circle_radius = 52
circle_x = box_x + box_size/2
circle_y = box_y + box_size/2
circle_vx = 0
circle_vy = 0
circle_accel = 0.6 //How quickly it speeds up or slows down
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
//Used when the room has no obj_lighting (the anglerfish darkens the pond in any room)
pond_lantern_color = make_colour_rgb(255,215,150)
pond_fish_light_radius = 40
pond_fish_light_strength = 0.9

/// Draws one light onto the pond's light map.  Same as obj_lighting's add_light, but works without one
pond_light = function(lx, ly, radius, color, strength, sprite=spr_effect_glow_harder)
{
	var scale = radius*2 / sprite_get_width(sprite)
	draw_sprite_ext(sprite, 0, round(lx), round(ly), scale, scale, 0, color, strength)
}
circle_light_size = 1.1 //The circle's light, as a multiple of its radius.  spr_effect_glow_harder is solid to about 85% of its size, so 1.1 lines the bright part up with the circle

//---- Ending ----
result = 0 //0 = playing, 1 = caught, -1 = got away
end_timer = 0
end_time = 90 //Steps the result shows before the minigame closes

//---- Starting pause: a moment to get your bearings.  The fish holds still and the bar doesn't change ----
start_pause = 0.5 //Seconds
start_timer = round(start_pause*game_get_speed(gamespeed_fps))


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
		bolt_path: [], //Lightning: the corners of the bolt it's zipping along, as [x, y]
		bolt_index: 0, //Lightning: which corner it's heading for
		alpha: 1, //How see-through it's drawn (shy ghost fades near the circle)
		tint: c_white, //Color it's drawn with (the anglerfish's body is dark)
		spin_x: 1, //Squashes it sideways (0-1), so it looks like it's turning around (ballet pirouettes)
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
				var swing = audio_play_sound(snd_golf, 1, false)
				audio_sound_pitch(swing, random_range(0.95, 1.05))
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

//---- Gift (Marigold) ----
gift_fetch_speed = 1.7 //Rushing off to grab the flower, as a multiple of max_speed
gift_deliver_speed = 0.4 //Bringing it back to the circle, as a multiple of max_speed
gift_fetch_accel = 2 //Extra acceleration while rushing off, so she darts away
gift_give_distance = 10 //How close to the middle of the circle she gets before handing it over
gift_linger = 25 //Steps she hangs around the circle after giving it, before rushing off again
gift_far_tries = 8 //New flowers go at the farthest of this many random spots from the circle
gift_flower_scale = 2 //spr_effect_marigold is tiny (5x11)
gift_flower_anim = 6 //Flower sway, frames per second
gift_heart_life = 50 //Steps a heart floats up before it's gone
gift_heart_rise = 0.6 //Pixels per step
gift_flower_x = 0 //The flower floating in the pond, waiting to be picked
gift_flower_y = 0
gift_flower_grow = 0 //0-1.  Pops in when it appears
gift_flower_frame = 0
gift_carrying = false //True while she has it in her mouth
gift_hearts = [] //{ x, y, life }

/// Puts a new marigold far from the player's circle
gift_spawn_flower = function()
{
	var margin = 24
	var best_dist = -1
	for (var i = 0; i < gift_far_tries; i++)
	{
		var try_x = random_range(box_x+margin, box_x+box_size-margin)
		var try_y = random_range(box_y+margin, box_y+box_size-margin)
		var dist = point_distance(try_x, try_y, circle_x, circle_y)
		if dist>best_dist
		{
			best_dist = dist
			gift_flower_x = try_x
			gift_flower_y = try_y
		}
	}
	gift_flower_grow = 0
}

/// Where the flower sits in her mouth: just in front of her nose
gift_mouth_x = function(fish)
{
	return fish.x + fish.facing*sprite_get_width(fish.sprite)*0.45
}

/// Gift: a marigold pops up far from the circle.  She rushes off to grab it, then slowly swims it over to the
/// middle of the circle.  A heart pops out, and a new marigold appears far away again.
///   mode 0 rushing to the flower, 1 bringing it over, 2 lingering after giving it
swim_gift = function(fish)
{
	if !fish.setup
	{
		fish.setup = true
		gift_spawn_flower()
	}

	//Flower sway and pop-in, hearts floating up
	gift_flower_frame += gift_flower_anim/game_get_speed(gamespeed_fps)
	gift_flower_grow = min(gift_flower_grow + 0.1, 1)
	for (var i = array_length(gift_hearts)-1; i >= 0; i--)
	{
		var heart = gift_hearts[i]
		heart.life--
		heart.y -= gift_heart_rise
		if heart.life<=0
			array_delete(gift_hearts, i, 1)
	}

	switch(fish.mode)
	{
		case 0: //Rushing off to grab the flower
			fish.goal_x = gift_flower_x
			fish.goal_y = gift_flower_y
			var dir = point_direction(fish.x, fish.y, fish.goal_x, fish.goal_y)
			var top = fish.max_speed*gift_fetch_speed
			var rush_accel = fish.accel*gift_fetch_accel
			fish.vx = approach_speed(fish.vx, lengthdir_x(top, dir), rush_accel, rush_accel)
			fish.vy = approach_speed(fish.vy, lengthdir_y(top, dir), rush_accel, rush_accel)
			//Grabs it with her mouth
			if point_distance(gift_mouth_x(fish), fish.y, gift_flower_x, gift_flower_y)<10 or point_distance(fish.x, fish.y, gift_flower_x, gift_flower_y)<8
			{
				gift_carrying = true
				fish.mode = 1
				var chomp = audio_play_sound(snd_pop, 1, false)
				audio_sound_pitch(chomp, 1.4)
				audio_sound_gain(chomp, 0.6, 0)
			}
			break

		case 1: //Slowly bringing it to the middle of the circle (it follows the circle around)
			fish.goal_x = circle_x
			fish.goal_y = circle_y
			swim_toward_goal(fish, fish.max_speed*gift_deliver_speed)
			if point_distance(fish.x, fish.y, circle_x, circle_y)<gift_give_distance
			{
				//Here you go!
				gift_carrying = false
				array_push(gift_hearts, { x: circle_x, y: circle_y - 10, life: gift_heart_life })
				var chime = audio_play_sound(snd_tweet, 1, false)
				audio_sound_pitch(chime, random_range(1.1, 1.3))
				gift_spawn_flower() //Already showing where she'll rush off to next
				fish.mode = 2
				fish.mode_timer = gift_linger
			}
			break

		case 2: //Lingering for a moment after giving it
			fish.vx = approach_speed(fish.vx, 0, fish.accel, fish.decel)
			fish.vy = approach_speed(fish.vy, 0, fish.accel, fish.decel)
			fish.mode_timer--
			if fish.mode_timer<=0
				fish.mode = 0
			break
	}
}

//---- Shy ghost (Soul) ----
ghost_speed = 0.6 //Drifting speed, as a multiple of max_speed
ghost_min_alpha = 0.06 //How visible it is right in the middle of the circle
ghost_fade_start = 0.15 //Starts fading in from this far out from the middle (as a multiple of circle_radius)...
ghost_fade_range = 1.3 //...and is fully visible this much further out (also a multiple of circle_radius)
ghost_fade_speed = 0.08 //How quickly it fades in and out (0-1 per step)
ghost_bob = 0.6 //Up and down float, pixels per step at its fastest
ghost_flicker_min = 70 //Steps between flickers, where it shows itself for a moment
ghost_flicker_max = 160
ghost_flicker_time = 8 //Steps a flicker lasts
ghost_flicker_alpha = 0.55 //How visible it gets during a flicker

/// Shy ghost: drifts slowly from spot to spot, bobbing up and down.  The closer it is to the middle of the
/// player's circle the more it fades away, so you have to keep track of it by feel.  Every so often it flickers into sight.
///   mode_timer counts down to the next flicker, wait_timer is how long the current flicker has left
swim_shy_ghost = function(fish)
{
	if !fish.setup
	{
		fish.setup = true
		fish.mode_timer = irandom_range(ghost_flicker_min, ghost_flicker_max)
	}
	
	//Drifting from spot to spot, floating up and down as it goes
	fish.goal_timer--
	if fish.goal_timer<=0 or point_distance(fish.x, fish.y, fish.goal_x, fish.goal_y)<10
	{
		pick_goal(fish)
		fish.goal_timer = irandom_range(60, 140)
	}
	swim_toward_goal(fish, fish.max_speed*ghost_speed)
	fish.phase += 4
	fish.vy += dsin(fish.phase)*ghost_bob*0.1
	
	//Fades away near the middle of the circle
	var dist = point_distance(fish.x, fish.y, circle_x, circle_y)
	var seen = clamp((dist - circle_radius*ghost_fade_start)/(circle_radius*ghost_fade_range), 0, 1)
	var want_alpha = lerp(ghost_min_alpha, 1, seen)
	
	//Now and then it flickers into sight for a moment
	fish.mode_timer--
	if fish.mode_timer<=0
	{
		fish.wait_timer = ghost_flicker_time
		fish.mode_timer = irandom_range(ghost_flicker_min, ghost_flicker_max)
	}
	if fish.wait_timer>0
	{
		fish.wait_timer--
		want_alpha = max(want_alpha, ghost_flicker_alpha*(0.6 + random(0.4)))
	}
	fish.alpha += clamp(want_alpha-fish.alpha, -ghost_fade_speed, ghost_fade_speed)
}

//---- Lightning (Volt) ----
bolt_speed = 2.2 //Zipping speed, as a multiple of max_speed
bolt_wait_min = 45 //Steps it sits crackling between bolts
bolt_wait_max = 100
bolt_shake_time = 20 //The last this-many steps of the wait it shakes, warning it's about to go
bolt_shake = 5 //How hard it shakes (degrees)
bolt_corners_min = 4 //How many sharp turns in each bolt
bolt_corners_max = 6
bolt_jag = 40 //How far each turn kinks out to the side (pixels)
bolt_min_length = 0.45 //Each bolt goes at least this far (a fraction of the pond's size)
bolt_trail = [] //The glowing trail: { x, y, life }, oldest first
bolt_trail_life = 50 //Steps a bit of trail glows before it's gone
bolt_trail_color = make_colour_rgb(255,240,120)
bolt_trail_light = 18 //Light radius of the trail in dark rooms (the cave)
bolt_flash = 0 //0-1.  Jumps up when a bolt goes off and fades.  Lights up the cave around the pond (obj_lighting)
bolt_flash_fade = 0.04 //Per step
bolt_flash_color = make_colour_rgb(255,245,190)

/// Lays out a new jagged bolt from where the fish is to a spot well across the pond
bolt_plan = function(fish)
{
	var margin = 20
	var start_x = fish.x
	var start_y = fish.y
	var end_x = start_x
	var end_y = start_y
	//Somewhere far enough away to be a proper zap
	for (var tries = 0; tries < 20; tries++)
	{
		end_x = random_range(box_x+margin, box_x+box_size-margin)
		end_y = random_range(box_y+margin, box_y+box_size-margin)
		if point_distance(start_x, start_y, end_x, end_y)>=box_size*bolt_min_length
			break
	}
	//Corners along the way, kinking out to alternate sides like a lightning bolt
	var corners = irandom_range(bolt_corners_min, bolt_corners_max)
	var dir = point_direction(start_x, start_y, end_x, end_y)
	var side = choose(-1, 1)
	fish.bolt_path = []
	for (var i = 1; i < corners; i++)
	{
		var t = i/corners + random_range(-0.05, 0.05)
		var kink = side*random_range(bolt_jag*0.5, bolt_jag)
		var corner_x = lerp(start_x, end_x, t) + lengthdir_x(kink, dir+90)
		var corner_y = lerp(start_y, end_y, t) + lengthdir_y(kink, dir+90)
		array_push(fish.bolt_path, [clamp(corner_x, box_x+margin, box_x+box_size-margin), clamp(corner_y, box_y+margin, box_y+box_size-margin)])
		side = -side
	}
	array_push(fish.bolt_path, [end_x, end_y])
	fish.bolt_index = 0
}

/// Lightning: sits crackling, shakes, then zips to a new spot along a jagged bolt, leaving a glowing trail
/// that fades away.  The trail shows where it's been, never where it's going.  Each bolt flashes the cave.
///   mode 0 sitting, 1 zipping.  mode_timer is how long it has left to sit
swim_lightning = function(fish)
{
	if !fish.setup
	{
		fish.setup = true
		fish.mode_timer = irandom_range(bolt_wait_min, bolt_wait_max)
	}

	//Trail and flash fade
	for (var i = array_length(bolt_trail)-1; i >= 0; i--)
	{
		bolt_trail[i].life--
		if bolt_trail[i].life<=0
			array_delete(bolt_trail, i, 1)
	}
	bolt_flash = max(bolt_flash - bolt_flash_fade, 0)

	if fish.mode=0
	{
		//Sitting.  Shakes just before it goes
		fish.vx = approach_speed(fish.vx, 0, fish.accel, fish.decel)
		fish.vy = approach_speed(fish.vy, 0, fish.accel, fish.decel)
		fish.mode_timer--
		fish.angle = (fish.mode_timer<bolt_shake_time) ? random_range(-bolt_shake, bolt_shake) : 0
		if fish.mode_timer<=0
		{
			bolt_plan(fish)
			fish.mode = 1
			fish.angle = 0
			bolt_flash = 1
			array_push(bolt_trail, { x: fish.x, y: fish.y, life: bolt_trail_life })
			var zap = audio_play_sound(snd_thunder2, 1, false)
			audio_sound_pitch(zap, random_range(1.6, 1.9))
			audio_sound_gain(zap, 0.5, 0)
		}
		return;
	}

	//Zipping from corner to corner at full speed.  Moves exactly onto each corner so the turns are sharp
	var speed_now = fish.max_speed*bolt_speed
	var corner = fish.bolt_path[fish.bolt_index]
	var dist = point_distance(fish.x, fish.y, corner[0], corner[1])
	if dist<=speed_now
	{
		fish.vx = corner[0]-fish.x
		fish.vy = corner[1]-fish.y
		fish.bolt_index++
		if fish.bolt_index>=array_length(fish.bolt_path)
		{
			//Landed
			fish.mode = 0
			fish.mode_timer = irandom_range(bolt_wait_min, bolt_wait_max)
		}
	}
	else
	{
		var dir = point_direction(fish.x, fish.y, corner[0], corner[1])
		fish.vx = lengthdir_x(speed_now, dir)
		fish.vy = lengthdir_y(speed_now, dir)
	}
	//Trail point where it'll be after this step
	array_push(bolt_trail, { x: fish.x+fish.vx, y: fish.y+fish.vy, life: bolt_trail_life })
}

//---- Embers (Scald) ----
embers = [] //{ x, y, vx, vy, life, fade_steps, age, frame }
ember_spacing = 10 //Drops a burst of embers every this many pixels it swims (fire dashes only)
ember_burst = 2 //Embers in each burst
ember_scatter_min = 0.4 //Each ember flies off in a random direction at this speed (pixels per step)...
ember_scatter_max = 1.6
ember_drag = 0.94 //...and slows down like this each step
ember_life = 240 //Steps an ember lasts (4 seconds)
ember_fade = 0.3 //Fades and shrinks over the last this-much of its life
ember_max = 60 //Most embers on the water at once (the oldest goes out first)
ember_slow = 0.15 //Each ember inside the circle takes this much off the bar's fill speed...
ember_min_grow = 0.2 //...but it always fills at least this fast (a fraction of normal)
ember_light = 16 //Light radius of each ember in dark rooms (the cave)
ember_travel = 0 //Pixels swum since the last ember
//Gravity: embers hop up a little when dropped, then slowly sink
ember_gravity = 0.02 //Pixels per step, per step
ember_max_fall = 0.7 //Fastest they sink, pixels per step
ember_pop_min = 0.3 //Little upward hop when dropped, pixels per step
ember_pop_max = 0.9
//Fire dashes: only every few dashes, and they always go a long way
ember_fire_every = 3 //Every this-many dashes is a fire dash
ember_fire_distance = 0.6 //A fire dash goes at least this far (a fraction of the pond's size)
ember_dash_count = 0 //Dashes so far.  The first one is a fire dash
ember_dash_on = false //True while this dash is dropping embers
ember_was_moving = false //Was it dashing last step (to spot when a new dash starts)

/// Embers: dashes and waits like Dash and Wait.  Every few dashes is a long fire dash that sprays glowing embers
/// (Spr_Flame) in all directions, which then slowly sink.  Every ember inside the player's circle makes the bar
/// fill slower, so you're chasing it through its own fire
swim_embers = function(fish)
{
	swim_dash_wait(fish)

	//A new dash starts when the wait ends.  Every few dashes is a fire dash: a long one that sprays embers
	var moving = fish.wait_timer<=0
	if moving and !ember_was_moving
	{
		ember_dash_on = (ember_dash_count mod ember_fire_every)=0
		ember_dash_count++
		ember_travel = 0
		if ember_dash_on
		{
			pick_far_goal(fish, ember_fire_distance)
			var whoosh = audio_play_sound(snd_fireball, 1, false)
			audio_sound_pitch(whoosh, random_range(0.9, 1.1))
		}
	}
	ember_was_moving = moving

	//Drop an ember every so often while moving
	if ember_dash_on
	{
		ember_travel += point_distance(0, 0, fish.vx, fish.vy)
		if ember_travel>=ember_spacing
		{
			ember_travel = 0
			//A little burst, each one flying off in its own direction
			repeat(ember_burst)
			{
				if array_length(embers)>=ember_max
					array_delete(embers, 0, 1)
				var scatter_dir = random(360)
				var scatter_speed = random_range(ember_scatter_min, ember_scatter_max)
				array_push(embers, { x: fish.x + random_range(-3, 3), y: fish.y + random_range(-3, 3),
					vx: lengthdir_x(scatter_speed, scatter_dir), vy: lengthdir_y(scatter_speed, scatter_dir) - random_range(ember_pop_min, ember_pop_max),
					life: ember_life + irandom_range(-30, 30), fade_steps: ember_life*ember_fade, age: 0, frame: random(sprite_get_number(Spr_Flame)) })
			}
		}
	}

	//Embers flicker, scatter, sink and burn out.  Add up how much is burning in the circle
	var in_circle = 0
	var flicker_speed = sprite_get_speed(Spr_Flame)/game_get_speed(gamespeed_fps)
	var pond_bottom = box_y + box_size
	for (var i = array_length(embers)-1; i >= 0; i--)
	{
		var ember = embers[i]
		ember.life--
		ember.age++
		ember.frame += flicker_speed
		//Scatters out, slowing down, while gravity pulls it down
		ember.vx *= ember_drag
		ember.vy = min(ember.vy*ember_drag + ember_gravity, ember_max_fall)
		ember.x += ember.vx
		ember.y += ember.vy
		//Stays in the pond sideways
		if ember.x<box_x or ember.x>box_x+box_size
		{
			ember.x = clamp(ember.x, box_x, box_x+box_size)
			ember.vx = -ember.vx*0.5
		}
		if ember.life<=0 or ember.y>pond_bottom+8
		{
			array_delete(embers, i, 1)
			continue
		}
		if point_distance(ember.x, ember.y, circle_x, circle_y)<=circle_radius
			in_circle += ember_strength(ember) //Slows the bar less as it burns out
	}
	bar_grow_mult = max(1 - in_circle*ember_slow, ember_min_grow)
}

/// Points the fish at a spot far across the pond: at least min_fraction of the pond's size away, if it can find one
pick_far_goal = function(fish, min_fraction)
{
	var best = -1
	var best_x = fish.goal_x
	var best_y = fish.goal_y
	repeat(20)
	{
		pick_goal(fish)
		var dist = point_distance(fish.x, fish.y, fish.goal_x, fish.goal_y)
		if dist>best
		{
			best = dist
			best_x = fish.goal_x
			best_y = fish.goal_y
		}
		if dist>=box_size*min_fraction
			break
	}
	fish.goal_x = best_x
	fish.goal_y = best_y
}

/// How big and bright an ember is right now: 1 most of its life, down to 0 as it burns out
ember_strength = function(ember)
{
	return clamp(ember.life/ember.fade_steps, 0, 1)
}

//---- Whirlpool (Bowl) ----
whirl_radius = 0.36 //Size of the whirlpool, as a fraction of the pond's size
whirl_every_min = 150 //Steps of normal dashing between whirlpools
whirl_every_max = 260
whirl_windup = 45 //Steps it spins in place while the whirlpool opens
whirl_time = 300 //Steps the whirlpool lasts
whirl_winddown = 45 //Steps it takes to calm down again
whirl_spin = 5.6 //How hard the current carries the circle around, pixels per step
whirl_pull = 2.6 //How hard it drags the circle toward the middle, pixels per step
whirl_rim = 0.75 //The fish rides around at this much of the whirlpool's radius
whirl_fish_speed = 3.2 //How fast the fish rides around the rim, pixels per step
whirl_arms = 3 //Spiral arms drawn on the water
whirl_twist = 240 //How far each arm curls on its way to the middle (degrees)
whirl_turn = 3 //How fast the arms turn (degrees per step)
whirl_splash_every = 12 //Steps between little splashes (Spr_Ripple) on the whirlpool
whirl_splash_speed = 12 //Splash animation, frames per second
whirl_amount = 0 //0-1.  How strong the whirlpool is right now
whirl_x = 0 //The whirlpool's middle
whirl_y = 0
whirl_dir = 1 //Which way it spins: 1 counterclockwise, -1 clockwise
whirl_angle = 0 //Turn of the spiral arms
whirl_splashes = [] //{ x, y, frame }
whirl_splash_timer = 0
whirl_push_x = 0 //Pixels the current moves the circle this step (Step adds them on)
whirl_push_y = 0

/// A little splash on the water
whirl_splash = function(sx, sy)
{
	array_push(whirl_splashes, { x: sx, y: sy, frame: 0 })
}

/// Whirlpool: dashes and waits.  Every so often it stops, spins, and opens a whirlpool around itself.  The current
/// carries the player's circle around in a spiral toward the middle, while the fish rides around the rim.
///   mode 0 dashing, 1 opening the whirlpool, 2 whirlpool, 3 calming down.  mode_timer counts down each part
swim_whirlpool = function(fish)
{
	if !fish.setup
	{
		fish.setup = true
		fish.mode_timer = irandom_range(whirl_every_min, whirl_every_max)
	}
	var R = box_size*whirl_radius
	var rim = R*whirl_rim

	//Splashes play once and are gone
	var splash_step = whirl_splash_speed/game_get_speed(gamespeed_fps)
	for (var i = array_length(whirl_splashes)-1; i >= 0; i--)
	{
		whirl_splashes[i].frame += splash_step
		if whirl_splashes[i].frame>=sprite_get_number(Spr_Ripple)
			array_delete(whirl_splashes, i, 1)
	}

	fish.mode_timer--
	switch(fish.mode)
	{
		case 0: //Dashing and waiting
			swim_dash_wait(fish)
			if fish.mode_timer<=0
			{
				//Open a whirlpool right here (kept mostly inside the pond)
				whirl_x = clamp(fish.x, box_x+R*0.6, box_x+box_size-R*0.6)
				whirl_y = clamp(fish.y, box_y+R*0.6, box_y+box_size-R*0.6)
				whirl_dir = choose(-1, 1)
				whirl_splash(fish.x, fish.y)
				var splash = audio_play_sound(snd_squish, 1, false)
				audio_sound_pitch(splash, 0.6)
				fish.mode = 1
				fish.mode_timer = whirl_windup
			}
			break

		case 1: //Spinning in the middle while the whirlpool opens
			fish.goal_x = whirl_x
			fish.goal_y = whirl_y
			swim_toward_goal(fish, fish.max_speed)
			fish.angle += 25*whirl_dir
			whirl_amount = 1 - fish.mode_timer/whirl_windup
			if fish.mode_timer<=0
			{
				fish.angle = 0
				fish.orbit_angle = point_direction(whirl_x, whirl_y, fish.x, fish.y)
				fish.mode = 2
				fish.mode_timer = whirl_time
			}
			break

		case 2: //Riding around the rim
			whirl_amount = 1
			fish.orbit_angle += whirl_dir*radtodeg(whirl_fish_speed/rim)
			var ride_x = whirl_x + lengthdir_x(rim, fish.orbit_angle)
			var ride_y = whirl_y + lengthdir_y(rim, fish.orbit_angle)
			//Heads out to the rim at the start, then sticks to it
			var to_rim = point_direction(fish.x, fish.y, ride_x, ride_y)
			var gap = min(point_distance(fish.x, fish.y, ride_x, ride_y), whirl_fish_speed*1.5)
			fish.vx = lengthdir_x(gap, to_rim)
			fish.vy = lengthdir_y(gap, to_rim)
			//Little splashes around the whirlpool
			whirl_splash_timer--
			if whirl_splash_timer<=0
			{
				whirl_splash_timer = whirl_splash_every
				var splash_dir = random(360)
				var splash_dist = R*random_range(0.4, 1)
				whirl_splash(whirl_x + lengthdir_x(splash_dist, splash_dir), whirl_y + lengthdir_y(splash_dist, splash_dir))
			}
			if fish.mode_timer<=0
			{
				fish.mode = 3
				fish.mode_timer = whirl_winddown
				fish.wait_timer = 0
				pick_goal(fish)
			}
			break

		case 3: //Calming down.  The fish swims off
			swim_dash_wait(fish)
			whirl_amount = fish.mode_timer/whirl_winddown
			if fish.mode_timer<=0
			{
				whirl_amount = 0
				fish.mode = 0
				fish.mode_timer = irandom_range(whirl_every_min, whirl_every_max)
			}
			break
	}

	//The spiral arms turn with the current
	whirl_angle += whirl_turn*whirl_dir*whirl_amount

	//The current: carries the circle around and drags it toward the middle.  Stronger closer in
	whirl_push_x = 0
	whirl_push_y = 0
	if whirl_amount>0
	{
		var dist = point_distance(whirl_x, whirl_y, circle_x, circle_y)
		var closeness = clamp(1 - dist/(R*1.15), 0, 1)
		if closeness>0
		{
			var around = point_direction(whirl_x, whirl_y, circle_x, circle_y)
			var spin = whirl_spin*whirl_amount*(0.4 + 0.6*closeness)
			var pull = whirl_pull*whirl_amount*closeness*min(dist/20, 1) //Eases off right in the middle so it doesn't jitter
			whirl_push_x = lengthdir_x(spin, around+90*whirl_dir) + lengthdir_x(pull, around+180)
			whirl_push_y = lengthdir_y(spin, around+90*whirl_dir) + lengthdir_y(pull, around+180)
		}
	}
}

//---- Anglerfish (Glow) ----
angler_speed = 0.55 //Lurking speed, as a multiple of max_speed
angler_body_alpha = 0.05 //The body is dim and see-through...
angler_body_tint = make_colour_rgb(70,95,85) //...and dark
angler_dark_color = make_colour_rgb(60,70,115) //How dark the pond gets in rooms that aren't already dark
angler_lure_dist = 66 //How far out the lure hangs from its head (pixels)
angler_lure_raise = 25 //How far above level the lure hangs out in front (degrees)
angler_lure_sway = 18 //How far the lure sways back and forth (degrees)
angler_sway_speed = 3 //How fast it sways (degrees per step)
angler_lure_follow = 0.15 //How quickly the lure swings after the head (0-1)
angler_flick_min = 110 //Steps between flicks, where it throws the lure way out to one side
angler_flick_max = 220
angler_flick_time = 50 //Steps the lure stays out
angler_flick_dist = 95 //How far out it throws it (pixels)
angler_flick_follow = 0.3 //Flicks are quick
angler_lure_light = 60 //How much of the pond the lure lights up (radius)
angler_lure_glow = 16 //Size of the glow drawn around the lure
angler_lure_x = 0 //Where the lure is
angler_lure_y = 0
angler_flick_x = 0 //Where a flick throws it, from the head
angler_flick_y = 0
angler_reveal_time = 1 //Seconds it starts fully visible (in a lit pond) before fading into the dark
angler_hidden = 0 //0-1.  0 fully visible at the start, 1 dark and hidden

/// Where the lure's stalk grows from: the top of its head
angler_anchor_x = function(fish)
{
	return fish.x + fish.facing*sprite_get_width(fish.sprite)*0.25
}
angler_anchor_y = function(fish)
{
	return fish.y - sprite_get_height(fish.sprite)*0.3
}

/// Anglerfish: a dark, dim body that lurks slowly around the pond behind a bright lure on a stalk.  The lure
/// bobs and sways in front of it, and now and then it flicks the lure way out to one side to throw you off.
/// Only the body counts for the catch.  The pond goes dark (in any room), lit by the lure and the player's lantern.
///   mode_timer counts down to the next flick, wait_timer is how long the current flick has left
swim_angler = function(fish)
{
	if !fish.setup
	{
		fish.setup = true
		fish.mode_timer = irandom_range(angler_flick_min, angler_flick_max)
		angler_lure_x = fish.x
		angler_lure_y = fish.y
	}

	//Starts fully visible, then quickly fades into the dark: the body dims and the pond darkens
	angler_hidden = min(angler_hidden + 1/(angler_reveal_time*game_get_speed(gamespeed_fps)), 1)
	fish.alpha = lerp(1, angler_body_alpha, angler_hidden)
	fish.tint = merge_colour(c_white, angler_body_tint, angler_hidden)

	//Lurking slowly from spot to spot
	fish.goal_timer--
	if fish.goal_timer<=0 or point_distance(fish.x, fish.y, fish.goal_x, fish.goal_y)<10
	{
		pick_goal(fish)
		fish.goal_timer = irandom_range(60, 150)
	}
	swim_toward_goal(fish, fish.max_speed*angler_speed)

	//The lure
	var anchor_x = angler_anchor_x(fish)
	var anchor_y = angler_anchor_y(fish)
	var target_x, target_y, follow
	fish.phase += angler_sway_speed
	if fish.wait_timer>0
	{
		//Flicked way out to one side
		fish.wait_timer--
		target_x = anchor_x + angler_flick_x
		target_y = anchor_y + angler_flick_y
		follow = angler_flick_follow
	}
	else
	{
		//Dangling out in front, swaying
		var hang_dir = ((fish.facing>0) ? angler_lure_raise : 180-angler_lure_raise) + dsin(fish.phase)*angler_lure_sway*fish.facing
		target_x = anchor_x + lengthdir_x(angler_lure_dist, hang_dir)
		target_y = anchor_y + lengthdir_y(angler_lure_dist, hang_dir)
		follow = angler_lure_follow
		//Time for a flick
		fish.mode_timer--
		if fish.mode_timer<=0
		{
			var flick_dir = random(360)
			angler_flick_x = lengthdir_x(angler_flick_dist, flick_dir)
			angler_flick_y = lengthdir_y(angler_flick_dist, flick_dir)
			fish.wait_timer = angler_flick_time
			fish.mode_timer = irandom_range(angler_flick_min, angler_flick_max)
		}
	}
	angler_lure_x += (target_x-angler_lure_x)*follow
	angler_lure_y += (target_y-angler_lure_y)*follow
	angler_lure_x = clamp(angler_lure_x, box_x+4, box_x+box_size-4)
	angler_lure_y = clamp(angler_lure_y, box_y+4, box_y+box_size-4)
}

//---- Shadow (Coal) ----
shadow_time = 4 //Seconds every light but Coal's stays out
shadow_recharge = 1.7 //Seconds before it can do it again
shadow_warning = 0.7 //Seconds the lights flicker before they go out
shadow_fade = 15 //Steps the lights take to go out or come back
shadow_dark_color = make_colour_rgb(18,12,30) //How dark the pond gets while the lights are out
shadow_amount = 0 //0-1.  How far the lights are out.  The room's obj_lighting reads this too

/// Shadow: dashes and waits like Dash and Wait.  Every few seconds the lights flicker, then every light goes out,
/// Coal's own too (the player's lantern, and the boat and fish out in the room) and the room gets even darker.
/// The player has to remember where it was heading.  After a few seconds they come back, and it recharges.
///   mode 0 recharging, 1 lights out.  mode_timer counts down each part
swim_shadow = function(fish)
{
	var steps_per_second = game_get_speed(gamespeed_fps)
	if !fish.setup
	{
		fish.setup = true
		fish.mode_timer = round(shadow_recharge*steps_per_second)
	}
	swim_dash_wait(fish)

	fish.mode_timer--
	if fish.mode=0
	{
		//Lights coming back, then flickering as it gets ready again
		var flicker = 0
		if fish.mode_timer<shadow_warning*steps_per_second and random(1)<0.3
			flicker = random_range(0.3, 0.8)
		shadow_amount = max(shadow_amount - 1/shadow_fade, flicker)
		if fish.mode_timer<=0
		{
			fish.mode = 1
			fish.mode_timer = round(shadow_time*steps_per_second)
			var snuff = audio_play_sound(snd_slm_grrrrr, 1, false)
			audio_sound_pitch(snuff, 0.6)
			audio_sound_gain(snuff, 0.6, 0)
		}
	}
	else
	{
		//Lights out
		shadow_amount = min(shadow_amount + 1/shadow_fade, 1)
		if fish.mode_timer<=0
		{
			fish.mode = 0
			fish.mode_timer = round(shadow_recharge*steps_per_second)
		}
	}
}

//---- Ice walls (Cold) ----
ice_walls = [] //{ x1, y1, x2, y2, thick, life, form, growing, solid }.  One block of ice from (x1, y1) to (x2, y2)
ice_every = 3 //Every this-many dashes is an ice dash
ice_distance = 0.5 //An ice dash goes at least this far (a fraction of the pond's size)
ice_length = 50 //How long the wall is, end to end (pixels)
ice_thick = 22 //How thick the wall is (pixels)
ice_form_time = 15 //Steps the wall takes to freeze solid after it appears
ice_life = 360 //Steps a wall lasts once it's frozen (6 seconds)
ice_melt = 0.35 //Shrinks and fades over the last this-much of its life
ice_glow = 1.6 //Glow around the wall, as a multiple of its thickness
ice_dash_count = 0 //Dashes so far.  The first one is an ice dash
ice_was_moving = false //Was it dashing last step (to spot when a dash starts)
ice_pending = false //True while an ice dash hasn't dropped its wall yet
ice_start_x = 0 //Where the ice dash started...
ice_start_y = 0
ice_halfway = 0 //...and how far it goes before dropping the wall

/// Ice walls: dashes and waits like Dash and Wait.  Every few dashes it goes a long way, and halfway there it
/// drops a short wall of ice across its path, behind it.  The wall freezes solid a moment later.  The player's
/// circle can't pass through it and has to go around, but the fish slips right through.  The wall melts after a while
swim_ice_walls = function(fish)
{
	swim_dash_wait(fish)

	var moving = fish.wait_timer<=0
	//A dash starts.  Every few is an ice dash
	if moving and !ice_was_moving
	{
		ice_pending = (ice_dash_count mod ice_every)=0
		ice_dash_count++
		if ice_pending
		{
			pick_far_goal(fish, ice_distance)
			ice_start_x = fish.x
			ice_start_y = fish.y
			ice_halfway = point_distance(fish.x, fish.y, fish.goal_x, fish.goal_y)/2
		}
	}
	ice_was_moving = moving

	//Halfway there: drop the wall across its path
	if ice_pending and point_distance(ice_start_x, ice_start_y, fish.x, fish.y)>=ice_halfway
	{
		ice_pending = false
		var across = point_direction(ice_start_x, ice_start_y, fish.goal_x, fish.goal_y) + 90
		var reach = max(ice_length-ice_thick, 0)/2 //The ends are rounded off by half the thickness (ice_shape)
		array_push(ice_walls, {
			x1: fish.x + lengthdir_x(reach, across), y1: fish.y + lengthdir_y(reach, across),
			x2: fish.x - lengthdir_x(reach, across), y2: fish.y - lengthdir_y(reach, across),
			thick: ice_thick, life: ice_life, form: ice_form_time, growing: true, solid: false })
	}

	//Freezing solid, then melting
	for (var i = array_length(ice_walls)-1; i >= 0; i--)
	{
		var wall = ice_walls[i]
		if wall.growing
		{
			wall.form--
			if wall.form<=0
			{
				wall.growing = false
				var freeze = audio_play_sound(snd_icefreeze2, 1, false)
				audio_sound_pitch(freeze, random_range(0.95, 1.1))
			}
			continue
		}
		wall.life--
		if wall.life<=0
			array_delete(ice_walls, i, 1)
	}
}

/// How solid a wall still is: 1 most of its life, down to 0 as it melts away
ice_strength = function(wall)
{
	return wall.growing ? 1 : clamp(wall.life/(ice_life*ice_melt), 0, 1)
}

/// A wall's shape right now: { cx, cy, angle, half_length, half_thick }.  Melting shrinks it in from the ends and the sides
ice_shape = function(wall)
{
	var melt = ice_strength(wall)
	return {
		cx: (wall.x1+wall.x2)/2,
		cy: (wall.y1+wall.y2)/2,
		angle: point_direction(wall.x1, wall.y1, wall.x2, wall.y2),
		half_length: (point_distance(wall.x1, wall.y1, wall.x2, wall.y2)/2 + wall.thick/2)*(0.4 + 0.6*melt), //Rounded off past each end
		half_thick: wall.thick/2*melt
	}
}

/// A point on a wall, from its middle: along its length, and across it
ice_point_x = function(shape, along, across)
{
	return shape.cx + along*dcos(shape.angle) + across*dsin(shape.angle)
}
ice_point_y = function(shape, along, across)
{
	return shape.cy - along*dsin(shape.angle) + across*dcos(shape.angle)
}

/// Pushes the player's circle out of any ice it's run into, and stops it moving into the ice.  A wall that's still
/// forming isn't solid, and a wall that froze on top of the circle doesn't count until the circle has moved off it
ice_push_circle = function()
{
	for (var i = 0; i < array_length(ice_walls); i++)
	{
		var wall = ice_walls[i]
		if wall.growing
			continue
		var shape = ice_shape(wall)
		//Closest point on the wall to the middle of the circle (worked out along and across the wall)
		var dx = circle_x - shape.cx
		var dy = circle_y - shape.cy
		var along = clamp(dx*dcos(shape.angle) - dy*dsin(shape.angle), -shape.half_length, shape.half_length)
		var across = clamp(dx*dsin(shape.angle) + dy*dcos(shape.angle), -shape.half_thick, shape.half_thick)
		var near_x = ice_point_x(shape, along, across)
		var near_y = ice_point_y(shape, along, across)
		var dist = point_distance(near_x, near_y, circle_x, circle_y)
		var touching = dist<circle_radius
		if !wall.solid
		{
			if !touching
				wall.solid = true
			continue
		}
		if touching and dist>0.01
		{
			//Push straight out, and cancel any speed going into the ice
			var out_x = (circle_x-near_x)/dist
			var out_y = (circle_y-near_y)/dist
			circle_x += out_x*(circle_radius-dist)
			circle_y += out_y*(circle_radius-dist)
			var into = circle_vx*out_x + circle_vy*out_y
			if into<0
			{
				circle_vx -= into*out_x
				circle_vy -= into*out_y
			}
		}
	}
}

//---- Ballet (Bowed) ----
//The routine, in order.  It loops, dancing the other way each time
ballet_routine = ["glide", "hop", "hop", "hop", "leap", "pirouette", "leap_back", "pirouette", "arabesque", "curtsy"]
ballet_margin = 40 //Keeps the dancing this far inside the pond
ballet_glide_time = 60 //Steps to glide to the starting spot
ballet_hop_dist = 28 //Little hops
ballet_hop_height = 10
ballet_hop_time = 14
ballet_leap_dist = 150 //Grand leaps
ballet_leap_height = 55
ballet_leap_time = 45
ballet_leap_grow = 0.25 //Gets this much bigger at the top of a leap, like she's leaping toward you
ballet_spin_time = 50 //Pirouettes
ballet_spin_turns = 2
ballet_spin_rise = 6 //Rises up on her toes while she spins
ballet_pose_time = 40 //Arabesque: holds a pose, nose up
ballet_pose_tilt = 20
ballet_curtsy_time = 60 //Curtsy: dips and holds.  The easiest moment to catch her
ballet_curtsy_dip = 6
ballet_curtsy_tilt = 15
ballet_sparkle_color = make_colour_rgb(255,170,215)
ballet_dir = 1 //Which way this routine travels: 1 right, -1 left
ballet_kind = "" //The step she's on
ballet_time = 1 //How many steps it lasts
ballet_height = 0 //How high it arcs
ballet_sparkles = [] //{ x, y, vx, vy, life, spin }

/// Little sparkles that drift and fade
ballet_sparkle = function(sx, sy)
{
	array_push(ballet_sparkles, { x: sx + random_range(-6, 6), y: sy + random_range(-6, 6), vx: random_range(-0.4, 0.4), vy: random_range(-0.6, -0.1), life: 30, spin: random(90) })
}

/// Starts the next step of the routine: works out where it goes and how long it takes
ballet_begin = function(fish)
{
	ballet_kind = ballet_routine[fish.mode]
	fish.mode_timer = 0
	fish.mode_x = fish.x
	fish.mode_y = fish.y
	fish.goal_x = fish.x
	fish.goal_y = fish.y
	ballet_height = 0
	var left = box_x + ballet_margin
	var right = box_x + box_size - ballet_margin
	var top = box_y + ballet_margin + ballet_leap_height //Room above for the leaps
	var bottom = box_y + box_size - ballet_margin
	switch(ballet_kind)
	{
		case "glide": //To the side she'll dance away from, so there's room
			fish.goal_x = (ballet_dir>0) ? random_range(left, box_x+box_size*0.3) : random_range(box_x+box_size*0.7, right)
			fish.goal_y = random_range(max(top, box_y+box_size*0.35), box_y+box_size*0.75)
			ballet_time = ballet_glide_time
			break
		case "hop":
			fish.goal_x = clamp(fish.x + ballet_dir*ballet_hop_dist, left, right)
			ballet_height = ballet_hop_height
			ballet_time = ballet_hop_time
			break
		case "leap":
		case "leap_back":
			var leap_dir = (ballet_kind="leap") ? ballet_dir : -ballet_dir
			fish.goal_x = clamp(fish.x + leap_dir*ballet_leap_dist, left, right)
			fish.goal_y = clamp(fish.y + random_range(-20, 20), top, bottom)
			ballet_height = ballet_leap_height
			ballet_time = ballet_leap_time
			break
		case "pirouette":
			ballet_time = ballet_spin_time
			break
		case "arabesque":
			ballet_time = ballet_pose_time
			break
		case "curtsy":
			ballet_time = ballet_curtsy_time
			var chime = audio_play_sound(snd_menu_chime, 1, false)
			audio_sound_pitch(chime, 1.5)
			audio_sound_gain(chime, 0.4, 0)
			break
	}
}

/// Ballet: dances a little routine across the pond.  Glides to one side, three little hops, a grand leap,
/// a pirouette, a leap back, another pirouette, an arabesque pose, and a curtsy.  Then again the other way.
///   mode is which step of ballet_routine she's on, mode_timer counts up through it.
///   mode_x/mode_y is where the step started, goal_x/goal_y where it ends
swim_ballet = function(fish)
{
	if !fish.setup
	{
		fish.setup = true
		fish.mode = 0
		ballet_begin(fish)
	}

	//Sparkles drift and fade
	for (var i = array_length(ballet_sparkles)-1; i >= 0; i--)
	{
		var sparkle = ballet_sparkles[i]
		sparkle.x += sparkle.vx
		sparkle.y += sparkle.vy
		sparkle.spin += 6
		sparkle.life--
		if sparkle.life<=0
			array_delete(ballet_sparkles, i, 1)
	}

	fish.mode_timer++
	var t = min(fish.mode_timer/ballet_time, 1)
	var smooth = 0.5 - 0.5*cos(pi*t) //Eases in and out
	var arc = sin(pi*t) //0 at the ends, 1 in the middle
	var hold = clamp(min(t/0.2, (1-t)/0.2), 0, 1) //Eases into a pose, holds it, eases out
	var travel = sign(fish.goal_x-fish.mode_x)
	var place_x = lerp(fish.mode_x, fish.goal_x, smooth)
	var place_y = lerp(fish.mode_y, fish.goal_y, smooth) - arc*ballet_height
	fish.angle = 0
	fish.scale = 1
	fish.spin_x = 1
	fish.face_lock = fish.facing //Keeps facing the same way unless the step says otherwise

	switch(ballet_kind)
	{
		case "glide": //Smooth, with a gentle bob
			place_y += sin(fish.mode_timer*0.25)*2
			fish.face_lock = 0 //Faces the way it's going
			break
		case "hop":
		case "leap":
		case "leap_back": //Nose up on the way up, nose down on the way down
			if travel<>0
				fish.face_lock = travel
			var tilt = (ballet_kind="hop") ? 20 : 35
			fish.angle = fish.face_lock*tilt*(1-2*t)
			if ballet_kind<>"hop"
			{
				fish.scale = 1 + ballet_leap_grow*arc
				if fish.mode_timer mod 3=0
					ballet_sparkle(fish.x, fish.y)
			}
			break
		case "pirouette": //Spins around on the spot, rising up on her toes
			var turn = t*360*ballet_spin_turns
			fish.spin_x = max(abs(dcos(turn)), 0.15)
			fish.face_lock = (dcos(turn)>=0) ? ballet_dir : -ballet_dir
			place_y -= arc*ballet_spin_rise
			if fish.mode_timer mod 4=0
				ballet_sparkle(fish.x, fish.y-8)
			break
		case "arabesque": //Holds a pose, nose up
			fish.angle = fish.face_lock*ballet_pose_tilt*hold
			place_y -= 4*hold
			break
		case "curtsy": //Dips with its nose down and holds it
			fish.angle = -fish.face_lock*ballet_curtsy_tilt*hold
			place_y += ballet_curtsy_dip*hold
			if fish.mode_timer=round(ballet_time/2)
				repeat(5) ballet_sparkle(fish.x, fish.y-10)
			break
	}

	//Move exactly to this step's spot (Step adds the speed on)
	fish.vx = place_x - fish.x
	fish.vy = place_y - fish.y

	//Next step.  After the curtsy, start over going the other way
	if t>=1
	{
		fish.mode++
		if fish.mode>=array_length(ballet_routine)
		{
			fish.mode = 0
			ballet_dir = -ballet_dir
		}
		ballet_begin(fish)
	}
}

//---- Moldy net (Mold) ----
mold_color = make_colour_rgb(120,165,70)
mold_dark_color = make_colour_rgb(70,105,45)
mold_puff_min = 100 //Steps between spore puffs
mold_puff_max = 170
mold_cloud_size = 30 //How big a spore cloud gets (radius)
mold_cloud_life = 300 //Steps a cloud hangs around (5 seconds)
mold_cloud_max = 4 //Most clouds at once
mold_catch_rate = 0.008 //How fast mold grows on the net while it's in a cloud (0-1 per step, so about 2 seconds to cover it)
mold_spread = 0.0006 //Once there's some mold, it slowly spreads on its own
mold_shrink = 0.45 //A fully moldy net is this much smaller
mold_shake_stroke = 25 //A shake is a quick back-and-forth: each stroke has to be at least this long (pixels)...
mold_shake_time = 12 //...and take no more than this many steps
mold_shake_clean = 0.12 //How much mold each shake knocks off
mold_hint_at = 0.25 //Shows "Shake it off!" when the net is this moldy
mold_hint = "Shake it off!"
mold_amount = 0 //0-1.  How moldy the net is
mold_base_radius = -1 //The net's size before any mold
mold_clouds = [] //{ x, y, vx, vy, life, puffs }  puffs: [ { x, y, size } ] offsets
mold_clumps = [] //Bits of mold flying off when it's shaken: { x, y, vx, vy, life, size }
mold_spots = [] //Where mold grows on the net, in order: { angle, out, size }.  out is 0-1 from the middle to the rim
mold_prev_mouse_x = 0
mold_prev_mouse_y = 0
mold_stroke_x = { dir: 0, length: 0, time: 0 } //The mouse's current back-and-forth stroke, sideways
mold_stroke_y = { dir: 0, length: 0, time: 0 } //...and up and down

/// Puffs out a spore cloud
mold_puff = function(px, py)
{
	if array_length(mold_clouds)>=mold_cloud_max
		array_delete(mold_clouds, 0, 1)
	var puffs = []
	repeat(8)
		array_push(puffs, { x: random_range(-0.6, 0.6), y: random_range(-0.6, 0.6), size: random_range(0.35, 0.6) })
	array_push(mold_clouds, { x: px, y: py, vx: random_range(-0.15, 0.15), vy: random_range(-0.2, 0), life: mold_cloud_life, puffs: puffs })
	var puff = audio_play_sound(snd_squish, 1, false)
	audio_sound_pitch(puff, 1.4)
	audio_sound_gain(puff, 0.5, 0)
}

/// How big and thick a cloud is: grows in quickly, fades at the end
mold_cloud_strength = function(cloud)
{
	var age = mold_cloud_life - cloud.life
	return min(age/20, 1) * min(cloud.life/(mold_cloud_life*0.3), 1)
}

/// Follows one direction of the mouse (sideways or up and down) and returns true when it finishes a quick shake stroke
mold_check_stroke = function(stroke, move)
{
	var dir = sign(move)
	var shook = false
	if dir<>0 and dir<>stroke.dir
	{
		//Turned around.  The stroke it just finished counts as a shake if it was long and quick
		shook = stroke.dir<>0 and stroke.length>=mold_shake_stroke and stroke.time<=mold_shake_time
		stroke.dir = dir
		stroke.length = 0
		stroke.time = 0
	}
	stroke.length += abs(move)
	stroke.time++
	return shook
}

/// Moldy net: swims around like Moving Constantly, puffing out spore clouds every so often.  Any cloud the player's
/// circle touches grows fuzzy mold on the net, which shrinks it.  Shaking the mouse quickly back and forth knocks
/// the mold off in clumps
swim_moldy_net = function(fish)
{
	if !fish.setup
	{
		fish.setup = true
		fish.mode_timer = irandom_range(mold_puff_min, mold_puff_max)/2 //First puff comes sooner
		mold_base_radius = circle_radius
		mold_prev_mouse_x = mouse_x
		mold_prev_mouse_y = mouse_y
		//Spots for mold to grow, mostly around the rim, in a random order
		repeat(26)
			array_push(mold_spots, { angle: random(360), out: random_range(0.55, 1), size: random_range(4, 8) })
	}
	swim_constant(fish)

	//Spore puffs
	fish.mode_timer--
	if fish.mode_timer<=0
	{
		mold_puff(fish.x, fish.y)
		fish.mode_timer = irandom_range(mold_puff_min, mold_puff_max)
	}

	//Clouds drift and fade.  Touching one grows mold on the net
	for (var i = array_length(mold_clouds)-1; i >= 0; i--)
	{
		var cloud = mold_clouds[i]
		cloud.x += cloud.vx
		cloud.y += cloud.vy
		cloud.life--
		if cloud.life<=0
		{
			array_delete(mold_clouds, i, 1)
			continue
		}
		var strength = mold_cloud_strength(cloud)
		if point_distance(cloud.x, cloud.y, circle_x, circle_y)<circle_radius + mold_cloud_size*0.6*strength
			mold_amount += mold_catch_rate*strength
	}
	if mold_amount>0
		mold_amount += mold_spread

	//Shaking the mouse knocks mold off
	var shook_x = mold_check_stroke(mold_stroke_x, mouse_x-mold_prev_mouse_x)
	var shook_y = mold_check_stroke(mold_stroke_y, mouse_y-mold_prev_mouse_y)
	mold_prev_mouse_x = mouse_x
	mold_prev_mouse_y = mouse_y
	if (shook_x or shook_y) and mold_amount>0
	{
		//Clumps fly off from the moldy spots, the way it was shaken
		var flick_x = shook_x ? -mold_stroke_x.dir*3 : 0
		var flick_y = shook_y ? -mold_stroke_y.dir*3 : 0
		var clumps = ceil(mold_amount*6) + 1
		for (var k = 0; k < clumps; k++)
		{
			var spot = mold_spots[irandom(max(floor(mold_amount*array_length(mold_spots))-1, 0))]
			var spot_x = circle_x + lengthdir_x(circle_radius*spot.out, spot.angle)
			var spot_y = circle_y + lengthdir_y(circle_radius*spot.out, spot.angle)
			array_push(mold_clumps, { x: spot_x, y: spot_y, vx: flick_x + random_range(-1.5, 1.5), vy: flick_y + random_range(-2.5, 0.5), life: 35, size: spot.size*0.7 })
		}
		mold_amount -= mold_shake_clean
		var plop = audio_play_sound(snd_squish, 1, false)
		audio_sound_pitch(plop, random_range(1.7, 2))
		audio_sound_gain(plop, 0.4, 0)
	}
	mold_amount = clamp(mold_amount, 0, 1)

	//Mold shrinks the net
	circle_radius = mold_base_radius*(1 - mold_shrink*mold_amount)

	//Flying clumps fall and fade
	for (var i = array_length(mold_clumps)-1; i >= 0; i--)
	{
		var clump = mold_clumps[i]
		clump.vy += 0.15
		clump.x += clump.vx
		clump.y += clump.vy
		clump.life--
		if clump.life<=0
			array_delete(mold_clumps, i, 1)
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
		case FISH_MOVE.GIFT:              swim_gift(fish);            break
		case FISH_MOVE.SHY_GHOST:         swim_shy_ghost(fish);       break
		case FISH_MOVE.LIGHTNING:         swim_lightning(fish);       break
		case FISH_MOVE.EMBERS:            swim_embers(fish);          break
		case FISH_MOVE.WHIRLPOOL:         swim_whirlpool(fish);       break
		case FISH_MOVE.ANGLER:            swim_angler(fish);          break
		case FISH_MOVE.SHADOW:            swim_shadow(fish);          break
		case FISH_MOVE.ICE_WALLS:         swim_ice_walls(fish);       break
		case FISH_MOVE.BALLET:            swim_ballet(fish);          break
		case FISH_MOVE.MOLDY_NET:         swim_moldy_net(fish);       break
	}
}

fish = make_fish(fish_data)
//Things that follow the fish start on it (they're set up on its first swim, after the starting pause)
angler_lure_x = fish.x
angler_lure_y = fish.y
bar_fill = fish_data.start_bar
//The table gives these per second.  The bar changes every step
bar_grow = fish_data.bar_grow/game_get_speed(gamespeed_fps)
bar_shrink = fish_data.bar_shrink/game_get_speed(gamespeed_fps)
