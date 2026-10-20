gloop_color_index=7
sprite_index=Spr_Slm_Sleep
mask_index=Spr_Slm_Sleep //Keeps clicks/collisions the same size when showing bigger sprites like Spr_Slm_Snowball

controller = global.controller

depth=0

//Area on the right side of the screen the slimes stay inside
top_boundry = 100
bottom_boundry = 580
left_boundry=1120
right_boundry=room_width


/*
	Unused gloops run a simple state machine.  A slime is always doing exactly one thing (its state).

	To add a new animation (building a snowman, snowball fight, getting snowed on, ...):
		1. Add a state to the UG_STATE enum below
		2. Add a case for it in set_state() (setup when it starts), step_state() (what it does each step)
		   and get_look() (which sprite to show)
		3. Add an entry to wake_activities so a sleeping slime can randomly start it
*/
enum UG_STATE {
	SLEEP,      //Napping.  Poke it too much and it gets angry
	CHASE,      //Hopping after the cursor.  Releases a heart if it touches it
	SAD,        //Gave up chasing the cursor
	LEAF_WALK,  //Fall: walking over to the leaf pile
	LEAF_DIVE,  //Fall: flipping into the leaf pile
	LAUNCHED,   //Fall: knocked out of the leaf pile by another slime diving in
	SNOWED,     //Winter: napped so long it's covered in snow
	SNOW_SHAKE, //Shaking the snow off, then doing next_state
	FIGHT_WALK, //Winter: hopping to its spot for a snowball fight
	FIGHT,      //Winter: throwing snowballs up/down at fight_partner
	GO_HOME,    //Day is over: hopping to the house
	HOME,       //Made it to the house: fading out
	GAME_OVER,  //Game lost: sad until fed

	//Idle animations.  Like SLEEP these are base states a slime just hangs out in.  Each one plays all the way
	//through before the slime goes back to SLEEP.  See get_idle_look() for the sprites
	IDLE_ANGLE,      //Slm_Grn_angle: zips around the corners of a square
	IDLE_JUMP_UP,    //Slm_Grn_Move_Up_Jump: a few little hops in place
	IDLE_JUMP,       //Slm_Grn_Jump: one big jump
	IDLE_HOP_JIGGLE, //Slm_Grn_hop_jiggle: hops to the side and back
	IDLE_MUSIC       //Spr_Slm_music: bobs along to music in headphones
}

//Frames in Slm_All_Base_Expressions
enum UG_FACE {
	HAPPY=1,
	ANNOYED=2,
	SAD=3,
	ANGRY=4,
	SASSY=5,
	LOVE=6,
	DIZZY=7
}

state=UG_STATE.SLEEP
state_time=0 //Steps spent in the current state
sleep_time=0 //Steps asleep.  Activities can require a minimum nap first
rest_time=0 //Steps asleep since the last idle animation.  Idle animations wait a bit between each other
anim_frame=0 //Idle animations: frames played so far, counting every loop
anim_loops=1 //Idle animations: how many times this one plays before the slime settles back down

//Moods show on top of whatever the slime is doing
happy_timer=0
angry_timer=0
clicks_while_sleeping=0

chase_time_max=1320 //How long it chases the cursor before giving up
sad_time=180 //How long it stays sad

//Leaf pile
leaf_id=noone
jump_target_x=0
jump_target_y=0
leaf_target_x=0
leaf_target_y=0
in_leaf_pile=noone //The leaf pile it's napping in, if any
rotation=0

//Launched out of the leaf pile
launch_start_x=0
launch_start_y=0
launch_target_x=0
launch_target_y=0
launch_flight_time=50 //Steps in the air
launch_arc_height=60 //How high above the straight line it flies
launch_dizzy_time=60 //Steps it stays dizzy after landing
launch_spin_speed=15 //Degrees per step

//House
home_x=1180
home_y=50

//Snow (Spr_Slm_Snowball: frames 0-11 snow piles on, 11-23 snow falls off)
snow_frame=0
next_state=UG_STATE.SLEEP //What to do after shaking off the snow

