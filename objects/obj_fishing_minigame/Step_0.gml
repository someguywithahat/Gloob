//Round over: show the result for a moment, then close
if result<>0
{
	end_timer++
	if end_timer>end_time
		instance_destroy()
	exit
}


//---- Circle: chase the mouse, speeding up and slowing down gradually ----
var want_vx = clamp((mouse_x-circle_x)*circle_follow, -circle_max_speed, circle_max_speed)
var want_vy = clamp((mouse_y-circle_y)*circle_follow, -circle_max_speed, circle_max_speed)
circle_vx += clamp(want_vx-circle_vx, -circle_accel, circle_accel)
circle_vy += clamp(want_vy-circle_vy, -circle_accel, circle_accel)
circle_x += circle_vx
circle_y += circle_vy

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
fish.swim(fish)
fish.x += fish.vx
fish.y += fish.vy

//Bounce softly off the sides of the pond
var half_fish = sprite_get_width(fish.sprite)/2
if fish.x<box_x+half_fish or fish.x>box_x+box_size-half_fish
{
	fish.x = clamp(fish.x, box_x+half_fish, box_x+box_size-half_fish)
	fish.vx *= -0.5
}
if fish.y<box_y+half_fish or fish.y>box_y+box_size-half_fish
{
	fish.y = clamp(fish.y, box_y+half_fish, box_y+box_size-half_fish)
	fish.vy *= -0.5
}

if abs(fish.vx)>0.3
	fish.facing = sign(fish.vx)
fish.frame += sprite_get_speed(fish.sprite)/game_get_speed(gamespeed_fps)


//---- Green bar: grows while the fish is in the circle, shrinks while it isn't ----
fish_in_circle = point_distance(fish.x, fish.y, circle_x, circle_y)<=circle_radius
if fish_in_circle
	bar_fill += bar_grow
else
	bar_fill -= bar_shrink
bar_fill = clamp(bar_fill, 0, 1)

if bar_fill>=1
{
	result = 1
	audio_play_sound(snd_slm_yay, 1, false)
}
else if bar_fill<=0
{
	result = -1
	audio_play_sound(snd_slm_confused, 1, false)
}
