//New drops all over the room.  Each one falls a bit, then splashes (obj_weather_rain)
repeat (rain_density)
{
	var drop = instance_create_layer(irandom_range(-9, room_width), irandom_range(-199, room_height), "Instances", obj_weather_rain)
	drop.depth = depth-1
}

if dim_alpha<rain_dim
	dim_alpha = min(rain_dim, dim_alpha+0.005)
