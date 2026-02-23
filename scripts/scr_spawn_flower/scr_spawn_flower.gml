function scr_spawn_flower(xx,yy,gloop_color_index){
	var controller = global.controller;
	var controller_spacing = controller.spacing
	
	var flower_size = 1
	var flower_sprite=Flr_Grn_Sm
	
	//Change for a larger flower
	if( irandom_range(1,2)>1) 
		flower_size = 2;
		



	var spawn_flower = irandom_range(1,3)
	if spawn_flower<=2{
		if flower_size=1
			flower_sprite=Flr_Grn_Sm
		else 
			flower_sprite=Flr_Grn_Med		
		
		var flower = instance_create_layer(xx + irandom_range(4,controller_spacing-8), yy+irandom_range(4,controller_spacing-8), "Instances", obj_gridFlower);
		flower.gloop_color_index=gloop_color_index
		
		show_debug_message("color " + string(gloop_color_index))
		flower.depth=depth+2
		flower.sprite_index=flower_sprite	
		flower.image_angle+=random_range(-3,3)*30
	}
	

}