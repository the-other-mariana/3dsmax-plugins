fn createPoint numP cPoints=
(

	mouseray = mapScreenToWorldRay mouse.pos
	localhits = intersectRayScene mouseRay

	max_dist = 1000000
	global closest
	global closest_index = 1
	
	if localhits.count == 0 then
	(
		return messageBox "Place a point in a surface!" title:"No Surface Found" beep:true
	)
	
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
	
	upVec = middle + heightVec
	return upVec
)

fn simpleJump jumpers circle01 circle03 initialFrame finalFrame interp rollAngle heightVal squashLim sqTime index cPoints=
(
	
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
	
	Vector01 = (point02 - point01)
	Vector02 = (point03 - point02)
	
	xRotJumper = (circle01.dir.x) 
	yRotJumper = (circle01.dir.y)
	zRotJumper = (circle01.dir.z)
	
	xFinRot = (circle03.dir.x)
	yFinRot = (circle03.dir.y)
	zFinRot = (circle03.dir.z)
	
	stepXRot = (xFinRot - xRotJumper) / (TimeLapse)
	stepYRot = (yFinRot - yRotJumper) / (TimeLapse)
	stepZRot = (zFinRot - zRotJumper) / (TimeLapse)
	
	--format "transf: % \n" ((jumpers.transform.controller.value).row1) -- [1, 0, 0]
	
	xVec = (jumpers.transform.controller.value).row1
	yVec = (jumpers.transform.controller.value).row2
	
	xVec = normalize xVec
	yVec = normalize yVec
	
	
	pVec = normalize pointVector
	lookAngle = acos(dot pVec xVec)
	
	rotDot = (dot pVec yVec)
	rotFactor = 1
	
	if rotDot <= 0 then rotFactor = -1
	
	
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
				point04 = ((normalize Vector01 )*(((length Vector01)/TimeLapse)*it))+point01
				point05 = ((normalize Vector02 )*(((length Vector02)/TimeLapse)*it))+point02
				Vector03 = (point05 - point04)
				
				Jumpers.pos = ((normalize Vector03 )*(((length Vector03)/TimeLapse)*it))+point04
				
				--eulerJumper = quatToEuler2 Jumpers.rotation.controller.value
				
				jumpers.dir.x += stepXRot
				jumpers.dir.y += stepYRot
				jumpers.dir.z += stepZRot
				
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
		spinner UI_RollAngle "Roll Angle" range:[10.0,120.0,90.0] type:#float
	)
	
	group "Jump Sequence Params"
	(
		dropdownlist Strength_dd "Jump Strength" items:#("Constant", "Distanced", "Decay", "Growth")
		spinner UI_StrengthVal "Strength Value" range:[5.0,100.0,15.0] type:#float
		spinner UI_SquashFrames "Squash Frames" range:[1,500, 5] type:#integer
		slider UI_SquashLim "Squash Limit" orient:#horizontal ticks:5 range:[0.0,0.5, 0.4]
		checkbox ConstSquash_cb "Constant Squash"
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
		cPoints = #()
		numP = 0
		UI_NumPoints.text = "Points: " + (numP as String)
	)
	
	on UI_AddPoint pressed do
	(
		if (isValidNode jumpers) == false then
		(
			jumpers = undefined
			return messageBox "Please select a jumper object!" title:"Jumper Missing" beep:true
		)
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
	)
	
	on Interp_dd selected i do
	(
		interp = i
	)
	
	on Strength_dd selected i do
	(
		strengthOp = i
	)
	
	on UI_CreateJumps pressed do
	(
		UI_SelectedObject.text = "Select Jumper"
		if jumpers != undefined then
		(
			deleteKeys globalTracks #allKeys
		) else
		(
			return messageBox "Please select a jumper object!" title:"Jumper Missing" beep:true
		)
		
		if (isValidNode jumpers) == false then
		(
			jumpers = undefined
			return messageBox "Please select a jumper object!" title:"Jumper Missing" beep:true
		)
		
		if cPoints.count < 2 then
		(
			return messageBox "You need more than 1 point to jump!" title:"Points Missing" beep:true
		)

		if (for m in jumpers.modifiers where classof m == stretch collect m).count == 0 then
		(
			addModifier jumpers (Stretch())
		)
		
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
		stepSquash = squashLim / (cPoints.count - 1)
		for i in 1 to (cPoints.count - 1) by 1 do
		(
			if i > 1 then extraFrame = 1
			sTimer = (i - 1) * jumpTime + extraFrame
			eTimer = (i) * jumpTime
			
			if strengthOp == 1 then
			(
				-- constant
				heightVal = UI_StrengthVal.value
			)
			if strengthOp == 2 then
			(
				-- distanced
				heightVal = distance cPoints[i].pos cPoints[i + 1].pos
			)
			if strengthOp == 3 then
			(
				-- decay
				heightVal = UI_StrengthVal.value * (cPoints.count - (i))
				if (constSquash_cb.checked) == false then
					squashLim = UI_SquashLim.value - (stepSquash * (i - 1))
			)
			if strengthOp == 4 then
			(
				-- growth
				heightVal = UI_StrengthVal.value * (i)
				if (constSquash_cb.checked) == false then
					squashLim = (UI_SquashLim.value - (stepSquash * (cPoints.count - 1))) + (stepSquash * i)
			)
			
			simpleJump jumpers cPoints[i] cPoints[i + 1] sTimer eTimer interp rollAngle heightVal squashLim sqTime i cPoints
		)
		Jumpers.showtrajectory =on
			
		jumpers = undefined
	)
	
)

tool mouseHandler
(
	on mousePoint click do
	(
		if click == 1 and start == true then
		(
				numP += 1
				
				createPoint numP cPoints
		)
		if click == 3 and start == true then #stop
	)
)

createdialog SurfJump width:200 height:450