//Snowball fight.  Two slimes line up one above the other and throw snowballs at each other
fight_partner=noone //The slime it's fighting
fight_dir=1 //1 = on top throwing down, -1 = on the bottom throwing up
fight_spot_x=0
fight_spot_y=0
fight_gap=140 //Pixels between the two fighters
fight_throws_left=0 //Snowballs left to throw.  The fight ends when both run out
fight_throw_timer=0
fight_throw_every=50 //Steps between throws (re-rolled each throw)
fight_hits=0 //Times it got hit
fight_windup=15 //Steps of wind-up before each throw (same as obj_test_slimebrawl)
snowball_speed=5
aim_wobble=1.5 //Sideways error on each throw.  Bigger = more misses
hit_timer=0 //Dizzy face after getting hit


/*
	Things a sleeping slime can wake up and do.  Checked in order every step.
		odds      -- chance per step of starting
		min_sleep -- steps it has to nap first
		allowed   -- extra conditions, like the season
		idle_anim -- true for the idle animations.  These also need min_rest steps since the last one, and never
		             start while the slime is napping in a leaf pile
		max_progress -- optional.  Doesn't start once the day's goal is this far done (0.4 = 40%).
		                For animations that don't look right with the dusk/night lighting
*/
wake_activities = [
	{
		name: "chase cursor",
		odds: 4/100000,
		min_sleep: 1000,
		state: UG_STATE.CHASE,
		idle_anim: false,
		allowed: function() { return true }
	},
	{
		name: "leaf pile",
		odds: 4/10000,
		min_sleep: 300,
		state: UG_STATE.LEAF_WALK,
		idle_anim: false,
		allowed: function() { return global.weather=global.FALL and instance_exists(obj_effectLeafPile) }
	},
	{
		name: "snowed on",
		odds: 1/300,
		min_sleep: 900,
		state: UG_STATE.SNOWED,
		idle_anim: false,
		allowed: function() { return global.weather=global.WINTER }
	},
	{
		name: "snowball fight",
		odds: 1/4000,
		min_sleep: 300,
		state: UG_STATE.FIGHT_WALK, //Picks a napping slime to fight in set_state()
		idle_anim: false,
		allowed: function()
		{
			//One fight at a time
			if global.weather<>global.WINTER
				return false
			var fight_on = false
			with(obj_unusedGloop)
				if state=UG_STATE.FIGHT_WALK or state=UG_STATE.FIGHT
					fight_on = true
			return !fight_on
		}
	},

	//Idle animations
	{
		name: "angle",
		odds: 1/6000,
		min_sleep: 180,
		min_rest: 120,
		state: UG_STATE.IDLE_ANGLE,
		idle_anim: true,
		max_progress: 0.4,
		allowed: function() { return true }
	},
	{
		name: "jump up",
		odds: 1/6000,
		min_sleep: 180,
		min_rest: 120,
		state: UG_STATE.IDLE_JUMP_UP,
		idle_anim: true,
		allowed: function() { return true }
	},
	{
		name: "jump",
		odds: 1/6000,
		min_sleep: 180,
		min_rest: 120,
		state: UG_STATE.IDLE_JUMP,
		idle_anim: true,
		max_progress: 0.4,
		allowed: function() { return true }
	},
	{
		name: "hop jiggle",
		odds: 1/6000,
		min_sleep: 180,
		min_rest: 120,
		state: UG_STATE.IDLE_HOP_JIGGLE,
		idle_anim: true,
		max_progress: 0.4,
		allowed: function() { return true }
	},
	{
		name: "music",
		odds: 1/6000,
		min_sleep: 180,
		min_rest: 120,
		state: UG_STATE.IDLE_MUSIC,
		idle_anim: true,
		allowed: function() { return true }
	}
]


