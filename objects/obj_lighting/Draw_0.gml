//---- How dark should it be? ----
//Gets darker as the day's goal gets close (the "N left" counter)
var controller = global.controller
//Fraction of the goal done.  Keeps going past 1 when players play on after reaching the goal
var progress = scr_day_progress()
//Winter evenings come earlier
var shift = (global.weather=global.WINTER) ? winter_earlier : 0
var dusk_at = dusk_start-shift
var dark_at = dark_start-shift
var full_at = full_dark-shift
//night_target 0-0.5 is day -> dusk, 0.5-1 is dusk -> night (matches sky_color)
if progress<dark_at
	night_target = clamp((progress-dusk_at)/(dark_at-dusk_at), 0, 1) * 0.5
else
	night_target = 0.5 + clamp((progress-dark_at)/(full_at-dark_at), 0, 1) * 0.5
night_target *= max_night
if force_night or always_night
	night_target = max_night
night_amount += clamp(night_target-night_amount, -fade_speed, fade_speed)

//Coal (the shadow fish) in the fishing minigame puts out every light, its own too, and makes it even darker
var shadow = 0
with(obj_fishing_minigame)
{
	if fish.move=FISH_MOVE.SHADOW and shadow_amount>shadow
	{
		shadow = shadow_amount
	}
}

//Broad daylight: nothing to draw
if night_amount<=0.001 and shadow<=0
	exit


//---- Build the light map ----
if !surface_exists(light_surf)
	light_surf = surface_create(room_width, room_height)

surface_set_target(light_surf)
draw_clear(merge_colour(sky_color(night_amount), shadow_dark_color, shadow*shadow_darkness))
gpu_set_blendmode(bm_add)

//Lights fade in with the dark.  Coal puts them all out, its own too
var strength = night_amount*(1-shadow)
var t = current_time

//Fishing: the boat's lantern, and every fish glowing in its own color
with(obj_gloopFishing)
	other.add_light(center_x(), center_y(), other.boat_light_radius, other.boat_light_color, strength)
with(obj_gloopFish)
	other.add_light(x+sprite_width/2, y+sprite_height/2, other.fish_light_radius, light_color, strength*other.fish_light_strength, spr_effect_glow)
//Lightning fish (Volt) in the fishing minigame: each bolt flashes the cave around the pond, and the trail glows
with(obj_fishing_minigame)
{
	if fish.move=FISH_MOVE.LIGHTNING
	{
		if bolt_flash>0
			other.add_light(box_x+box_size/2, box_y+box_size/2, box_size*other.bolt_flash_size, bolt_flash_color, strength*bolt_flash)
		for (var i = 0; i < array_length(bolt_trail); i += 3)
		{
			var bit = bolt_trail[i]
			other.add_light(bit.x, bit.y, bolt_trail_light*3, bolt_trail_color, strength*0.5*bit.life/bolt_trail_life, spr_effect_glow)
		}
	}
}
//Trophy clams: an open bowl glows in its fish's color, like the fish does.  Fades in as the bowl grows
with(obj_clamTrophy)
{
	var grown = bowl_size()
	if grown>0 and !is_undefined(fish_data)
	{
		var bowl_h = sprite_get_height(bowl_sprite)
		var glow_y = y + mouth_y + bowl_h*bowl_lower - bowl_h*grown/2 //Middle of the bowl
		other.add_light(x, glow_y, other.fish_light_radius*other.bowl_light_size, fish_data.light, strength*other.fish_light_strength*grown, spr_effect_glow)
	}
}

//Slime trails: a faint glow on every space a slime has been, in that slime's color
var half_space = controller.spacing/2
var trail_strength = strength*trail_light_strength
with(obj_gridNumber)
	if activeNumber=0 and wall=0 and obs=0 and visible
		other.add_light(x+half_space, y+half_space, other.trail_light_radius, other.slime_light_color(gloop_color_index), trail_strength, other.trail_light_sprite)

//Slimes on the board: a soft glow in their own color, gently breathing
with(obj_gloop)
{
	var pulse = 1 + 0.05*sin(t/400 + real(id))
	var glow = (alive=1) ? strength : strength*0.4
	other.add_light(x+16, y+16, other.slime_light_radius*pulse, other.slime_light_color(gloop_color_index), glow)
}

//Slimes on the sideline
with(obj_unusedGloop)
	if image_alpha>0
		other.add_light(x+16, y+16, other.sideline_slime_light_radius, other.slime_light_color(gloop_color_index), strength*image_alpha)

//Fireflies flicker
//with(obj_effect_firefly)
//{
//	var flicker = 0.75 + 0.25*sin(t/120 + real(id)*1.7)
//	other.add_light(x+sprite_width/2, y+sprite_height/2, other.firefly_light_radius, other.firefly_light_color, strength*flicker)
//}
with(obj_effect_night_firefly)
{
	var flicker = 0.75 + 0.25*sin(t/120 + real(id)*1.7)
	other.add_light(x+half_size, y+half_size, other.night_firefly_light_radius, other.firefly_light_color, strength*flicker)
}

//Fairy and bubble
with(obj_effect_fairy)
	other.add_light(x+sprite_width/2, y+sprite_height/2, other.fairy_light_radius, other.bubble_light_color, strength)
with(obj_effect_bubble)
	other.add_light(x, y, other.bubble_light_radius*bubble_scale, other.bubble_light_color, strength*0.8)

gpu_set_blendmode(bm_normal)
surface_reset_target()


//---- Multiply it over the game ----
gpu_set_blendmode_ext(bm_dest_colour, bm_zero)
draw_surface_stretched(light_surf, 0, 0, room_width, room_height)
gpu_set_blendmode(bm_normal)
