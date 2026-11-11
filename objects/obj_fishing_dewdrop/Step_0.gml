state_time++
anim += 8/game_get_speed(gamespeed_fps) //The slime sprites play at 8 frames a second
if squish>0.01
	squish *= 0.85
else
	squish = 0

switch (state)
{
	case "sleep":
		//Dozes off (frames 0-20), then loops the snoring part (20-50), like the sideline slimes
		if anim>50
			anim = 20
		//Clicked with the boat close by: wakes up, ready for a drink
		var boat = instance_find(obj_gloopFishing, 0)
		var boat_near = boat<>noone and point_distance(boat.center_x(), boat.center_y(), feet_x, feet_y-16)<=near_distance
		if mouse_check_button_pressed(mb_left) and point_in_rectangle(mouse_x, mouse_y, feet_x-16, feet_y-32, feet_x+16, feet_y) and boat_near
		{
			set_state("wake")
			audio_play_sound(snd_slm_wakeup2, 1, false)
		}
		break

	case "wake": //Awake for a moment, then looks up at the rain
		if state_time>=wake_frames
		{
			set_state("open")
			set_rain(1)
		}
		break

	case "open": //Opening his mouth to the sky
		glow = min(1, state_time/30)
		if anim>=open_last_frame
			set_state("drink")
		break

	case "drink": //Mouth open, drinking the rain, growing
		glow = 1
		var k = min(1, state_time/drink_frames)
		size = lerp(1, grow_to, k*k*(3-2*k))
		//Raindrops falling right into his mouth.  obj_weather_rain falls 20 steps then splashes, so start it that far up
		if state_time mod mouth_drops_every=0
		{
			var rain = instance_find(obj_fishroom_rain, 0)
			var drop_speed = (rain<>noone) ? lerp(1, rain.boost_speed, rain.boost) : 1
			var drop = instance_create_layer(0, 0, "Instances", obj_weather_rain)
			drop.xx *= drop_speed
			drop.yy *= drop_speed
			drop.x = mouth_x() + random_range(-3, 3)*size - drop.xx*20
			drop.y = mouth_y() - drop.yy*20
			if rain<>noone
				drop.depth = rain.depth-1
		}
		//Gulp!
		if state_time mod gulp_every=0
			squish = 1
		if state_time>=drink_frames
		{
			set_state("close")
			set_rain(0)
			audio_play_sound(snd_slm_woo, 1, false) //All full!
		}
		break

	case "close": //All full.  The glow fades
		glow = 1 - min(1, state_time/close_frames)
		if state_time>=close_frames
		{
			glow = 0
			set_state("happy")
		}
		break

	case "happy":
		break
}
