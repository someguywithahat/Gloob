
var palette_original = spr_palette_index
var palette_all = spr_palette_all

if obs=1  
{
	palette_original=spr_palette_seasons_index
	palette_all=spr_palette_seasons_all
	if global.weather = global.FALL
		gloop_color_index=1
	else
		gloop_color_index=0
}



// Start shader
shader_set(shd_palette_swap);

// Set uniforms
var u_palette_orig = shader_get_sampler_index(shd_palette_swap, "palette_orig");
var u_palette_swap = shader_get_sampler_index(shd_palette_swap, "palette_swap");
var u_color_count  = shader_get_uniform(shd_palette_swap, "color_count");

// Bind your palette sprites as textures
texture_set_stage(u_palette_orig, sprite_get_texture(palette_original, 0));
texture_set_stage(u_palette_swap, sprite_get_texture(palette_all, gloop_color_index));

// Send color count
shader_set_uniform_f(u_color_count, 6.0);

// Draw the sprite
//draw_self();

if sprite_index <> noone
{
	rot_x=0
	rot_y=0
	if rotate = 90
	{
		rot_y=32
	}
	else if rotate = 180
	{
		rot_y=32
		rot_x=32
	}
	else if rotate = 270
	{
		rot_x=32
	}
	draw_sprite_ext(sprite_index,image_index,x+rot_x,y+rot_y,1,1,rotate,c_white,1)
}

// End shader
shader_reset();




if has_powerUP=1{
	draw_sprite(Spr_PU_Hat,powerUpImageIndex,x,y)
	powerUpImageIndex=powerUpImageIndex+.2
}
else if has_powerUP=2{
	draw_sprite(Spr_Pu_Tel,powerUpImageIndex,x,y)
	powerUpImageIndex=powerUpImageIndex+.2
}




if (mouse_x > x && mouse_x < x+sprite_width &&
    mouse_y > y && mouse_y < y+sprite_width
	&& 1=2 //temporarily disabled
	)
{
	tooltip_counter++
	if tooltip_counter>40
	{
		var yy=-60
		if y<50
			yy=32

		if has_powerUP=1
			scr_draw_grass_sign(x-300,y+yy, "Ignores one hit",1)
		else if has_powerUP=2
			scr_draw_grass_sign(x-300,y+yy, "Press SPACE to teleport",1)
		//depth=depthTemp
	
	}
	
}
else tooltip_counter=0

if (mouse_x > x && mouse_x < x+sprite_width &&
    mouse_y > y && mouse_y < y+sprite_width 
	&& activeNumber=0
	)
{

	draw_sprite_ext(spr_effect_particle_test,0,x+16 + (8*enterX), y+16 + (8*enterY),1,1,0,c_green,1)	
	draw_sprite_ext(spr_effect_particle_test,0,x+16 + (7*exitX), y+16 + (6*exitY),1,1,0,c_red,1)

}

