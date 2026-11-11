state_time++
anim += 8/game_get_speed(gamespeed_fps) //The slime sprites play at 8 frames a second

switch (state)
{
	case "dive": //Under the water, just ripples
		if state_time>=state_length
			set_state("peek")
		break

	case "peek": //Head poking out of the water
		if state_time>=state_length
		{
			if pick_target()
			{
				jump_x0 = x
				jump_y0 = y
				if abs(jump_x1-x)>1
					facing = sign(jump_x1-x)
				set_state("jump")
				splash(x, y) //Leaps out
			}
			else
				set_state("dive") //Nowhere to go: try again later
		}
		break

	case "jump": //Out of the water in an arc
		var k = min(1, state_time/jump_frames)
		x = lerp(jump_x0, jump_x1, k)
		y = lerp(jump_y0, jump_y1, k)
		if k>=1
		{
			splash(x, y) //Lands
			set_state("dive")
		}
		break
}

//Splashes play through once, then go away
for (var i = array_length(splashes)-1; i >= 0; i--)
{
	splashes[i].frame += 0.25
	if splashes[i].frame>=sprite_get_number(Spr_Ripple)
	{
		layer_sprite_destroy(splashes[i].el)
		array_delete(splashes, i, 1)
	}
	else
		layer_sprite_index(splashes[i].el, floor(splashes[i].frame))
}