/*
	How each idle animation is drawn.  Returns undefined for states that aren't idle animations.
		sprite     -- the animation
		off_x/off_y -- where to draw it relative to the slime so its resting pose lines up with Spr_Slm_Sleep
		               (these sprites are bigger than 32x32 and have the slime somewhere inside)
*/
get_idle_look = function(for_state)
{
	switch(for_state)
	{
		case UG_STATE.IDLE_ANGLE:      return { sprite: Slm_Grn_angle,         off_x: 0,  off_y: -32 }
		case UG_STATE.IDLE_JUMP_UP:    return { sprite: Slm_Grn_Move_Up_Jump,  off_x: 0,  off_y: 0 }
		case UG_STATE.IDLE_JUMP:       return { sprite: Slm_Grn_Jump,          off_x: 0,  off_y: -64 }
		case UG_STATE.IDLE_HOP_JIGGLE: return { sprite: Slm_Grn_hop_jiggle,    off_x: 0,  off_y: 0 }
		case UG_STATE.IDLE_MUSIC:      return { sprite: Spr_Slm_music,         off_x: -6, off_y: 0 }
	}
	return undefined
}


/// Switch to a new state and do any setup it needs
set_state = function(new_state)
{
	//Leaving a snowball fight for any reason (going home, game over, ...): the other slime stops too
	if is_fighting() and new_state<>UG_STATE.FIGHT_WALK and new_state<>UG_STATE.FIGHT
	{
		var partner = fight_partner
		fight_partner=noone
		if instance_exists(partner) and partner.fight_partner=id
			with(partner)
			{
				fight_partner=noone
				set_state(UG_STATE.SLEEP)
			}
	}

	state=new_state
	state_time=0
	speed=0
	rotation=0
	in_leaf_pile=noone

	switch(state)
	{
		case UG_STATE.SLEEP:
			sleep_time=0
			rest_time=0
			break

		case UG_STATE.IDLE_ANGLE:
		case UG_STATE.IDLE_JUMP:
		case UG_STATE.IDLE_HOP_JIGGLE:
			anim_frame=0
			anim_loops=irandom_range(2, 5)
			break


		case UG_STATE.IDLE_JUMP_UP:
		case UG_STATE.IDLE_MUSIC:
			anim_frame=0
			anim_loops=irandom_range(8, 12)
			break

		case UG_STATE.LEAF_WALK:
			leaf_id = instance_nearest(x, y, obj_effectLeafPile)
			if !instance_exists(leaf_id)
			{
				set_state(UG_STATE.SLEEP)
				break
			}
			jump_target_x = leaf_id.x+(leaf_id.sprite_width/2)+70
			jump_target_y = leaf_id.y+(leaf_id.sprite_height/2)+10
			leaf_target_x = leaf_id.x+(leaf_id.sprite_width/2)+16
			leaf_target_y = leaf_id.y+(leaf_id.sprite_height/2)+16
			break

		case UG_STATE.SNOWED:
			snow_frame=0
			break

		case UG_STATE.SNOW_SHAKE:
			snow_frame=11
			break

		case UG_STATE.FIGHT_WALK:
			//No partner yet: this slime is starting the fight.  Challenge the nearest slime that's napping
			if fight_partner=noone
			{
				var me = id
				var closest = noone
				var closest_dist = infinity
				with(obj_unusedGloop)
				{
					if id<>me and state=UG_STATE.SLEEP and in_leaf_pile=noone and image_alpha>0
					{
						var d = point_distance(x, y, me.x, me.y)
						if d<closest_dist
						{
							closest = id
							closest_dist = d
						}
					}
				}
				if closest=noone
				{
					set_state(UG_STATE.SLEEP)
					break
				}

				//Line up one above the other, between where the two of them are now
				var center_x = clamp((x+closest.x)/2, left_boundry, right_boundry-32)
				var center_y = clamp((y+closest.y)/2, top_boundry+fight_gap/2, bottom_boundry-fight_gap/2)
				fight_partner = closest
				fight_dir = (y<=closest.y) ? 1 : -1 //Whoever's higher up takes the top spot
				fight_spot_x = center_x
				fight_spot_y = center_y - fight_dir*fight_gap/2
				fight_throws_left = irandom_range(5, 8)

				closest.fight_partner = id
				closest.fight_dir = -fight_dir
				closest.fight_spot_x = center_x
				closest.fight_spot_y = center_y + fight_dir*fight_gap/2
				closest.fight_throws_left = fight_throws_left
				with(closest)
					set_state(UG_STATE.FIGHT_WALK)
			}
			fight_hits=0
			hit_timer=0
			fight_throw_every=irandom_range(40, 60)
			//The bottom slime starts half a throw later so they take turns
			fight_throw_timer = (fight_dir=1) ? 0 : -fight_throw_every/2
			break

		case UG_STATE.GO_HOME:
			//Random starting frame so they don't all hop in sync
			sprite_index=Spr_Slm_Move_Jump
			image_index = irandom(sprite_get_number(Spr_Slm_Move_Jump) - 1)
			break
	}
}


