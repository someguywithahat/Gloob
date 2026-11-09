if surface_exists(surf)
	surface_free(surf)
//In case it's removed mid-scene, don't leave the game frozen
if phase<>"fade_in" and phase<>"fade_back"
	instance_activate_all()
