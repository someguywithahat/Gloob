if global.weather<>2
{
	if weather_alpha>0
		weather_alpha-=0.01
}

if global.weather=1
{
	for(var s=0;s<snow_density;s++){
		instance_create_layer(irandom_range(1-(wind_max*50),room_width), irandom_range(1-200,room_height),"Instances",obj_weather_snowflake)
	}
}
else if global.weather=2
{	
	for(var s=0;s<rain_density;s++){
		var rainid = instance_create_layer(irandom_range(1-10,room_width), irandom_range(1-200,room_height),"Instances",obj_weather_rain)
		rainid.depth=depth-1
	}
	if weather_alpha<0.2
		weather_alpha+=0.01
}
else if global.weather=3
{	
	var leaf_roll = irandom_range(1,100)
	if leaf_roll<leaf_chance{
		var leafid = instance_create_layer(irandom_range(-10,0), irandom_range(-400,room_height),"Instances",obj_weather_leaves)
		leafid.depth=depth-1
	}
	
	
}


if toggle_snow>0{
	audio_stop_sound(weather_sound)	
	toggle_snow=0
	if global.weather<>1
	{
		global.weather=1
	}
	else
	{
		global.weather=0
		audio_stop_sound(weather_sound)		
	}
}
else if toggle_rain>0{
	toggle_rain=0
	if global.weather<> 2
	{
		global.weather=2
		weather_sound=audio_play_sound(snd_rain, 0, true);
	}
	else
	{
		global.weather=0
		audio_stop_sound(weather_sound)		
	}
}
else if toggle_leaves>0{
	toggle_leaves=0
	audio_stop_sound(weather_sound)	
	if global.weather<> 3
	{
		global.weather=3
	}
	else
	{
		global.weather=0	
	}
}