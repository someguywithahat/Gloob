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
	GO_HOME,    //Day is over: hopping to the house
	HOME,       //Made it to the house: fading out
	GAME_OVER   //Game lost: sad until fed
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


/*
	Things a sleeping slime can wake up and do.  Checked in order every step.
		odds      -- chance per step of starting
		min_sleep -- steps it has to nap first
		allowed   -- extra conditions, like the season
*/
wake_activities = [
	{
		name: "chase cursor",
		odds: 4/100000,
		min_sleep: 1000,
		state: UG_STATE.CHASE,
		allowed: function() { return true }
	},
	{
		name: "leaf pile",
		odds: 4/10000,
		min_sleep: 300,
		state: UG_STATE.LEAF_WALK,
		allowed: function() { return global.weather=global.FALL and instance_exists(obj_effectLeafPile) }
	},
	{
		name: "snowed on",
		odds: 1/300,
		min_sleep: 900,
		state: UG_STATE.SNOWED,
		allowed: function() { return global.weather=global.WINTER }
	}
]


/// Switch to a new state and do any setup it needs
set_state = function(new_state)
{
	state=new_state
	state_time=0
	speed=0
	rotation=0
	in_leaf_pile=noone

	switch(state)
	{
		case UG_STATE.SLEEP:
			sleep_time=0
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
			var wake_state = pick_wake_activity()
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
pick_wake_activity = function()
{
	for (var i = 0; i < array_length(wake_activities); i++)
	{
		var activity = wake_activities[i]
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
	}

	//Moods
	if happy_timer>0         return [Slm_All_Base_Expressions, UG_FACE.HAPPY]
	if angry_timer>60        return [Slm_All_Base_Expressions, UG_FACE.ANGRY]
	if angry_timer>0         return [Slm_All_Base_Expressions, UG_FACE.ANNOYED]
	if state=UG_STATE.SAD    return [Slm_All_Base_Expressions, UG_FACE.SAD]

	if state=UG_STATE.SLEEP  return [Spr_Slm_Sleep, -1]
	return [Spr_Slm_Move_Jump, -1]
}


/// True while walking somewhere on purpose.  Other slimes don't push it around
is_busy = function()
{
	return state=UG_STATE.LEAF_WALK or state=UG_STATE.LEAF_DIVE or state=UG_STATE.LAUNCHED
		or state=UG_STATE.GO_HOME or state=UG_STATE.HOME
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
