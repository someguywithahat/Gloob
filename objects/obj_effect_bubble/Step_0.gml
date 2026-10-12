//Popping: play the pop, then go away
if phase=BUBBLE_PHASE.POP
{
	just_popped=false
	frame+=anim_speed
	if frame>=sprite_get_number(Spr_Pu_Bubble)
		instance_destroy()
	exit
}

//Appear, then loop the floating wobble
frame+=anim_speed
if phase=BUBBLE_PHASE.APPEAR and frame>=8
	phase=BUBBLE_PHASE.FLOAT
if phase=BUBBLE_PHASE.FLOAT and frame>=35
	frame=8

if mouse_check_button_pressed(mb_left) and can_pop_at_mouse()
{
	audio_play_sound(snd_slm_chomp, 1, false)
	pop()
	exit
}


x+=xx
y+=yy

//Bounce off the edges of the grid
var r = current_radius()
var bounced_x = false
var bounced_y = false
if x+r>grid_right
{
	x=grid_right-r
	xx=-abs(xx)
	bounced_x = true
}
if x-r<grid_left
{
	x=grid_left+r
	xx=abs(xx)
	bounced_x = true
}
if y+r>grid_bottom
{
	y=grid_bottom-r
	yy=-abs(yy)
	bounced_y = true
}
if y-r<grid_top
{
	y=grid_top+r
	yy=abs(yy)
	bounced_y = true
}

//Hit a corner: close to the other edge while bouncing off one
if corner_cooldown>0
	corner_cooldown--
else if bounced_x or bounced_y
{
	var near_x = x-r-grid_left<=corner_distance or grid_right-(x+r)<=corner_distance
	var near_y = y-r-grid_top<=corner_distance or grid_bottom-(y+r)<=corner_distance
	if near_x and near_y
	{
		bubble_scale+=corner_scale_up
		pop_radius+=1
		corner_cooldown=30
		//Keep the bigger bubble inside the grid
		r = current_radius()
		x = clamp(x, grid_left+r, grid_right-r)
		y = clamp(y, grid_top+r, grid_bottom-r)
	}
}
