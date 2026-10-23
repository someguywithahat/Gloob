/*
	A fish swimming in a fishing room.  Spawned by scr_fishing_spawn_fish, which calls set_fish with its scr_fish_data row.
	Wanders around, swims away from the boat when it gets close, and stays in the water.
	Click it to try to catch it in the fishing minigame.
*/
fish_data = undefined
light_color = c_white //Glow color in dark rooms (from the fish's scr_fish_data row)

vx = random_range(-1, 1) //Speed
vy = random_range(-0.3, 0.3)
max_speed = 2.5
turn_timer = irandom_range(60, 180) //Steps until it picks a new direction
flee_range = 100 //How close the boat gets before it swims away
flee_push = 0.02 //How hard it swims away

/// Sets which fish this is (a row from scr_fish_data)
set_fish = function(data)
{
	fish_data = data
	sprite_index = data.sprite
	light_color = data.light
}