/// What the slime does each step in its current state
step_state = function()
{
	state_time++

	switch(state)
	{
		case UG_STATE.SLEEP:
			sleep_time++
			rest_time++

			//Annoy sleeping slime
			if mouse_check_button_pressed(mb_left) and position_meeting(mouse_x, mouse_y, id)
			{
				clicks_while_sleeping++
				shake(2)
				if clicks_while_sleeping>10
				{
					clicks_while_sleeping=0
					angry_timer=180
				}
			}

			//Maybe wake up and do something
			var activity_state = pick_wake_activity()
			if activity_state<>-1
				set_state(activity_state)
			break

		case UG_STATE.IDLE_ANGLE:
		case UG_STATE.IDLE_JUMP_UP:
		case UG_STATE.IDLE_JUMP:
		case UG_STATE.IDLE_HOP_JIGGLE:
		case UG_STATE.IDLE_MUSIC:
			//Still counts as napping time, but nothing new starts until the animation has played all the way through
			sleep_time++
			var idle = get_idle_look(state)
			anim_frame += sprite_get_speed(idle.sprite) / game_get_speed(gamespeed_fps)
			if anim_frame >= sprite_get_number(idle.sprite)*anim_loops
			{
				var nap_so_far = sleep_time
				set_state(UG_STATE.SLEEP)
				sleep_time = nap_so_far
			}
			break

		case UG_STATE.SNOWED:
			sleep_time++
			//Snow piles on, then stays on the last frame
			snow_frame = min(snow_frame + snow_anim_speed(), 11)

			//Poking it knocks the snow off
			if mouse_check_button_pressed(mb_left) and position_meeting(mouse_x, mouse_y, id)
			{
				shake_off_snow(UG_STATE.SLEEP)
				break
			}

			//Waking up: shake the snow off first
			var wake_state = pick_wake_activity(false)
			if wake_state<>-1 and wake_state<>UG_STATE.SNOWED
				shake_off_snow(wake_state)
			break

		case UG_STATE.SNOW_SHAKE:
			snow_frame += snow_anim_speed()
			if snow_frame>=23
			{
				var after_shake = next_state
				next_state=UG_STATE.SLEEP
				set_state(after_shake)
			}
			break

		case UG_STATE.FIGHT_WALK:
			if !fight_partner_ok()
			{
				set_state(UG_STATE.SLEEP)
				break
			}
			move_towards_point(fight_spot_x, fight_spot_y, 1.5)
			if distance_to_point(fight_spot_x, fight_spot_y)<2
			{
				x=fight_spot_x
				y=fight_spot_y
				set_state(UG_STATE.FIGHT)
			}
			break

		case UG_STATE.FIGHT:
			if !fight_partner_ok()
			{
				set_state(UG_STATE.SLEEP)
				break
			}
			if hit_timer>0
				hit_timer--
			//Wait for the other slime to get to its spot
			if fight_partner.state<>UG_STATE.FIGHT
				break

			if fight_throws_left>0
			{
				fight_throw_timer++
				if fight_throw_timer>=fight_throw_every
				{
					throw_snowball()
					fight_throws_left--
					fight_throw_timer=0
					fight_throw_every=irandom_range(40, 60)
				}
			}
			//The top slime calls the fight once both are out of snowballs and the last one has landed
			else if fight_dir=1 and fight_partner.fight_throws_left<=0 and !snowballs_flying()
				finish_fight()
			break

		case UG_STATE.CHASE:
			//Stops to eat when fed.  Eating time doesn't count toward giving up
			if happy_timer>0
			{
				speed=0
				state_time--
				break
			}

			move_towards_point(mouse_x, mouse_y, 1)

			//Leave a slime puddle each hop
			if image_index>image_number-1
			{
				image_index = 0
				var inst = instance_create_layer(x, y, "Instances", obj_effect_slime)
				inst.gloop_color_index=gloop_color_index
			}

			if state_time>chase_time_max
				set_state(UG_STATE.SAD)
			break

		case UG_STATE.SAD:
			if state_time>sad_time
				set_state(UG_STATE.SLEEP)
			break

		case UG_STATE.LEAF_WALK:
			if !instance_exists(leaf_id)
			{
				set_state(UG_STATE.SLEEP)
				break
			}
			move_towards_point(jump_target_x, jump_target_y, 1.5)
			if distance_to_point(jump_target_x, jump_target_y)<3
				set_state(UG_STATE.LEAF_DIVE)
			break

		case UG_STATE.LEAF_DIVE:
			if !instance_exists(leaf_id)
			{
				set_state(UG_STATE.SLEEP)
				break
			}
			move_towards_point(leaf_target_x, leaf_target_y, 2)
			//Flip over on the way into the pile
			rotation=abs(((jump_target_x-leaf_target_x)-(x-leaf_target_x))/(jump_target_x-leaf_target_x))*180
			if distance_to_point(leaf_target_x, leaf_target_y)<3
			{
				leaf_id.explode=1
				audio_play_sound(snd_effect_leaf_crunch, 1, false)

				//Anyone already napping in this pile gets launched out
				var pile = leaf_id
				with(obj_unusedGloop)
				{
					if id<>other.id and in_leaf_pile=pile
						launch_from_pile()
				}

				//Take a nap in the leaves
				set_state(UG_STATE.SLEEP)
				x=leaf_id.x+15
				y=leaf_id.y+13
				in_leaf_pile=pile
			}
			break

		case UG_STATE.LAUNCHED:
			var t = min(state_time/launch_flight_time, 1)
			if t<1
			{
				//Arc through the air, spinning
				x = lerp(launch_start_x, launch_target_x, t)
				y = lerp(launch_start_y, launch_target_y, t) - sin(t*pi)*launch_arc_height
				rotation = (rotation + launch_spin_speed) mod 360
			}
			else
			{
				//Landed.  Sit there dizzy for a bit, then doze off
				x=launch_target_x
				y=launch_target_y
				rotation=0
				if state_time>launch_flight_time+launch_dizzy_time
					set_state(UG_STATE.SLEEP)
			}
			break

		case UG_STATE.GO_HOME:
			move_towards_point(home_x, home_y, 1)
			if distance_to_point(home_x, home_y)<4
			{
				x=home_x
				y=home_y
				set_state(UG_STATE.HOME)
			}
			break

		case UG_STATE.HOME:
			image_alpha-=0.05
			break

		case UG_STATE.GAME_OVER:
			break
	}
}


