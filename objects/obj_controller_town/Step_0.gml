var storage_length=array_length(storage)

if clicked_left>0
{
	clicked_left=-1
	storage_index--
	if storage_index<0
		storage_index=storage_length-1
	sprite_to_place=storage[storage_index].sprite_to_place
	sprite_to_place_index=storage[storage_index].sprite_to_place_index	
}


if clicked_right>0
{
	clicked_right=-1
	storage_index++
	if storage_index=storage_length
		storage_index=0
		
	sprite_to_place=storage[storage_index].sprite_to_place
	sprite_to_place_index=storage[storage_index].sprite_to_place_index
}



if clicked_down>0
{
	clicked_down=-1
}

if clicked_up>0
{
	clicked_up=-1
}

