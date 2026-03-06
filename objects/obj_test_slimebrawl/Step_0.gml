
is_throwSnowball++
if is_throwSnowball>=30
{
	is_throwSnowball=0
	var inst = instance_create_layer(x+sprite_width/2, y+sprite_height/2, "Instances", obj_effectSnowball);
	inst.yy=10
	inst.y+=inst.yy +(sign(inst.yy)*20)
	inst.xx=random_range(-4,4)
	
}