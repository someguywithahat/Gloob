var controller = global.controller;
var controller_current_player = controller.current_player

if ismoving==0 and player_number <> controller_current_player and alive=1
	idletime++
	
	
if idletime>sleeptime and alive=1{
	issleep=1
	sprite_index = s_sleep;	
	image_speed=1
}

if alive=0
{
	image_speed = 1;   
	sprite_index = s_death;	
	if (image_index >= image_number - 1) {	    
	    image_index = image_number - 12; 
	}	
	
}

if isjumping=1{

	sprite_index=s_jump
	image_speed = 0; 
	image_index = 4 + scr_get_jump_sprite(gridNumberX,x,gridNumberPrevX,8)	
} 
else if isrolling=1{
	if abs(derY)>0
		sprite_index=s_roll
	else
		sprite_index=s_roll_R
	
	//reverse animation if derY is positive
	if derY=-1
		image_index = 2 + scr_get_jump_sprite(gridNumberY,y,gridNumberPrevY,6)	
	else if derY=1
		image_index = 2 + scr_get_jump_sprite(gridNumberPrevY,y,gridNumberY,6)	
	//else if derX=-1
	//	image_index = 1 + scr_get_jump_sprite(gridNumberPrevX,x,gridNumberX,5)
	//else if derX=1	
	//	image_index = 1 + scr_get_jump_sprite(gridNumberX,x,gridNumberPrevX,5)	
	else 
	{		
		image_speed=1*derX
		if image_index>5 and derX>0
			image_index=1
		else if image_index<1 and derX<0
			image_index=5
	}
}


if sprite_index=s_sleep and (image_index > 50) and issleep=1 {
    image_index = 20;
}
else if sprite_index=s_sleep and (image_index >=61) and issleep=2 {
    sprite_index=s_idol
	image_speed=1
}
else if sprite_index=s_sleep and issleep=2 and (image_index <=53) 
	image_index=54
if sprite_index=s_sleep and (image_index =10) {
	var snd = audio_play_sound(snd_yawn, 1, false);
	audio_sound_pitch(snd, random_range(0.9, 1.2));
}





/* Palette swap shader happens last*/


// Start shader
shader_set(shd_palette_swap);

// Set uniforms
var u_palette_orig = shader_get_sampler_index(shd_palette_swap, "palette_orig");
var u_palette_swap = shader_get_sampler_index(shd_palette_swap, "palette_swap");
var u_color_count  = shader_get_uniform(shd_palette_swap, "color_count");

// Bind your palette sprites as textures
texture_set_stage(u_palette_orig, sprite_get_texture(spr_palette_index, 0));
texture_set_stage(u_palette_swap, sprite_get_texture(spr_palette_all, gloop_color_index));
//texture_set_stage(u_palette_orig, sprite_get_texture(spr_palette_index_red, 0));
//texture_set_stage(u_palette_swap, sprite_get_texture(spr_palette_index, 0));



// Send color count
shader_set_uniform_f(u_color_count, 6.0);

// Draw the sprite
draw_self();

// End shader
shader_reset();





//// set shader (debug or real)
//shader_set(shd_palette_debug);

//// get sampler index and bind textures
//var s_orig = shader_get_sampler_index(shd_palette_debug, "palette_orig");
//var s_swap = shader_get_sampler_index(shd_palette_debug, "palette_swap");

//texture_set_stage(s_orig, sprite_get_texture(spr_palette_index, 0));
//texture_set_stage(s_swap, sprite_get_texture(spr_palette_index_red, 0));

//// set color count
//var u_color_count = shader_get_uniform(shd_palette_debug, "color_count");
//shader_set_uniform_f(u_color_count, 6.0);

//// draw the sprite to see debug output
//draw_self();

//shader_reset();
