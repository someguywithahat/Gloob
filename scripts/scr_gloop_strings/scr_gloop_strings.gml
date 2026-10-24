function scr_gloop_strings(){
	global.strGloopGreen="Gloop"
	global.strGloopBlue="DewDrop"
	global.strGloopPurple="Barry"
	global.strGloopRed="Arson"
	global.strGloopOrange="Pumpkin"
	global.strGloopYellow="Honey"
	global.strGloopBlack="Coal"
	global.strGloopWhite="Mallow"
	
	global.strGloopGreenBackstory="He likes "+global.strGloopYellow

	//Character bios for rm_characterSelect (temporary, rewrite whenever).  "\n" starts a new line
	global.strGloopGreenBio = global.strGloopGreen + " is very proud of his slime trial.  He likes " + global.strGloopYellow + ", but hasn't worked up the nerve to say so."
	global.strGloopBlueBio = "Spends his mornings licking the dew off the grass"
	global.strGloopPurpleBio = "No one knows why he tastes like berries"
	global.strGloopRedBio = "Coming soon."
	global.strGloopOrangeBio = "Thinks every season is autumn.  \n\nHis hobby is building gigantic piles of leaves."
	global.strGloopYellowBio = "The stickiest slime.  It's a problem.  She has no idea " + global.strGloopGreen + " has a crush on her.  Everyone else does."
	global.strGloopBlackBio = "Secretely glows the brightest, but tones it down to avoid making the others self conscious."
	global.strGloopWhiteBio = "Mallow is the squishiest of all her friends.  She spends her days hunting for marshmellows to keep her perfectly round figure."
}

/// The bio for a slime color (global.GREEN, global.BLUE, ...)
function scr_gloop_bio(color){
	switch(color)
	{
		case global.GREEN:  return global.strGloopGreenBio
		case global.BLUE:   return global.strGloopBlueBio
		case global.PURPLE: return global.strGloopPurpleBio
		case global.RED:    return global.strGloopRedBio
		case global.ORANGE: return global.strGloopOrangeBio
		case global.YELLOW: return global.strGloopYellowBio
		case global.BLACK:  return global.strGloopBlackBio
		case global.WHITE:  return global.strGloopWhiteBio
	}
	return ""
}