

if ismoving==0
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


draw_self()