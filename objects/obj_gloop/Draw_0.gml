var controller = global.controller;
var controller_current_player = controller.current_player




//if powerUp1=2 or powerUp2=2 or powerUp3=2 or 
if puBonk>0
{
	draw_hat=1
	sh_idol = Spr_Slm_Hat_Idol
	sh_sleep = Spr_Slm_Hat_Sleep
	sh_death = Spr_Slm_Hat_Stun
	sh_jump = Spr_Slm_Hat_Move_Jump
	sh_roll = Spr_Slm_Hat_Move_Roll
	sh_roll_R = Spr_Slm_Hat_Move_Spin
	sh_teleport = Spr_Slm_Hat_Tele
} else if has_crown=1
{
	draw_hat=1
	sh_idol = Spr_Slm_Crown_Idol
	sh_sleep = Spr_Slm_Crown_Sleep
	sh_death = Spr_Slm_Crown_Stun
	sh_jump = Spr_Slm_Crown_Move_Jump
	sh_roll = Spr_Slm_Crown_Move_Roll
	sh_roll_R = Spr_Slm_Crown_Move_Spin
	sh_teleport = Spr_Slm_Crown_Tele
}
else 
{
	draw_hat=0
}
	s_idol = Spr_Slm_Idol
	s_sleep = Spr_Slm_Sleep
	s_death = Spr_Slm_Stun
	s_jump = Spr_Slm_Move_Jump
	s_roll = Spr_Slm_Move_Roll
	s_roll_R = Spr_Slm_Move_Spin
	s_teleport = Spr_Slm_Tele


if has_accessory>0
{
	if has_accessory=1
	{
		sa_idol = Spr_Acc_Cat_Idol
		sa_sleep = Spr_Acc_Cat_Sleep
		sa_death = Spr_Acc_Cat_Stun
		sa_jump = Spr_Acc_Cat_Move_Jump
		sa_roll = Spr_Acc_Cat_Move_Roll
		sa_roll_R = Spr_Acc_Cat_Move_Spin
		sa_teleport = Spr_Acc_Cat_Tele
		sa_slurp = Spr_Acc_Cat_Move_Slurp
	}
	else if has_accessory=2
	{
		sa_idol = Spr_Acc_Glasses_Idol
		sa_sleep = Spr_Acc_Glasses_Sleep
		sa_death = Spr_Acc_Glasses_Stun
		sa_jump = Spr_Acc_Glasses_Move_Jump
		sa_roll = Spr_Acc_Glasses_Move_Roll
		sa_roll_R = Spr_Acc_Glasses_Move_Spin
		sa_teleport = Spr_Acc_Glasses_Tele
		sa_slurp = Spr_Acc_Glasses_Move_Slurp
	}
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
	    image_index = image_number - 6; 
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
		hat_index=sh_idol
	}	
}
else if isjumping=1{

	sprite_index=s_jump
	image_speed = 0; 
	
	//We are starting with the 4th sprite and looping through 8 images
	image_index = scr_get_jump_sprite(gridNumberX,x,gridNumberPrevX,8)	
} 
else if isrolling=1{
	if abs(derY)>0
		sprite_index=s_roll
	else
		sprite_index=s_roll_R
	
	//reverse animation if derY is positive
	if derY=-1
		image_index = scr_get_jump_sprite(gridNumberY,y,gridNumberPrevY,image_number-1)	
	else if derY=1
		image_index = scr_get_jump_sprite(gridNumberPrevY,y,gridNumberY,image_number-1)		
	else 
	{		
		image_speed=1*derX
		//if image_index>5 and derX>0
		//	image_index=1
		//else if image_index<1 and derX<0
		//	image_index=5
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

if sprite_index=s_idol 
	hat_index=sh_idol
else if sprite_index=s_sleep 
	hat_index=sh_sleep
else if sprite_index=s_death 
	hat_index=sh_death
else if sprite_index=s_jump 
	hat_index=sh_jump
else if sprite_index=s_roll 
	hat_index=sh_roll
else if sprite_index=s_roll_R 
	hat_index=sh_roll_R
else if sprite_index=s_teleport 
	hat_index=sh_teleport
	
if sprite_index=s_idol 
	accessory_index=sa_idol
else if sprite_index=s_sleep 
	accessory_index=sa_sleep
else if sprite_index=s_death 
	accessory_index=sa_death
else if sprite_index=s_jump 
	accessory_index=sa_jump
else if sprite_index=s_roll 
	accessory_index=sa_roll
else if sprite_index=s_roll_R 
	accessory_index=sa_roll_R
else if sprite_index=s_teleport 
	accessory_index=sa_teleport
	


//debug code

test_trail_index = scr_get_jump_sprite(gridNumberX,x,gridNumberPrevX,10)

if round(test_trail_index)=0
	test_trail_index = scr_get_jump_sprite(gridNumberY,y,gridNumberPrevY,10)
//test_trail_index=test_trail_index/2 
draw_sprite(Spr_Trl_Corner, test_trail_index,1200,500 )
draw_sprite(Spr_Trl_End, test_trail_index,1200,540 )
draw_sprite(Spr_Trl_Mid, test_trail_index,1200,580 )


if test_trail_index>5
	draw_sprite(Spr_Trl_End, test_trail_index,1200,400 )
if test_trail_index<=5
	draw_sprite(Spr_Trl_Mid, test_trail_index,1200,432 )
else 
	draw_sprite(Spr_Trl_Mid, 5,1200,432 )

if is_glowing=1
{
	var size = 0.8 + random_range(-0.01,0.01)
	gpu_set_blendmode(bm_add); 
	draw_sprite_ext(spr_effect_glow, 0, x+16,y+16,size,size,0,make_colour_rgb(240,204,100),0.2)
	gpu_set_blendmode(bm_normal); 
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
	if has_accessory>0	
		draw_sprite(accessory_index, image_index,x,y)
	if draw_hat=1	
		draw_sprite(hat_index, image_index,x,y)
		
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
	if has_accessory>0	
		draw_sprite(accessory_index, image_index,x,y)
	if draw_hat=1	
		draw_sprite(hat_index, image_index,x,y)
		

	// End shader
	shader_reset();
}


