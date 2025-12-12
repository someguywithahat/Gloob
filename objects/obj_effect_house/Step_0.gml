

grow_counter+=grow_number

if grow_counter>grow_max
{
	grow_counter=grow_max	
	//grow_number=-0.005
	grow_number=0
}

if grow_counter<grow_min
{
	grow_counter=grow_min	
	grow_number=0.005
}

