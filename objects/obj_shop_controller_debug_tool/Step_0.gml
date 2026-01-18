var shop_length=array_length(global.SHOPITEMS)

if clicked_left>0
{
	clicked_left=-1
	shop_index--
	if shop_index<0
		shop_index=shop_length-1
	
	shop_sub_item=[]
	shop_index_sub=0
	
	//populate shop_sub_item
	array_push(shop_sub_item, { sprite: global.SHOPITEMS[shop_index].sprite, sprite_index: 0, shader_index: 0, animation_speed: global.SHOPITEMS[shop_index].animation_speed, type: global.SHOPITEMS[shop_index].type})	
	
	shop_sprite=shop_sub_item[0].sprite
	
	if global.SHOPITEMS[shop_index].frames_sold_seperately=true
	{
		for(ii=1;ii<sprite_get_number(shop_sprite);ii++)
		{
			array_push(shop_sub_item, { sprite: global.SHOPITEMS[shop_index].sprite, sprite_index: ii, shader_index: 0, animation_speed: global.SHOPITEMS[shop_index].animation_speed, type: global.SHOPITEMS[shop_index].type})	
		}
		
	}	
	
	shop_sprite_index=0	
}



if clicked_right>0
{
	clicked_right=-1
	shop_index++
	if shop_index=shop_length
		shop_index=0
		
	shop_sub_item=[]
	shop_index_sub=0
	
	//populate shop_sub_item
	array_push(shop_sub_item, { sprite: global.SHOPITEMS[shop_index].sprite, sprite_index: 0, shader_index: 0, animation_speed: global.SHOPITEMS[shop_index].animation_speed, type: global.SHOPITEMS[shop_index].type})	
	
	shop_sprite=shop_sub_item[0].sprite
	
	if global.SHOPITEMS[shop_index].frames_sold_seperately=true
	{
		for(ii=1;ii<sprite_get_number(shop_sprite);ii++)
		{
			array_push(shop_sub_item, { sprite: global.SHOPITEMS[shop_index].sprite, sprite_index: ii, shader_index: 0, animation_speed: global.SHOPITEMS[shop_index].animation_speed, type: global.SHOPITEMS[shop_index].type})	
		}
		
	}	
	shop_sprite_index=0	
}





var shop_sub_length=array_length(shop_sub_item)-1
if clicked_down>0
{
	clicked_down=-1
	shop_index_sub++
	if shop_index_sub>shop_sub_length
		shop_index_sub=0
		
	shop_sprite_index=shop_index_sub	
}

if clicked_up>0
{
	clicked_up=-1
	shop_index_sub--
	if shop_index_sub<0
		shop_index_sub=shop_sub_length
	shop_sprite_index=shop_index_sub	
}



if clicked_object>0 
{
	clicked_object=-1
	global.mouseDrag=1
	
	if shop_sub_item[0].type=0
	{
		var spawn_id = instance_create_layer(x+8, y, "Instances", obj_town_object );
		spawn_id.locked=1
		spawn_id.sprite=shop_sub_item[0].sprite
		spawn_id.sprite_index=shop_sub_item[0].sprite
		spawn_id.image_index=shop_index_sub
		spawn_id.image_speed=shop_sub_item[0].animation_speed	
	}
}

