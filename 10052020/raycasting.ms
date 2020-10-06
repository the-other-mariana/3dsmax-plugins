fn createPoint numP=
(
	print("added point")

	--label.text = "Points: " + (numP as string)
	
	mouseray = mapScreenToWorldRay mouse.pos
	sectray = intersectRay mySurface mouseray
		
	temp = Circle radius:3
		
	temp.pos = sectray.pos
	temp.dir = sectray.dir
	format "pos: % dir: % \n" sectray.pos sectray.dir
)


rollout SurfJump "Surface Jumper"
(
	pickbutton UI_SelectedObject "Select Surface"
	button UI_CreateJumps "Add Point"
	button UI_NumPoints "Points: 0" border:false
	
	global numP = 0
	global start = false
	
	on UI_SelectedObject picked obj do
	(
		global mySurface = obj
		UI_SelectedObject.text = obj.name
	)
	
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
