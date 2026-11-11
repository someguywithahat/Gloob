state_time++
anim += 8/game_get_speed(gamespeed_fps) //The slime sprites play at 8 frames a second

//---- Mallow and the marshmallows (secret): comes after one you drag near her, eats it if it touches her ----
if loves_marshmallows and (state="dive" or state="peek" or state="chase")
{
	var snack = (variable_global_exists("dragging_snack") and instance_exists(global.dragging_snack)) ? global.dragging_snack : noone
	if snack<>noone and point_distance(snack.mid_x(), snack.mid_y(), x, y-12)<=eat_range
	{
		//Nom!
		snack.eat()
		audio_play_sound(snd_slm_chomp, 1, false)
		set_state("happy")
	}
	else if snack<>noone and state<>"chase" and point_distance(snack.mid_x(), snack.mid_y(), x, y)<=lure_range
		set_state("chase")
	else if state="chase" and (snack=noone or point_distance(snack.mid_x(), snack.mid_y(), x, y)>lose_range)
		set_state("peek")
}

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

	case "happy": //Just ate a marshmallow
		if state_time>=state_length
			set_state("peek")
		break

	case "chase": //Swimming after the marshmallow, head up
		var snack_c = global.dragging_snack
		if !instance_exists(snack_c) or !instance_exists(area)
			break
		var dist = point_distance(x, y, snack_c.mid_x(), snack_c.mid_y())
		var dir = point_direction(x, y, snack_c.mid_x(), snack_c.mid_y())
		var move_amount = min(chase_speed, dist)
		var nx = x + lengthdir_x(move_amount, dir)
		var ny = y + lengthdir_y(move_amount, dir)
		if abs(nx-x)>0.2
			facing = sign(nx-x)
		//The sides and top of the area are shore
		nx = clamp(nx, area.bbox_left+edge_margin, area.bbox_right-edge_margin)
		ny = max(ny, area.bbox_top+edge_margin)
		//Past the bottom edge: over the falls (if there's water below to land in)
		if ny>area.bbox_bottom
		{
			var land_y = area.bbox_bottom + waterfall_drop
			if !position_meeting(nx, land_y, obj_gloopFishingWall) and land_y<room_height-8
			{
				x = nx
				state = "fall"
				state_time = 0
				fall_vy = 0.5
				fall_angle = 0
				fall_spin = random_range(-fall_spin_max, fall_spin_max)*0.5
				fall_land_y = land_y
				splash(x, area.bbox_bottom)
				audio_play_sound(snd_slm_woo, 1, false)
				break
			}
			ny = area.bbox_bottom
		}
		if !position_meeting(nx, ny, obj_gloopFishingWall)
		{
			x = nx
			y = ny
		}
		break

	case "fall": //Tumbling down the waterfall
		fall_vy += fall_gravity
		y += fall_vy
		fall_spin = clamp(fall_spin + random_range(-fall_spin_change, fall_spin_change), -fall_spin_max, fall_spin_max)
		fall_angle += fall_spin
		if y>=fall_land_y
		{
			//Splash!  Down under the water now, with the fish
			y = fall_land_y
			fall_angle = 0
			splash(x, y)
			set_state("sunk")
			var fish_layer = layer_get_id("Instances_Underwater")
			if fish_layer<>-1
				depth = layer_get_depth(fish_layer)-1
		}
		break

	case "sunk": //Under the water in the lake, angry.  Click her to catch her (free)
		var boat = instance_find(obj_gloopFishing, 0)
		in_range = boat<>noone and point_distance(x, y-14, boat.center_x(), boat.center_y())<=catch_range
		hovered = !instance_exists(obj_fishing_minigame) and point_in_rectangle(mouse_x, mouse_y, x-14, y-28, x+14, y)
		if hovered and in_range and mouse_check_button_pressed(mb_left)
		{
			global.fishing_test_fish = mallow_fish //obj_fishing_minigame picks this up
			var game = instance_create_depth(0, 0, -15000, obj_fishing_minigame)
			game.source_fish = id //Calls caught_in_minigame if she's caught
			hovered = false
		}
		break

	case "trophy": //In the bowl in the clam on the grass, angry
		//Waits for the minigame to close first, like the trophy clams
		if instance_exists(obj_fishing_minigame)
		{
			state_time = 0
			break
		}
		if state_time=1
			audio_play_sound(snd_achievement, 1, false)
		var last = sprite_get_number(Spr_Shell)-1
		if shell_frame<last
			shell_frame = min(last, shell_frame + trophy_open_speed*sprite_get_speed(Spr_Shell)/game_get_speed(gamespeed_fps))
		else if state_time>=trophy_show
		{
			//Out of the bowl and back into the water up top
			jump_x0 = shell_x
			jump_y0 = trophy_bowl_base()
			if !pick_trophy_target()
			{
				jump_x1 = (area.bbox_left+area.bbox_right)/2
				jump_y1 = (area.bbox_top+area.bbox_bottom)/2
			}
			facing = sign(jump_x1-jump_x0)
			if facing=0
				facing = -1
			set_state("trophy_jump")
			audio_play_sound(snd_slm_grrrrr, 1, false)
		}
		break

	case "trophy_jump":
		var tk = min(1, state_time/trophy_jump_frames)
		x = lerp(jump_x0, jump_x1, tk)
		y = lerp(jump_y0, jump_y1, tk)
		if tk>=1
		{
			splash(x, y)
			set_state("dive")
		}
		break
}

//The trophy clam fades away once she's out of it
if state<>"trophy" and shell_alpha>0
	shell_alpha = max(0, shell_alpha-trophy_fade)

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
