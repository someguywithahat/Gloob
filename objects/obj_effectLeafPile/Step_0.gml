

if explode=1
{
	explode=0
	
	for(var i=0;i<30;i++)
	{
		var leaf=instance_create_layer(x+sprite_width/2, y+sprite_height/2, "Instances", obj_effectPileLeaf);
		leaf.depth=depth-1
	}
}