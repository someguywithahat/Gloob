/*
	Lighting.  The board slowly gets dark as the day's goal gets close (dusk), and the slimes and
	fireflies light it up.

	Each frame a screen-sized light map is filled with the sky color (white in the day, orange at
	dusk, deep blue at night), the lights are added on top, and it's multiplied over the game.
	Multiply tints the colors instead of greying them out, which keeps the cartoon look.

	Created by obj_controller when the game board is set up.  Depth -10000: darkens the board and
	score signs, but not the goal counter or menus (obj_controller draws those at -20000).
*/
depth=-10000
light_surf=-1

//How dark it is: 0 = day, 1 = full night.  Eases toward night_target so it never snaps
night_amount=0
night_target=0
//When it gets dark, as a fraction of the day's goal done (1 = goal reached, above 1 = playing past the goal)
dusk_start=0.8 //Sky starts turning orange
dark_start=0.9 //Orange starts turning into night
full_dark=1.1 //Full night
winter_earlier=0.2 //Winter nights come this much earlier (all three above move back: 60%, 70%, 90%)
max_night=1 //Darkest it gets
fade_speed=0.005 //How fast night_amount moves per step
force_night=false //Debug: preview full night (obj_weather_controller's debug menu toggles this)
always_night=false //Dark rooms (the fishing cave): full night all the time, no dusk.  Set by whoever creates this

//Sky color at each time of day
day_color=c_white
dusk_color=make_colour_rgb(255,190,140)
night_color=make_colour_rgb(55,60,115)

//Light shape.  Swap in a stepped/banded light sprite later for a more hand-drawn look
light_sprite=spr_effect_glow_harder

//Light sizes (radius in pixels)
slime_light_radius=112
sideline_slime_light_radius=36
firefly_light_radius=28
night_firefly_light_radius=24
fairy_light_radius=32
bubble_light_radius=40

//Slime trails glow faintly in their slime's color at night
trail_light_radius=22 //A bit bigger than half a space, so neighboring glows blend into a line
trail_light_strength=0.3 //0-1.  Kept low so the trails don't outshine the slimes
trail_light_sprite=spr_effect_glow //Softer than light_sprite, so the glows blend into smooth lines

//Fishing cave lights
boat_light_radius=150 //The boat's lantern
boat_light_color=make_colour_rgb(255,215,150) //Warm lantern tint
fish_light_radius=40 //Each fish glows in its own color (light in scr_fish_data)
fish_light_strength=0.9
bolt_flash_size=1.4 //Volt's lightning flash in the fishing minigame lights the cave this far around the pond (times the pond's size)
shadow_dark_color=make_colour_rgb(18,12,30) //Coal (the shadow fish) darkens the room toward this while it has the lights out
shadow_darkness=0.99 //How far toward it (0-1)
bowl_light_size=1.5 //Trophy clam bowls glow in their fish's color too, this much bigger than a fish's glow

//Each slime glows a soft version of its own color (indexed by global.BLACK, global.BLUE, ...)
slime_light_colors = array_create(8, c_white)
slime_light_colors[global.BLACK]  = make_colour_rgb(175,160,255)
slime_light_colors[global.BLUE]   = make_colour_rgb(150,200,255)
slime_light_colors[global.GREEN]  = make_colour_rgb(175,255,175)
slime_light_colors[global.ORANGE] = make_colour_rgb(255,205,140)
slime_light_colors[global.PURPLE] = make_colour_rgb(225,165,255)
slime_light_colors[global.RED]    = make_colour_rgb(255,165,155)
slime_light_colors[global.WHITE]  = make_colour_rgb(255,250,235)
slime_light_colors[global.YELLOW] = make_colour_rgb(255,240,150)
firefly_light_color=make_colour_rgb(255,240,140)
bubble_light_color=make_colour_rgb(200,235,255)


/// Draws one light onto the light map.  strength 0-1.  sprite is optional: leave it out to use light_sprite
add_light = function(lx, ly, radius, color, strength, sprite=light_sprite)
{
	var scale = radius*2 / sprite_get_width(sprite)
	draw_sprite_ext(sprite, 0, round(lx), round(ly), scale, scale, 0, color, strength)
}

/// Light color for a slime color index
slime_light_color = function(color_index)
{
	return slime_light_colors[clamp(color_index, 0, array_length(slime_light_colors)-1)]
}

/// Sky color for how dark it is: day -> dusk -> night
sky_color = function(amount)
{
	if amount<0.5
		return merge_colour(day_color, dusk_color, amount*2)
	return merge_colour(dusk_color, night_color, (amount-0.5)*2)
}
