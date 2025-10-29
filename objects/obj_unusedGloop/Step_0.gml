if issleep=1
	sleep_duration++

if y<top_boundry
	y=y+2
	
if x>right_boundry
	x=x-2	
	
	
if irandom_range(1,100000)<3 and sleep_duration>1000{
	issleep=0
	sprite_index=Spr_Slm_Move_Up_Jump	
	sleep_counter=0
}
	
	
if issleep=0
{
	move_towards_point(mouse_x,mouse_y,1)	
	sleep_counter++
}
if sleep_counter>sleep_timer
{
	issleep=1
	sleep_duration=0
	sprite_index=Spr_Slm_Sleep
	speed=0
}