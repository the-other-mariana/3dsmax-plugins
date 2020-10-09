fn createPoint numP cPoints=
(
	print("added point")

	--label.text = "Points: " + (numP as string)
	
	mouseray = mapScreenToWorldRay mouse.pos
	--format "mouseray: % \n" mouseray
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
	--format "closest: % \n" closest
	
	--mySurface = (localhits[1])[1]
	--sectray = intersectRay mySurface mouseray
	--sectray = (localhits[1])[2]
	
	mySurface = closest
	sectray = (localhits[closest_index])[2]
	
	temp = Circle radius:3
		
	temp.pos = sectray.pos
	temp.dir = sectray.dir
	Append cPoints temp
	
	--format "pos: % dir: % \n" sectray.pos sectray.dir
)

fn getAngle3D dir01 dir02=
(
	dir01 = normalize dir01
	dir02 = normalize dir02
	format "d01: % d02: % \n" dir01 dir02
	
	-- z to zero
	tDir01 = [dir01.x, dir01.y, 1]
	tDir02 = [dir02.x, dir02.y, 1]
	topAngle = acos(dot tDir02 tDir01)
	
	-- y to zero
	fDir01 = [dir01.x, 0, dir01.z]
	fDir02 = [dir02.x, 0, dir02.z]
	frontAngle = acos(dot fDir02 fDir01)
	print(dot fDir02 fDir01)
	-- x to zero 
	sDir01 = [0, dir01.y, dir01.z]
	sDir02 = [0, dir02.y, dir02.z]
	sideAngle = acos(dot sDir02 sDir01)
	
	angle3D = [sideAngle, frontAngle, topAngle]
	
	return angle3D
)

fn simpleJump jumpers circle01 circle03 initialFrame finalFrame=
(
	print "jump"
	
	TimeLapse = FinalFrame - InitialFrame
	point01 = circle01.pos
	point03 = circle03.pos
	height = distance point01 point03

	pointVector = point03 - point01
	halfVec = [0.5 * pointVector.x, 0.5 * pointVector.y, 0.5 * pointVector.z]
	middle = [(point01.x + point03.x)/2,(point01.y + point03.y)/2,(point01.z + point03.z)/2]
	halfVecRot = [halfVec.x * cos(90) - halfVec.y * sin(90), halfVec.y * cos(90) + halfVec.x * sin(90), 0]
	--halfVecRot = [1, 1, 0]
	
	q = quat 90 circle01.dir
	halfVec = (middle - point01)
	halfVecRot = halfVec  * q 
	
	heightVec = (normalize (cross halfVecRot halfVec)) * height 
	print(halfVecRot)
		
	--upVec = halfVec + heightVec + point01
	upVec = middle + heightVec
	
	point02 = upVec
	Vector01 = (point02 - point01)
	Vector02 = (point03 - point02)
	
	midPoint = box length:1 width:1 height:1
	midPoint.pos = upVec
	
	-- look at next point
	
	angle3D = getAngle3D circle01.dir circle03.dir
	stepXRot = angle3D[1] / (TimeLapse)
	stepYRot = angle3D[2] / (TimeLapse)
	stepZRot = angle3D[3] / (TimeLapse)
	format "angle3D: % \n" angle3D
	
	
	it = 0
	Animate on
	(
		for t in InitialFrame to FinalFrame by 1 do 
		(
			at time t
			(
				yFactor = dot circle03.dir pointVector
				format "y fac: % \n" yFactor
				if yFactor <= 0 then
				(
					yFactor = -1
				) else
				(
					yFactor = 1
				)
				
				point04 = ((normalize Vector01 )*(((length Vector01)/TimeLapse)*it))+point01
				point05 = ((normalize Vector02 )*(((length Vector02)/TimeLapse)*it))+point02
				Vector03 = (point05 - point04)
				
				Jumpers.pos = ((normalize Vector03 )*(((length Vector03)/TimeLapse)*it))+point04
				
				--rotate Jumpers (angleaxis (xFactor * stepXRot) [1,0,0])
				rotate Jumpers (angleaxis (yFactor * stepYRot) [0,1,0])
				--rotate Jumpers (angleaxis (-stepXRot) [0,0,1])
				--Jumpers.transform = (rotateYmatrix (yFactor * stepYRot)) * Jumpers.transform
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
			simpleJump jumpers cPoints[i] cPoints[i + 1] sTimer eTimer
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