/// Rolls the dice on each wake activity.  Returns the state to start, or -1 to keep napping
pick_wake_activity = function(include_idle = true)
{
	for (var i = 0; i < array_length(wake_activities); i++)
	{
		var activity = wake_activities[i]
		if activity.idle_anim and (!include_idle or in_leaf_pile<>noone or rest_time<activity.min_rest)
			continue
		//Daytime-only activities stop once the day's goal is far enough along
		if variable_struct_exists(activity, "max_progress") and scr_day_progress()>=activity.max_progress
			continue
		if sleep_time>activity.min_sleep and activity.allowed() and random(1)<activity.odds
			return activity.state
	}
	return -1
}


/// Play the snow falling off, then switch to after_state
shake_off_snow = function(after_state)
{
	next_state=after_state
	if state<>UG_STATE.SNOW_SHAKE
		set_state(UG_STATE.SNOW_SHAKE)
}


//---- Snowball fight ----

/// True while in a snowball fight (walking to its spot or throwing)
is_fighting = function()
{
	return state=UG_STATE.FIGHT_WALK or state=UG_STATE.FIGHT
}

/// The other fighter is still around and still fighting this slime
fight_partner_ok = function()
{
	return instance_exists(fight_partner) and fight_partner.fight_partner=id
		and (fight_partner.state=UG_STATE.FIGHT_WALK or fight_partner.state=UG_STATE.FIGHT)
}

