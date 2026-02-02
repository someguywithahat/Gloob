if global.weather<>2
{
	if weather_alpha>0
		weather_alpha-=0.01
}

if global.weather<>1
{
	if snow_alpha>0
		snow_alpha-=0.01
}

if global.weather=1
{
	for(var s=0;s<snow_density;s++){
		var snowid = instance_create_layer(irandom_range(1-(wind_max*50),room_width), irandom_range(1-200,room_height),"Instances",obj_weather_snowflake)
		snowid.depth=depth-1
	}
	if snow_alpha<=0.25
		snow_alpha+=0.005
}
else if global.weather=2
{	
	for(var s=0;s<rain_density;s++){
		var rainid = instance_create_layer(irandom_range(1-10,room_width), irandom_range(1-200,room_height),"Instances",obj_weather_rain)
		rainid.depth=depth-1
	}
	if weather_alpha<0.2
		weather_alpha+=0.005
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
		weather_sound=audio_play_sound(snd_weather_wind_during_snow, 0, true);
	}
	else
	{
		global.weather=0
		audio_stop_sound(weather_sound)		
	}
}
else if toggle_rain>0{
	audio_stop_sound(weather_sound)		
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
		weather_sound=audio_play_sound(snd_weather_wind, 0, true);
	}
	else
	{
		global.weather=0	
	}
}

if toggle_add_obs>0{
	toggle_add_obs=0
	var spawnObs = irandom_range(1,100)
	if spawnObs>95
		scr_setup_add_obstacle(controller.grid_refs,3,3)
	else if spawnObs>=75
		scr_setup_add_obstacle(controller.grid_refs,2,2)
	else if spawnObs>=55
		scr_setup_add_obstacle(controller.grid_refs,1,2)
	else if spawnObs>=35
		scr_setup_add_obstacle(controller.grid_refs,2,1)
	else if spawnObs>=0
		scr_setup_add_obstacle(controller.grid_refs,1,1)
}




if toggle_night=1 {
	audio_play_sound(snd_sleep_jingle, 0, false);
	toggle_night=0
	show_debug_message("Refreshing Grid")
	isNight=1
}

if controller.season_goal<1 and isNight=0
{
	if isNightShader<0.1
		isNightShader+=0.001
}

if isNight=1{
	isNightShader+=0.01	
	if isNightShader>=1{
		isNight=-1
		scr_refresh_grid(controller.grid_refs)
		controller.season_goal_percentage+=0.05
		controller.season_goal = round(controller.grid_size*controller.season_goal_percentage)
		
		
		repeat (3)
		{
			var spawnObs = irandom_range(1,100)
			if spawnObs>95
				scr_setup_add_obstacle(controller.grid_refs,3,3)
			else if spawnObs>=75
				scr_setup_add_obstacle(controller.grid_refs,2,2)
			else if spawnObs>=55
				scr_setup_add_obstacle(controller.grid_refs,1,2)
			else if spawnObs>=35
				scr_setup_add_obstacle(controller.grid_refs,2,1)
			else if spawnObs>=0
				scr_setup_add_obstacle(controller.grid_refs,1,1)
		}
		
		audio_stop_sound(weather_sound)	
		if global.weather=global.SUMMER
		{
			global.weather=global.FALL
			weather_sound=audio_play_sound(snd_weather_wind, 0, true);
		}
		else if global.weather=global.FALL
		{
			global.weather=global.WINTER
			weather_sound=audio_play_sound(snd_weather_wind_during_snow, 0, true);
		}
		else if global.weather=global.WINTER
		{
			global.weather=global.SPRING
			weather_sound=audio_play_sound(snd_rain, 0, true);
		}
		else if global.weather=global.SPRING
		{
			global.weather=global.SUMMER
			weather_sound=audio_play_sound(snd_rain, 0, true);
		}
	}
}
if isNight=-1{
	isNightShader-=0.01
	if isNightShader<=0{
		isNight=-1
		isNightShader=0
		isNight=0
	}
}