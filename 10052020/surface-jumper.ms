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

fn get3DAngle dir01 dir02=
(
	dir01 = normalize dir01
	dir02 = normalize dir02
	
	bAngle = acos((dot dir02 dir01))
	return bAngle
)

fn simpleJump jumpers point01 point03 initialFrame finalFrame=
(
	print "jump"
	
	height = distance point01 point03

	pointVector = point03 - point01
	halfVec = [0.5 * pointVector.x, 0.5 * pointVector.y, 0.5 * pointVector.z]
	halfVecRot = [halfVec.x * cos(90) - halfVec.y * sin(90), halfVec.y * cos(90) + halfVec.x * sin(90), 0]
	--halfVecRot = [1, 1, 0]
	heightVec = (normalize (cross halfVec halfVecRot)) * height 
	print(halfVecRot)
		
	upVec = halfVec + heightVec + point01
	
	point02 = upVec
	Vector01 = (point02 - point01)
	Vector02 = (point03 - point02)
	
	midPoint = box length:1 width:1 height:1
	midPoint.pos = upVec
	
	it = 0
	
	
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
	)
)

rollout SurfJump "Surface Jumper"
(
	pickbutton UI_SelectedObject "Select Jumper"
	button UI_AddPoint "Add Point"
	button UI_NumPoints "Points: 0" border:false
	button UI_CreateJumps "Create Jumps"
	spinner UI_JumpFrames "Frames per Jump" range:[10,1000,24] type:#integer
	
	global numP = 0
	global start = false
	global mySurface
	global mouseHandler
	global cPoints = #()
	
	on UI_SelectedObject picked obj do
	(
		global jumpers = obj
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
		if jumpers != undefined then
		(
			deleteKeys globalTracks #allKeys
		)
		print(cPoints)
		jumpTime = UI_JumpFrames.value
		startTimer = 0
		endTimer = 0
		for i in 1 to (cPoints.count - 1) by 1 do
		(
			sTimer = (i - 1) * jumpTime
			eTimer = (i) * jumpTime
			format "s: % e: % \n" sTimer eTimer
			simpleJump jumpers cPoints[i].pos cPoints[i + 1].pos sTimer eTimer
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
