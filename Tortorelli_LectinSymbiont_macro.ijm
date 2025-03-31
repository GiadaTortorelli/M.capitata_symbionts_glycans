//Open image
run("Split Channels");
waitForUser("select nucleus image");rename("nucleus");
waitForUser("select membrane image");rename("membrane");
//run("Duplicate...", "title=green");

selectWindow("nucleus");
run("Threshold...");selectWindow("Threshold"); waitForUser("set the threshold");
run("Smooth");
setOption("BlackBackground", true);
run("Convert to Mask");
run("Fill Holes");
run("Watershed");
run("Analyze Particles...", "size=20-Infinity show=Masks exclude");
run("Invert LUT");rename("nucleusmask");
run("Duplicate...", "title=dilated");
run("Options...", "iterations=2 count=1 black do=Dilate");
selectWindow("nucleusmask");
run("Duplicate...", "title=EDM");run("Invert");
run("Options...", "iterations=1 count=1 black edm=16-bit do=Nothing");
run("Distance Map");rename("EDM2");

run("Marker-controlled Watershed", "input=EDM2 marker=nucleusmask mask=dilated binary calculate use");
run("8-bit");setThreshold(1, 255);
setOption("BlackBackground", true);
run("Convert to Mask");rename("dilated_watershed");

selectWindow("nucleusmask");
run("Options...", "iterations=2 count=1 black edm=16-bit do=Erode");

imageCalculator("Subtract create", "dilated_watershed","nucleusmask");
rename("ringmask");
run("16-bit");run("Multiply...", "value=257");

selectWindow("membrane");run("Add...", "value=50");
imageCalculator("AND create", "membrane","ringmask");rename("ring_intensity");
setThreshold(1, 65535);
run("Set Measurements...", "area mean min integrated area_fraction limit display redirect=None decimal=3");
run("Analyze Particles...", "size=0-Infinity show=Masks display exclude clear summarize add");



