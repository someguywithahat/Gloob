var controller = global.controller;
var controller_current_player = controller.current_player




//if powerUp1=2 or powerUp2=2 or powerUp3=2 or 
if puBonk>0
{
	s_idol = Spr_Slm_idol_Hat
	s_sleep = Spr_Slm_Sleep_Hat
	s_death = Spr_Slm_Death_Hat
	s_jump = Spr_Slm_Move_Up_Jump_Hat
	s_roll = Spr_Slm_Move_Up_roll_hat
	s_roll_R = Spr_Slm_Roll_Hat
	s_teleport = Spr_Slm_Tele_Hat
}
else
{
	s_idol = Spr_Slm_Idol
	s_sleep = Spr_Slm_Sleep
	s_death = Spr_Slm_Death
	s_jump = Spr_Slm_Move_Up_Jump
	s_roll = Spr_Slm_Move_Up_roll
	s_roll_R = Spr_Slm_Roll_R
	s_teleport = Spr_Slm_Tele
}



if ismoving==0 and player_number <> controller_current_player and alive=1
	idletime++
	
	
if idletime>sleeptime and alive=1{
	issleep=1
	sprite_index = s_sleep;	
	image_speed=1
}

else if alive=0
{
	image_speed = 1;   
	sprite_index = s_death;	
	if (image_index >= image_number - 1) {	    
	    image_index = image_number - 12; 
	}	
	
}
else if isteleporting=1
{
	sprite_index=s_teleport
	image_speed=1
	if image_index>image_number-1{
		isteleporting=2
		scr_pu_teleport_random(id);
		image_index=image_number-1
		image_speed=-1
	}	
}
else if isteleporting=2
{
	sprite_index=s_teleport
	image_speed=-1
	if image_index<=0{
		isteleporting=0
		sprite_index=s_idol
	}	
}
else if isjumping=1{

	sprite_index=s_jump
	image_speed = 0; 
	
	//We are starting with the 4th sprite and looping through 8 images
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
	else 
	{		
		image_speed=1*derX
		if image_index>5 and derX>0
			image_index=1
		else if image_index<1 and derX<0
			image_index=5
	}
}


else if sprite_index=s_sleep and (image_index > 50) and issleep=1 {
    image_index = 20;
}
else if sprite_index=s_sleep and (image_index >=61) and issleep=2 {
    sprite_index=s_idol
	image_speed=1
}
else if sprite_index=s_sleep and issleep=2 and (image_index <=53) 
	image_index=54
else if sprite_index=s_sleep and (image_index =10) {
	var snd = audio_play_sound(snd_yawn, 1, false);
	audio_sound_pitch(snd, random_range(0.9, 1.2));
}
else{
    sprite_index=s_idol
	image_speed=1
}








if rainbow_power=1 or powerUp1=3 or powerUp2=3 or powerUp3=3{
	rainbow_delay+=.05
	if rainbow_delay>1{
		gloop_color_index_old=gloop_color_index
		rainbow_delay=0
		if gloop_color_index = 1
			gloop_color_index=4
		else if gloop_color_index=4
			gloop_color_index=5
		else if gloop_color_index=5
			gloop_color_index=3
		else if gloop_color_index=3
			gloop_color_index=7
		else if gloop_color_index=7
			gloop_color_index=2
		else if gloop_color_index=2
			gloop_color_index=1
		else gloop_color_index=1
	}

	// Start shader
	shader_set(shd_palette_shift);

	// Set uniforms
	var u_palette_orig = shader_get_sampler_index(shd_palette_shift, "palette_orig");
	var u_palette_swap_old = shader_get_sampler_index(shd_palette_shift, "palette_swap_old");
	var u_palette_swap_new = shader_get_sampler_index(shd_palette_shift, "palette_swap_new");
	var u_color_count  = shader_get_uniform(shd_palette_shift, "color_count");
	var u_color_merge  = shader_get_uniform(shd_palette_shift, "color_merge");

	// Bind your palette sprites as textures
	texture_set_stage(u_palette_orig, sprite_get_texture(spr_palette_index, 0));
	texture_set_stage(u_palette_swap_old, sprite_get_texture(spr_palette_all, gloop_color_index_old));
	texture_set_stage(u_palette_swap_new, sprite_get_texture(spr_palette_all, gloop_color_index));

	// Send color count
	shader_set_uniform_f(u_color_count, 6.0);
	shader_set_uniform_f(u_color_merge, rainbow_delay);

	// Draw the sprite
	draw_self();

	// End shader
	shader_reset();
}
else {
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
}