/// Throws a snowball straight at the other fighter, with a little wobble so some miss
throw_snowball = function()
{
	var start_x = x+16
	var start_y = y+16 + fight_dir*18
	var target_x = fight_partner.x+16
	var target_y = fight_partner.y+16
	var steps = max(1, abs(target_y-start_y)/snowball_speed)

	var ball = instance_create_layer(start_x, start_y, "Instances", obj_effectSnowball)
	ball.thrower = id
	ball.target = fight_partner
	ball.yy = snowball_speed*fight_dir
	ball.xx = (target_x-start_x)/steps + random_range(-aim_wobble, aim_wobble)
	ball.despawnTimer = steps*2 //Misses fly on past for a bit, then melt
}

/// Snowballs from this fight still in the air
snowballs_flying = function()
{
	var me = id
	var partner = fight_partner
	var flying = false
	with(obj_effectSnowball)
		if thrower=me or thrower=partner
			flying = true
	return flying
}

/// Got hit by a snowball
snowball_hit = function()
{
	fight_hits++
	hit_timer=20
	shake(2)
}

/// Both are out of snowballs.  Whoever got hit less smiles, the other is annoyed.  Then both go back to napping
finish_fight = function()
{
	var partner = fight_partner
	var my_hits = fight_hits
	var their_hits = partner.fight_hits

	//Clear the partners first so set_state doesn't try to stop the fight a second time
	fight_partner=noone
	partner.fight_partner=noone
	set_state(UG_STATE.SLEEP)
	with(partner)
		set_state(UG_STATE.SLEEP)

	if my_hits<=their_hits
		happy_timer=90
	else
		angry_timer=60
	if their_hits<=my_hits
		partner.happy_timer=90
	else
		partner.angry_timer=60
}


/// True while covered in snow or shaking it off
is_snowy = function()
{
	return state=UG_STATE.SNOWED or state=UG_STATE.SNOW_SHAKE
}


/// Frames to advance Spr_Slm_Snowball each step, at the sprite's own playback speed
snow_anim_speed = function()
{
	return sprite_get_speed(Spr_Slm_Snowball) / game_get_speed(gamespeed_fps)
}


/// Moods count down no matter what the slime is doing
step_moods = function()
{
	if happy_timer>0
		happy_timer--
	if angry_timer>0
	{
		angry_timer--
		if angry_timer>60
			shake(2)
	}
}


