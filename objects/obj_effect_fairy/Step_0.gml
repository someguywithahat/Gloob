
if parent_gloop <> noone{
	xx=parent_gloop.x+(parent_gloop.sprite_width/2)
	yy=parent_gloop.y+(parent_gloop.sprite_height/2)
	
	var fx=x+(sprite_width/2)
	var fy=y+(sprite_height/2)
	
	if distance_to_object(parent_gloop)>5
		move_towards_point(xx,yy,2)
	else
		speed=0
		
	if (gloop_powerUp_check =1 and parent_gloop.powerUp1 <>2)
	or (gloop_powerUp_check =2 and parent_gloop.powerUp2 <>2)
	or (gloop_powerUp_check =3 and parent_gloop.powerUp3 <>2)
	{
		show_debug_message("using powerup")
		instance_destroy()
	}
	
}


