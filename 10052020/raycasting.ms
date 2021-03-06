fn createPoint numP cPoints=
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
	Append cPoints temp
	
	format "pos: % dir: % \n" sectray.pos sectray.dir
)

fn simpleJump jumper point01 point03 initialFrame finalFrame =
(
	print "jump"
	
	height = distance point01 point03
	point02 = [((point01.x +point03.x)/2.0), ((point01.y +point03.y)/2.0), ((point01.z +point03.z)/2.0) + height]
	Vector01 = (point02 - point01)
	Vector02 = (point03 - point02)
	
	midPoint = box length:1 width:1 height:1
	midPoint.pos = point02
	
	it = 0
	
	/*
	Animate on
	(
		for t in InitialFrame to FinalFrame by 1 do 
		(
			at time t
			(
				TimeLapse = FinalFrame - InitialFrame
				
				point04 = ((normalize Vector01 )*(((length Vector01)/TimeLapse)*it))+point01
				point05 = ((normalize Vector02 )*(((length Vector02)/TimeLapse)*it))+point02
				Vector03 = (point05 - point04)
				
				Jumpers.pos = ((normalize Vector03 )*(((length Vector03)/TimeLapse)*it))+point04
			)
			it += 1
		)
	)*/
)

rollout SurfJump "Surface Jumper"
(
	pickbutton UI_SelectedObject "Select Jumper"
	button UI_AddPoint "Add Point"
	button UI_NumPoints "Points: 0" border:false
	button UI_CreateJumps "Create Jumps"
	spinner UI_JumpFrame "Jump Frame" range:[10,1000,24] type:#integer
	
	global numP = 0
	global start = false
	global mySurface
	global mouseHandler
	global cPoints = #()
	
	--print(UI_JumpFrame.value)
	jumpTime = (UI_JumpFrame.value)
	on UI_SelectedObject picked obj do
	(
		global jumper = obj
		UI_SelectedObject.text = obj.name
	)
	
	on UI_AddPoint pressed do
	(
		if start == false then
		(
			UI_AddPoint.text = "Right Click!"
			start = true
			startTool mouseHandler
		)
		if start == true then
		(
			UI_AddPoint.text = "Add Point"
			start = false
		)
		--print(cPoints)
	)
	
	on UI_CreateJumps pressed do
	(
		for i in 1 to (cPoints.count - 1) do
		(
			simpleJump jumper cPoints[i] cPoints[i + 1] ((i -1) * jumpTime) ((i) * jumpTime)
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
				createPoint numP cPoints
		)
		if click == 3 and start == true then #stop
	)
)
--startTool mouseHandler
createdialog SurfJump
