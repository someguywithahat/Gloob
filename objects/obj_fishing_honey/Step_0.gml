state_time++
anim += 8/game_get_speed(gamespeed_fps)
var boat = instance_find(obj_gloopFishing, 0)

switch (state)
{
	case "sleep":
		//Asleep: loops the snoring part of the sleep animation (frames 20-50), like the sideline slimes
		if anim>50
			anim = 20
		if boat=noone
			break

		//Gloop sails past: a heart above his head
		var dist = point_distance(boat.center_x(), boat.center_y(), x+16, y+20)
		if armed and dist<=pass_distance and boat.dock_state=0
		{
			armed = false
			//Over the slime in the boat (spr_boat_test flips with the boat).  The heart is 16x16, top left origin
			var head_x = (boat.facing>0) ? boat.x+boat.slime_in_boat_x+16 : boat.x+boat.sprite_width-boat.slime_in_boat_x-16
			var head_y = boat.y+boat.slime_in_boat_y+8 //Top of his body
			var heart = instance_create_layer(head_x-8, head_y-20, "Instances", obj_effect_heart)
			heart.depth = boat.depth-1
		}
		else if !armed and dist>=rearm_distance
			armed = true

		//The boat bumps into her: she sticks to it!
		if boat.dock_state=0 and boat.bbox_right>=x+4 and boat.bbox_left<=x+28 and boat.bbox_bottom>=y+10 and boat.bbox_top<=y+31
		{
			set_state("stuck")
			depth = boat.depth-1
			audio_play_sound(snd_slime_move, 1, false) //Splat!
		}
		break

	case "stuck": //Clinging to the front of the boat, surprised
		if boat=noone
		{
			set_state("sleep")
			break
		}
		x = cling_x(boat)
		y = cling_y(boat)
		depth = boat.depth-1
		//The boat bumps the log: everybody off!
		var log_inst = instance_nearest(x, y, obj_fishing_log)
		if log_inst<>noone and boat.dock_state=0 and log_inst.boat_hits(boat)
		{
			the_log = log_inst
			hop_x0 = x
			hop_y0 = y
			hop_x1 = log_inst.honey_seat_x()-16
			hop_y1 = log_inst.seat_y()-32
			set_state("hop")
			depth = log_inst.depth-1
			boat.start_log(log_inst)
		}
		break

	case "hop": //Onto the log
		var k = min(1, state_time/hop_frames)
		x = lerp(hop_x0, hop_x1, k)
		y = lerp(hop_y0, hop_y1, k) - hop_height*4*k*(1-k)
		if k>=1
			set_state("sit")
		break

	case "sit": //On the log next to Gloop: hearts in her eyes as she lands (and one heart), then just idling
		if state_time=1
			instance_create_depth(x+8, y-4, depth-1, obj_effect_heart)
		//Gloop went back to the boat: she dozes off right here on the log
		if boat=noone or boat.dock_state<>4
		{
			set_state("sleep")
			anim = 0
			armed = false
		}
		break
}
