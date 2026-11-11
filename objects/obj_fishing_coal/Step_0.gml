state_time++
anim += 8/game_get_speed(gamespeed_fps) //The slime sprites play at 8 frames a second

switch (state)
{
	case "sleep":
		//Dozes off (frames 0-20), then loops the snoring part (20-50), like the sideline slimes
		if anim>50
			anim = 20
		glow = 0
		//Clicked with the boat right next to him: wake up
		var boat = instance_find(obj_gloopFishing, 0)
		var boat_near = boat<>noone and point_distance(boat.center_x(), boat.center_y(), mid_x(), mid_y())<=near_distance
		if mouse_check_button_pressed(mb_left) and position_meeting(mouse_x, mouse_y, id) and boat_near
		{
			set_state("wake")
			audio_play_sound(snd_slm_wakeup2, 1, false)
		}
		break

	case "wake":
		if state_time>=wake_frames
			set_state("glow")
		break

	case "glow":
		//Brighter and brighter
		glow = min(1, state_time/glow_frames)
		if state_time>=glow_frames
			set_state("hold")
		break

	case "hold":
		glow = 1
		if state_time>=hold_frames
		{
			set_state("surprised")
			audio_play_sound(snd_slm_confused, 1, false)
		}
		break

	case "surprised":
		//"Whoa!"  Pulls the light back in, quickly at first
		var k = min(1, state_time/surprised_frames)
		glow = (1-k)*(1-k)
		if state_time>=surprised_frames
		{
			glow = 0
			set_state("sleep")
			audio_play_sound(snd_yawn, 1, false)
		}
		break
}
