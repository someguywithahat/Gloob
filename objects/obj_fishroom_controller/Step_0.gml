



if (keyboard_check_pressed(vk_space)) {
	if isfishing<0
	{
		isfishing=10
		target_fishx=irandom(catchw-20)+catchx+20
		target_fishy=irandom(catchw-20)+catchy+20
		target_fishxx=random_range(-2,2)
		target_fishyy=random_range(-2,2)
		target_fishxxx=0
		target_fishyyy=0
	}
	else
		isfishing=-1
}	

if isfishing=10
{
	target_fishx+=target_fishxx
	target_fishxx+=target_fishxxx
	target_fishy+=target_fishyy
	target_fishyy+=target_fishyyy

	if target_fishx<catchx
	{
		target_fishx=catchx
		target_fishxx+=0.1
	}
	if target_fishy<catchy
	{
		target_fishy=catchy
		target_fishyy+=0.1
	}
	if target_fishx+sprite_get_width(target_fish)>catchx+catchw
	{
		target_fishx=catchx+catchw-sprite_get_width(target_fish)
		target_fishxx-=0.1
	}
		
	if target_fishy+sprite_get_height(target_fish)>catchy+catchw
	{
		target_fishy=catchy+catchw-sprite_get_height(target_fish)
		target_fishyy-=0.1
	}


	if (keyboard_check(ord("D")))
	{
		hookxx+=hookacceleration
		if hookxx>hookmaxX
			hookxx=hookmaxX
	}
	if (keyboard_check(ord("A")))
	{
		hookxx-=hookacceleration
		if hookxx<hookmaxX*-1
			hookxx=hookmaxX*-1
	}
	if (keyboard_check(ord("W")))
	{
		hookyy-=hookacceleration
		if hookyy<hookmaxY*-1
			hookyy=hookmaxY*-1
	}
	if (keyboard_check(ord("S")))
	{
		hookyy+=hookacceleration
		if hookyy>hookmaxY
			hookyy=hookmaxY
	}

	if hookx<catchx+20
		hookxx=abs(hookxx)
	if hooky<catchy+20
		hookyy=abs(hookyy)
	if hookx+20>catchx+catchw
		hookxx=abs(hookxx)*-1
	if hooky+20>catchy+catchw
		hookyy=abs(hookyy)*-1

	hookx+=hookxx
	hooky+=hookyy

}



