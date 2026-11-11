//Heavier or lighter, easing toward boost_target (obj_fishing_dewdrop)
boost += clamp(boost_target-boost, -boost_ease, boost_ease)
var drop_speed = lerp(1, boost_speed, boost)
if boost>0 or boost_target>0 //(Otherwise leave the volume alone, so the fade in when you enter the room still plays)
	audio_sound_gain(rain_sound, rain_volume*lerp(1, boost_volume, boost), 0)

//New drops all over the room.  Each one falls a bit, then splashes (obj_weather_rain)
repeat (round(rain_density*lerp(1, boost_density, boost)))
{
	var drop = instance_create_layer(irandom_range(-9, room_width), irandom_range(-199, room_height), "Instances", obj_weather_rain)
	drop.depth = depth-1
	drop.xx *= drop_speed
	drop.yy *= drop_speed
}

if dim_alpha<rain_dim
	dim_alpha = min(rain_dim, dim_alpha+0.005)
