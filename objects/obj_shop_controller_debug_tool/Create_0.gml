depth=-200000


xx = 40
yy = 60


//arrow toggles
clicked_left=-1
clicked_right=-1
clicked_up=-1
clicked_down=-1
clicked_object=-1

sprite_to_place=noone
sprite_frame_to_place=0

shop_index=0
shop_index_sub=0
shop_index_sub_max=0



//----------------testing code, will need to load later
shop_sprite=global.SHOPITEMS[0].sprite
shop_sprite_index=0


shop_sub_item=[]


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