/// Which sprite to show.  Returns [sprite, frame].  A frame of -1 means play the animation
/// Idle animations also return [sprite, frame, off_x, off_y, wide] so Draw can line them up (wide = sprite sticks out to the right)
get_look = function()
{
	//States with their own face
	switch(state)
	{
		case UG_STATE.GAME_OVER: return [Slm_All_Base_Expressions, UG_FACE.SAD]
		case UG_STATE.GO_HOME:   return [Spr_Slm_Move_Jump, -1]
		case UG_STATE.HOME:      return [Slm_All_Base_Expressions, UG_FACE.HAPPY]
		case UG_STATE.LEAF_DIVE: return [Slm_All_Base_Expressions, UG_FACE.HAPPY]
		case UG_STATE.LAUNCHED:  return [Slm_All_Base_Expressions, UG_FACE.DIZZY]
		case UG_STATE.SNOWED:
		case UG_STATE.SNOW_SHAKE: return [Spr_Slm_Snowball, floor(snow_frame)]
		case UG_STATE.FIGHT_WALK: return [Spr_Slm_Move_Jump, -1]
		case UG_STATE.FIGHT:
			if hit_timer>0
				return [Slm_All_Base_Expressions, UG_FACE.DIZZY]
			//Wind-up before a throw: Spr_Slm_Move_Roll played backwards, fast (like obj_test_slimebrawl's image_speed=-3)
			var windup_left = fight_throw_every-fight_throw_timer
			if fight_throws_left>0 and windup_left<=fight_windup
			{
				var roll_frames = sprite_get_number(Spr_Slm_Move_Roll)
				var played = (fight_windup-windup_left) * 3*sprite_get_speed(Spr_Slm_Move_Roll)/game_get_speed(gamespeed_fps)
				return [Spr_Slm_Move_Roll, (roll_frames-1) - (floor(played) mod roll_frames)]
			}
			return [Spr_Slm_Idol, -1]
	}

	//Moods
	if happy_timer>0         return [Slm_All_Base_Expressions, UG_FACE.HAPPY]
	if angry_timer>60        return [Slm_All_Base_Expressions, UG_FACE.ANGRY]
	if angry_timer>0         return [Slm_All_Base_Expressions, UG_FACE.ANNOYED]
	if state=UG_STATE.SAD    return [Slm_All_Base_Expressions, UG_FACE.SAD]

	var idle = get_idle_look(state)
	if idle<>undefined
		return [idle.sprite, floor(anim_frame) mod sprite_get_number(idle.sprite), idle.off_x, idle.off_y, sprite_get_width(idle.sprite)>sprite_get_width(Spr_Slm_Sleep)]

	if state=UG_STATE.SLEEP  return [Spr_Slm_Sleep, -1]
	return [Spr_Slm_Move_Jump, -1]
}


/// True while walking somewhere on purpose.  Other slimes don't push it around
is_busy = function()
{
	return state=UG_STATE.LEAF_WALK or state=UG_STATE.LEAF_DIVE or state=UG_STATE.LAUNCHED
		or state=UG_STATE.GO_HOME or state=UG_STATE.HOME
		or state=UG_STATE.FIGHT_WALK or state=UG_STATE.FIGHT
}


/// Get knocked out of the leaf pile to a random spot higher up the sideline
launch_from_pile = function()
{
	launch_start_x=x
	launch_start_y=y
	launch_target_x=random_range(left_boundry, right_boundry-sprite_get_width(Spr_Slm_Sleep))
	launch_target_y=random_range(top_boundry, max(top_boundry, y-60))
	set_state(UG_STATE.LAUNCHED)
}


shake = function(amount)
{
	x += random_range(-amount, amount)
	y += random_range(-amount, amount)
}


//---- Called by other objects ----

/// Cursor touched the slime (Mouse Enter)
touched_cursor = function()
{
	if state<>UG_STATE.CHASE
		return;
	var inst = instance_create_layer(x+16, y, "Instances", obj_effect_heart)
	inst.depth=depth-1
	set_state(UG_STATE.SLEEP)
	happy_timer=60 //Smiles for a moment before dozing off
}

/// Player dragged a point onto the slime.  Returns false if it can't eat right now
feed = function()
{
	if state=UG_STATE.GO_HOME or state=UG_STATE.HOME
		return false
	happy_timer+=60
	speed=0
	//Food cheers it up
	if state=UG_STATE.SAD or state=UG_STATE.GAME_OVER
		set_state(UG_STATE.SLEEP)
	//Wakes it up enough to shake the snow off
	else if is_snowy()
		shake_off_snow(UG_STATE.SLEEP)
	return true
}

/// Day is over.  Hop to the house at hx,hy
go_home = function(hx, hy)
{
	home_x=hx
	home_y=hy
	if is_snowy()
		shake_off_snow(UG_STATE.GO_HOME)
	else
		set_state(UG_STATE.GO_HOME)
}

/// New day.  Reappear at nx,ny fast asleep
new_day = function(nx, ny)
{
	x=nx
	y=ny
	image_alpha=1
	happy_timer=0
	angry_timer=0
	clicks_while_sleeping=0
	set_state(UG_STATE.SLEEP)
}

/// Game lost
game_over = function()
{
	set_state(UG_STATE.GAME_OVER)
}
