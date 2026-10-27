//Round over: show the result for a moment, then close
if result<>0
{
	end_timer++
	shadow_amount = max(shadow_amount - 1/shadow_fade, 0) //Coal's lights come back on
	if end_timer>end_time
	{
		if surface_exists(pond_light_surf)
			surface_free(pond_light_surf)
		instance_destroy()
	}
	exit
}


//---- Circle: chase the mouse, speeding up and slowing down gradually ----
var want_vx = clamp((mouse_x-circle_x)*circle_follow, -circle_max_speed, circle_max_speed)
var want_vy = clamp((mouse_y-circle_y)*circle_follow, -circle_max_speed, circle_max_speed)
//Hooked by a fishing line (Poled): the circle fights for control with half its usual acceleration
var accel = circle_hooked ? circle_accel*0.5 : circle_accel
circle_vx += clamp(want_vx-circle_vx, -accel, accel)
circle_vy += clamp(want_vy-circle_vy, -accel, accel)
circle_x += circle_vx
circle_y += circle_vy
//Wind gusts (Gail) gently push the circle left or right, but only while the player isn't steering it sideways
if abs(circle_vx)<0.3
	circle_x += wind_amount*wind_push
//A fishing line (Poled) drags a hooked circle toward its edge
circle_x += hook_pull_x
circle_y += hook_pull_y
//A whirlpool (Bowl) carries the circle around
circle_x += whirl_push_x
circle_y += whirl_push_y

//Ice walls (Cold) block the circle
if fish.move=FISH_MOVE.ICE_WALLS
	ice_push_circle()

//Stay inside the pond
var circle_min_x = box_x+circle_radius
var circle_max_x = box_x+box_size-circle_radius
var circle_min_y = box_y+circle_radius
var circle_max_y = box_y+box_size-circle_radius
if circle_x<circle_min_x or circle_x>circle_max_x
{
	circle_x = clamp(circle_x, circle_min_x, circle_max_x)
	circle_vx = 0
}
if circle_y<circle_min_y or circle_y>circle_max_y
{
	circle_y = clamp(circle_y, circle_min_y, circle_max_y)
	circle_vy = 0
}


//---- Fish ----
swim(fish) //Movement depends on the fish's type (see the swim functions in Create)
fish.x += fish.vx
fish.y += fish.vy

//Bounce off the sides of the pond (softly for most fish, hard for a flying golf fish)
//(a bowling fish rolling through the pins skips this so it can roll out the top)
if !fish.no_walls
{
	var half_fish = sprite_get_width(fish.sprite)*max(fish.scale, 1)/2 //Bigger when drawn bigger (fat Grow)
	if fish.x<box_x+half_fish or fish.x>box_x+box_size-half_fish
	{
		fish.x = clamp(fish.x, box_x+half_fish, box_x+box_size-half_fish)
		fish.vx *= -fish.bounce
	}
	if fish.y<box_y+half_fish or fish.y>box_y+box_size-half_fish
	{
		fish.y = clamp(fish.y, box_y+half_fish, box_y+box_size-half_fish)
		fish.vy *= -fish.bounce
	}
}

//Face the way it's moving, unless the swim function locked its facing (wall jump)
if fish.face_lock<>0
	fish.facing = fish.face_lock
else if abs(fish.vx)>0.3
	fish.facing = sign(fish.vx)
if !fish.manual_frame
	fish.frame += sprite_get_speed(fish.sprite)/game_get_speed(gamespeed_fps)


//---- Green bar: grows while the fish is in the circle, shrinks while it isn't ----
//A fish hiding underground (Holed) can't be caught, and the bar holds still until it comes back out
var fish_inside = point_distance(fish.x, fish.y, circle_x, circle_y)<=circle_radius
//Most fish are caught by keeping them in the circle.  A stick-to-circle fish (Fools) is backwards: keep it out
if fish.move=FISH_MOVE.STICK_TO_CIRCLE
	catching = !fish.hidden and !fish_inside
else
	catching = !fish.hidden and fish_inside
if catching
	bar_fill += bar_grow*bar_grow_mult //Slower with embers (Scald) in the circle
else if !fish.hidden
	bar_fill -= bar_shrink
bar_fill = clamp(bar_fill, 0, 1)

if bar_fill>=1
{
	result = 1
	audio_play_sound(snd_slm_yay, 1, false)
	scr_fish_mark_caught(fish.name) //Opens its trophy clam
	if instance_exists(source_fish)
		instance_destroy(source_fish)
}
else if bar_fill<=0
{
	result = -1
	audio_play_sound(snd_slm_confused, 1, false)
}
