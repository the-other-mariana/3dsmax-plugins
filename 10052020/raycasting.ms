fn createPoint numP=
(
	print("added point")

	--label.text = "Points: " + (numP as string)
	
	mouseray = mapScreenToWorldRay mouse.pos
	format "mouseray: % \n" mouseray
	localhits = intersectRayScene mouseRay
	print localhits

	max_dist = 1000000
	global closest
	global closest_index = 1
	
	for i in 1 to (localhits.count) by 1 do
	(
		cdist = distance (localhits[i])[2].position mouseray.pos
		if cdist < max_dist then
		(
			max_dist = cdist
			closest = (localhits[i])[1]
			closest_index = i
		)
	)
	format "closest: % \n" closest
	
	--mySurface = (localhits[1])[1]
	--sectray = intersectRay mySurface mouseray
	--sectray = (localhits[1])[2]
	
	mySurface = closest
	sectray = (localhits[closest_index])[2]
	
	temp = Circle radius:3
		
	temp.pos = sectray.pos
	temp.dir = sectray.dir
	format "pos: % dir: % \n" sectray.pos sectray.dir
)


rollout SurfJump "Surface Jumper"
(
	--pickbutton UI_SelectedObject "Select Surface (op)"
	button UI_CreateJumps "Add Point"
	button UI_NumPoints "Points: 0" border:false
	
	global numP = 0
	global start = false
	global mySurface
	
	
	/*
	on UI_SelectedObject picked obj do
	(
		mySurface = obj
		UI_SelectedObject.text = obj.name
	)
	*/
	on UI_CreateJumps pressed do
	(
		if start == false then
		(
			
			--UI_CreateJumps.text = "Right Click!"
			start = true
			startTool mouseHandler
		)
		if start == true then
		(
			UI_CreateJumps.text = "Add Point"
			start = false
		)
	)
	
	/*
	on UI_CreateJumps pressed do
	(
		numP += 1
		UI_NumPoints.text = "Points: " + (numP as string)
		print("pressed")
		mouseray = mapScreenToWorldRay mouse.pos
		sectray = intersectRay mySurface mouseray
		
		temp = Circle radius:3
		
		temp.pos = sectray.pos
		temp.dir = sectray.dir
		format "pos: % dir: % \n" sectray.pos sectray.dir
	)
	*/
	--createPoint UI_NumPoints numP
	
)
tool mouseHandler
	(
		on mousePoint click do
		(
			if click == 1 and start == true then
			(
				numP += 1
				print(numP)
				createPoint numP
			)
			if click == 3 and start == true then #stop
		)
	)
	
--startTool mouseHandler
createdialog SurfJump
