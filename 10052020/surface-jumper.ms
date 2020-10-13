fn createPoint numP cPoints=
(
	print("added point")

	mouseray = mapScreenToWorldRay mouse.pos
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
	mySurface = closest
	sectray = (localhits[closest_index])[2]
	
	temp = Circle radius:3
	temp.wirecolor = color 0 0 0
	temp.pos = sectray.pos
	temp.dir = sectray.dir
	Append cPoints temp
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

fn getBiasedMiddle point01 point03 height=
(
	
	pointVector = point03 - point01
	halfVec = [0.5 * pointVector.x, 0.5 * pointVector.y, 0.5 * pointVector.z]
	halfVecRot = [halfVec.x * cos(90) - halfVec.y * sin(90), halfVec.y * cos(90) + halfVec.x * sin(90), 0]
	heightVec = (normalize (cross halfVec halfVecRot)) * height 
		
	upVec = halfVec + heightVec + point01
	
	return upVec
	
)

fn getQuatMiddle point01 point03 axis height=
(
	
	pointVector = point03 - point01
	middle = [(point01.x + point03.x)/2,(point01.y + point03.y)/2,(point01.z + point03.z)/2]
	
	q = quat 90 axis
	halfVec = (middle - point01)
	halfVecRot = halfVec  * q 
	
	heightVec = (normalize (cross halfVecRot halfVec)) * height 
	print(halfVecRot)
	upVec = middle + heightVec
	return upVec
)

fn simpleJump jumpers circle01 circle03 initialFrame finalFrame interp rollAngle heightVal squashLim sqTime index=
(
	print "jump"
	
	format "circle03: %\n" circle03.dir
	q = quat 33 circle03.dir
	circle03.dir = circle03.dir * q
	format "circle03: %\n" circle03.dir
	
	TimeLapse = FinalFrame - InitialFrame
	point01 = circle01.pos
	point03 = circle03.pos
	global point02

	height = heightVal
	pointVector = point03 - point01
	
	if interp == 1 then
	(
		point02 = getQuatMiddle point01 point03 circle01.dir height
	) else
	(
		point02 = getBiasedMiddle point01 point03 height
	)
	--point02 = getBiasedMiddle point01 point03 height
	Vector01 = (point02 - point01)
	Vector02 = (point03 - point02)
	
	-- look at next point
	/*
	angle3D = getAngle3D circle01.dir circle03.dir
	stepXRot = angle3D[1] / (TimeLapse)
	stepYRot = angle3D[2] / (TimeLapse)
	stepZRot = angle3D[3] / (TimeLapse)
	format "angle3D: % \n" angle3D*/
	
	xRotJumper = (circle01.dir.x) 
	yRotJumper = (circle01.dir.y)
	zRotJumper = (circle01.dir.z)
	
	xFinRot = (circle03.dir.x)
	yFinRot = (circle03.dir.y)
	zFinRot = (circle03.dir.z)
	
	stepXRot = (xFinRot - xRotJumper) / (TimeLapse)
	stepYRot = (yFinRot - yRotJumper) / (TimeLapse)
	stepZRot = (zFinRot - zRotJumper) / (TimeLapse)
	
	--format "transf: % \n" jumpers.transform.controller.value
	--format "transf: % \n" ((quatToEuler jumpers.transform.rotationpart))
	--format "transf: % \n" jumpers.transform.controller[3].value
	--format "transf: % \n" jumpers.transform
	format "transf: % \n" ((jumpers.transform.controller.value).row1) -- [1, 0, 0]
	
	xVec = (jumpers.transform.controller.value).row1
	yVec = (jumpers.transform.controller.value).row2
	
	xVec = normalize xVec
	yVec = normalize yVec
	
	
	pVec = normalize pointVector
	lookAngle = acos(dot pVec xVec)
	
	rotDot = (dot pVec yVec)
	rotFactor = 1
	
	if rotDot <= 0 then rotFactor = -1
	--format "dot: % \n" rotDot
	--format "lookat: % \n" lookAngle 
	--jumpers.transform = (rotateZmatrix (rotFactor * lookAngle)) * jumpers.transform
	
	--jumpers.transform = (rotateZmatrix (45)) * jumpers.transform
	--circle03.transform = (rotateZmatrix 45) * circle03.transform
	--funFactor = 90.0 / TimeLapse
	funFactor = (rollAngle) / TimeLapse
	
	StretchFrames	=#(initialFrame, initialFrame + sqTime, finalFrame - sqTime, finalFrame)
	StretchValues	=#((-squashLim), 0, 0,(-squashLim))
	
	it = 0
	fr = 0
	extraSq = false
	
	if (index == 1) then 
	(
		extraSq = true
		fr = initialFrame - sqTime
	)
	if (index == (cPoints.count - 1)) then 
	(
		extraSq = true
		fr = finalFrame + sqTime
	)
	
	Animate on
	(
		for t in InitialFrame to FinalFrame by 1 do 
		(
			at time t
			(
				yFactor = dot circle03.dir pointVector
				--format "y fac: % \n" yFactor
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
				--rotate Jumpers (angleaxis (yFactor * stepYRot) [0,1,0])
				--rotate Jumpers (angleaxis (-stepXRot) [0,0,1])
				--Jumpers.transform = (rotateYmatrix (yFactor * stepYRot)) * Jumpers.transform
				eulerJumper = quatToEuler2 Jumpers.rotation.controller.value
				
				
				--format "stepx: % stepy: % stepz: % crot: % jrot: % \n" stepXRot stepYRot stepZRot circle03.dir (jumpers.dir)
				
				--rotate Jumpers (angleaxis (stepXRot) [1,0,0])
				--rotate Jumpers (angleaxis (stepYRot) [0,1,0])
				--rotate Jumpers (angleaxis (stepZRot) [0,0,1])
				--rotate Jumpers (angleaxis (yFactor * stepYRot) [0,1,0])
				--rotate Jumpers (angleaxis (-stepXRot) [0,0,1])
				
				jumpers.dir.x += stepXRot
				jumpers.dir.y += stepYRot
				jumpers.dir.z += stepZRot
				
				if t == FinalFrame then
				(
					--jumpers.dir = circle03.dir
				)
				
				if t == 1 then
				(
					--jumpers.dir = circle01.dir
				)
				
				-- rotate locally
				jumpers.transform = (rotateZmatrix (funFactor * t)) * jumpers.transform
				
				
			)
			it += 1
		)
		
		for t in 1 to (StretchFrames.count) by 1 do
		(
			at time StretchFrames[t]
			(
				jumpers.modifiers[#Stretch].Stretch = StretchValues[t]
			)
		)
		
		if (extraSq == true) then
		(
			at time fr 
			(
				extraSq = false
				jumpers.modifiers[#Stretch].Stretch = 0
			)
		) 
	)
)

rollout SurfJump "Surface Jumper"
(
	group "Getting Started"
	(
		pickbutton UI_SelectedObject "Select Jumper"
		button UI_AddPoint "Add Point"
		button UI_NumPoints "Points: 0" border:false
	)
	
	group "Jump Params"
	(
		dropdownlist Interp_dd "Interpolation Style" items:#("Physical", "Biased")
		spinner UI_JumpFrames "Frames per Jump" range:[10,1000,24] type:#integer
		spinner UI_RollAngle "Roll Angle" range:[45.0,180.0,90.0] type:#float
	)
	
	group "Jump Sequence Params"
	(
		dropdownlist Strength_dd "Jump Strength" items:#("Constant", "Distanced", "Decay", "Growth")
		spinner UI_StrengthVal "Strength Value" range:[5.0,100.0,15.0] type:#float
		spinner UI_SquashFrames "Squash Frames" range:[1,1000, 5] type:#integer
		slider UI_SquashLim "Squash Limit" orient:#horizontal ticks:8 range:[0.0,0.8, 0.4]
	)
	
	button UI_CreateJumps "Create Jumps"
	
	global numP = 0
	global start = false
	global mySurface
	global mouseHandler
	global strengthOp = 1
	global interp = 1
	global squashLim = 0.5
	global cPoints = #()
	global sqTime = 1

	global heightVal

	
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
			UI_NumPoints.text = "Points: " + (numP as String)
			start = false
		)
		--print(cPoints)
	)
	
	on Interp_dd selected i do
	(
		interp = i
		format "You selected '%'! index: % \n" Interp_dd.items[i] i
	)
	
	on Strength_dd selected i do
	(
		strengthOp = i
		--format "You selected '%'! index: % \n" Strength_dd.items[i] i
	)
	
	on UI_CreateJumps pressed do
	(
		if jumpers != undefined then
		(
			deleteKeys globalTracks #allKeys
		) else
		(
			messageBox "Please select a jumper object!" title:"Jumper Missing" beep:true
		)
		print(cPoints)
		
		addModifier jumpers (Stretch())
		
		extraFrame = 0
		jumpTime = UI_JumpFrames.value
		rollAngle = UI_RollAngle.value
		heightVal = UI_StrengthVal.value
		squashLim = UI_SquashLim.value
		sqTime = UI_SquashFrames.value
		
		startTimer = 0
		endTimer = 0
		jumpers.dir = cPoints[1].dir
		
		decayFactor = 1
		growthFactor = 1
		for i in 1 to (cPoints.count - 1) by 1 do
		(
			if i > 1 then extraFrame = 1
			sTimer = (i - 1) * jumpTime + extraFrame
			eTimer = (i) * jumpTime
			
			format "option s: % \n" strengthOp
			if strengthOp == 2 then
			(
				-- distanced
				heightVal = distance cPoints[i].pos cPoints[i + 1].pos
			)
			if strengthOp == 3 then
			(
				-- decay
				
				heightVal = UI_StrengthVal.value * (cPoints.count - (i))
				format "You selected decay: %" heightVal
			)
			if strengthOp == 4 then
			(
				-- growth
				--heightVal = UI_StrengthVal.value + ((i - 1) * (UI_StrengthVal.value * 0.5))
				heightVal = UI_StrengthVal.value * (i)
			)
			
			simpleJump jumpers cPoints[i] cPoints[i + 1] sTimer eTimer interp rollAngle heightVal squashLim sqTime i
		)
		Jumpers.showtrajectory =on
	)
	
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
createdialog SurfJump width:200 height:425
