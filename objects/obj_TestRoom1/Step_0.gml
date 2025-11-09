if select_reset_score=1
{
	select_reset_score=-1
	global.high_scores = [
	    { gname: "JEX", gscore: 250, gindex: 1, gcolor: 2 },
	    { gname: "VI ", gscore: 225, gindex: 2, gcolor: 4 },
	    { gname: "KAY", gscore: 201, gindex: 0, gcolor: 3 },
	    { gname: "BAG", gscore: 200, gindex: 4, gcolor: 5 },
	    { gname: "AZR", gscore: 175, gindex: 4, gcolor: 1 },
	    { gname: "RNT", gscore: 150, gindex: 0, gcolor: 6 },
	    { gname: "ARK", gscore: 125, gindex: 4, gcolor: 7 },
	    { gname: "KRA", gscore: 100, gindex: 2, gcolor: 0 },
	    { gname: "HAT", gscore: 75,  gindex: 0, gcolor: 1 },
	    { gname: "SLM", gscore: 1,   gindex: 3, gcolor: 2 }
	];
	scr_save_high_score()
}