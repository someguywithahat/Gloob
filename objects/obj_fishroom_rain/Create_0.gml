/*
	Rain for a fishing room (placed in rm_fishingLeft).  Same rain as spring in the main game
	(obj_weather_controller): obj_weather_rain drops, a slightly darker screen and the rain sound.
*/

//---- Settings ----
rain_density = 10   //Drops added each step
rain_dim = 0.2      //How much darker the room gets (0 to 1)
rain_volume = 0.6

depth = -1000 //Above the room, below the lighting
dim_alpha = 0 //Fades in

rain_sound = audio_play_sound(snd_rain, 0, true)
audio_sound_gain(rain_sound, 0, 0)
audio_sound_gain(rain_sound, rain_volume, 1500)
