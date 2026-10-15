//Pick the sprite for what the slime is doing
var look = get_look()
if look[1]>=0
{
	//Single expression frame
	sprite_index=look[0]
	image_speed=0
	image_index=look[1]
}
else
{
	if sprite_index<>look[0]
	{
		sprite_index=look[0]
		image_index=0
	}
	image_speed=1

	//Loop the snoring part of the sleep animation
	if sprite_index=Spr_Slm_Sleep and image_index>50
		image_index=20
}


// Start shader
shader_set(shd_palette_swap);

// Set uniforms
var u_palette_orig = shader_get_sampler_index(shd_palette_swap, "palette_orig");
var u_palette_swap = shader_get_sampler_index(shd_palette_swap, "palette_swap");
var u_color_count  = shader_get_uniform(shd_palette_swap, "color_count");

// Bind your palette sprites as textures
texture_set_stage(u_palette_orig, sprite_get_texture(spr_palette_index, 0));
texture_set_stage(u_palette_swap, sprite_get_texture(spr_palette_all, gloop_color_index));

// Send color count
shader_set_uniform_f(u_color_count, 6.0);

// Draw the sprite
//Spr_Slm_Snowball is 48x48 with the slime 8 pixels in, so shift it to line up with the 32x32 slime sprites
var draw_x = x
var draw_y = y
if sprite_index=Spr_Slm_Snowball
{
	draw_x-=8
	draw_y-=8
}
//Idle animations are drawn on bigger sprites.  Shift them so the slime lines up, and flip them if they'd run off the right side of the room
var xscale = 1
if array_length(look)>2
{
	draw_x += look[2]
	draw_y += look[3]
	if look[4] and x+sprite_get_width(sprite_index)>room_width
	{
		xscale = -1
		draw_x = x+31-look[2]
	}
}
//Spin around the slime's center while launched (sprite origin is the top left corner)
if state=UG_STATE.LAUNCHED and rotation<>0
{
	var half = sprite_get_width(sprite_index)/2
	draw_x += half - (half*dcos(rotation) + half*dsin(rotation))
	draw_y += half - (-half*dsin(rotation) + half*dcos(rotation))
}
if image_alpha>0
	draw_sprite_ext(sprite_index,image_index,draw_x,draw_y,xscale,1,rotation,c_white,image_alpha)

// End shader
shader_reset();
