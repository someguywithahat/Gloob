
if parent_gloop <> noone{
	xx=parent_gloop.x+(parent_gloop.sprite_width/2)
	yy=parent_gloop.y+(parent_gloop.sprite_height/2)
	
	var fx=x+(sprite_width/2)
	var fy=y+(sprite_height/2)
	
	if distance_to_object(parent_gloop)>5
		move_towards_point(xx,yy,2)
	else
		speed=0
		
	//One fairy per fairy powerup the slime still has.  Extras (used, lost, or pushed out of a full slot) go away.
	//Counting instead of watching one slot, since slots shift forward when they're full
	var gloop = parent_gloop
	var fairies_held = scr_powerup_count(gloop, global.BLUE)
	var my_rank = 0 //How many of this slime's fairies came before me
	with(obj_effect_fairy)
		if parent_gloop=gloop and id<other.id
			my_rank++
	if my_rank>=fairies_held
	{
		show_debug_message("using powerup")
		instance_destroy()
	}
	
}


