function scr_spawn_flower(xx,yy,color){
	var controller = global.controller;
	var controller_spacing = controller.spacing
	
	var flower_size = 1
	var flower_sprite=Flr_Grn_Sm
	
	//Change for a larger flower
	if( irandom_range(1,2)>1) 
		flower_size = 2;
		
	var flower_color = color
	if (color=noone or color="random")
		switch(irandom_range(1,8)){
			case 1:
				flower_color="black"
				break;
			case 2:
				flower_color="blue"
				break;
			case 3:
				flower_color="green"
				break;
			case 4:
				flower_color="orange"
				break;
			case 5:
				flower_color="purple"
				break;
			case 6:
				flower_color="red"
				break;
			case 7:
				flower_color="white"
				break;
			case 8:
				flower_color="yellow"
				break;
			default: 
				flower_color="green"
				break;				
		}
	
	

	switch(flower_color){
		case "black":
			if flower_size=1
				flower_sprite=Flr_Blk_Sm
			else 
				flower_sprite=Flr_Blk_Med
			break;
		case "blue":
			if flower_size=1
				flower_sprite=Flr_Blu_Sm
			else 
				flower_sprite=Flr_Blu_Med
			break;
		case "green":
			if flower_size=1
				flower_sprite=Flr_Grn_Sm
			else 
				flower_sprite=Flr_Grn_Med
			break;
		case "orange":
			if flower_size=1
				flower_sprite=Flr_Orn_Sm
			else 
				flower_sprite=Flr_Orn_Med
			break;
		case "purple":
			if flower_size=1
				flower_sprite=Flr_pur_Sm
			else 
				flower_sprite=Flr_Pur_Med
			break;
		case "red":
			if flower_size=1
				flower_sprite=Flr_Red_Sm
			else 
				flower_sprite=Flr_Red_Med
			break;
		case "white":
			if flower_size=1
				flower_sprite=Flr_Wht_Sm
			else 
				flower_sprite=Flr_Wht_Med
			break;
		case "yellow":
			if flower_size=1
				flower_sprite=Flr_Yel_Sm
			else 
				flower_sprite=Flr_Yel_Med
			break;
		default: 
			if flower_size=1
				flower_sprite=Flr_Grn_Sm
			else 
				flower_sprite=Flr_Grn_Med
			break;
			
	}
			
		
		
	
	

	var spawn_flower = irandom_range(1,3)
	if spawn_flower<=2{
		var flower = instance_create_layer(xx + irandom_range(4,controller_spacing-8), yy+irandom_range(4,controller_spacing-8), "Instances", obj_gridFlower);
		flower.depth=depth+2
		flower.sprite_index=flower_sprite	
		flower.image_angle+=random_range(-3,3)*30
	}
	

}