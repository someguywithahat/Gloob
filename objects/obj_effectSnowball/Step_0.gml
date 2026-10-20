
despawnTimer--

//if snowballhit=1
//{
//	snowballhit=2
//	despawnTimer=20
//}

x+=xx
y+=yy

//Snowball fight: hit the slime it was thrown at (the middle of its 32x32 space)
if instance_exists(target) and target.state=UG_STATE.FIGHT
	and point_in_rectangle(x, y, target.x+4, target.y+4, target.x+28, target.y+28)
{
	target.snowball_hit()
	audio_play_sound(snd_snowball, 1, false);
	instance_destroy()
	exit
}

if despawnTimer<0
	instance_destroy()
