Fn MiddleJump Jumpers point01 point03 InitialFrame FinalFrame HeightVariation=
(
	print "hola"
	--format "initFrame: % finFrame: %" InitialFrame FinalFrame
	point02 = [(point01.x +point03.x)/2,(point01.y +point03.y)/2,(distance point01 point03)+HeightVariation]
	Vector01 = (point02 - point01)
	Vector02 = (point03 - point02)
	
	StretchFrames	=#(InitialFrame,InitialFrame + 1,InitialFrame +2,InitialFrame+3,((FinalFrame-InitialFrame)/2),FinalFrame - 1,FinalFrame)
	StretchValues	=#(0,-0.5,0,1.2,0,1.2,0)
	
	RotationFrames 	=#(InitialFrame,InitialFrame+1,FinalFrame - 1,FinalFrame)
	RotationValues		=#(0,20,-40,20)
	
	print Vector01
	print Vector02
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
		for t in 1 to StretchFrames.count by 1 do
		(
			at time StretchFrames[t]
			(
				Jumper.modifiers[#Stretch].Stretch = StretchValues[t]
			)
		)
		for t in 1 to RotationFrames.count by 1 do
		(
			at time RotationFrames[t]
			(
				rotate Jumper (angleaxis RotationValues[t] [1,0,0])
				
			)
		)
	)
)

Fn FinalJump Jumpers point01 point03 InitialFrame FinalFrame HeightVariation=
(
	
	point02 = [(point01.x +point03.x)/2,(point01.y +point03.y)/2,(distance point01 point03)+HeightVariation]
	Vector01 = (point02 - point01)
	Vector02 = (point03 - point02)
	
	StretchFrames	=#(InitialFrame,InitialFrame+1,((FinalFrame-InitialFrame)/2),FinalFrame - 1,FinalFrame)
	StretchValues	=#(0,1.2,0,1.2,0)
	
	RotationFrames 	=#(InitialFrame,InitialFrame+1,FinalFrame - 1,FinalFrame)
	RotationValues		=#(0,20,-40,20)
	Animate on
	(
		for t in InitialFrame to FinalFrame by 1 do 
		(
			at time t
			(
				point04 = ((normalize Vector01 )*(((length Vector01)/FinalFrame)*t))+point01
				point05 = ((normalize Vector02 )*(((length Vector02)/FinalFrame)*t))+point02
				Vector03 = (point05 - point04)
				
				Jumpers.pos = ((normalize Vector03 )*(((length Vector03)/FinalFrame)*t))+point04
			)
		)
		for t in 1 to StretchFrames.count by 1 do
		(
			at time StretchFrames[t]
			(
				Jumper.modifiers[#Stretch].Stretch = StretchValues[t]
			)
		)
		for t in 1 to RotationFrames.count by 1 do
		(
			at time RotationFrames[t]
			(
				rotate Jumper (angleaxis RotationValues[t] [1,0,0])
				
			)
		)
	)
)


Fn InitialJump Jumpers point01 point03 InitialFrame FinalFrame HeightVariation=
(
	
	point02 = [(point01.x +point03.x)/2,(point01.y +point03.y)/2,(distance point01 point03)+HeightVariation]
	Vector01 = (point02 - point01)
	Vector02 = (point03 - point02)
	
	StretchFrames	=#(InitialFrame-10,InitialFrame-5,InitialFrame,InitialFrame+1,((FinalFrame-InitialFrame)/2),FinalFrame - 1,FinalFrame)
	StretchValues	=#(0,-0.5,0,1.2,0,1.2,0)
	
	RotationFrames 	=#(InitialFrame,InitialFrame+1,FinalFrame - 1,FinalFrame)
	RotationValues		=#(0,20,-40,20)
	Animate on
	(
		for t in InitialFrame to FinalFrame by 1 do 
		(
			at time t
			(
				point04 = ((normalize Vector01 )*(((length Vector01)/FinalFrame)*t))+point01
				point05 = ((normalize Vector02 )*(((length Vector02)/FinalFrame)*t))+point02
				Vector03 = (point05 - point04)
				
				Jumpers.pos = ((normalize Vector03 )*(((length Vector03)/FinalFrame)*t))+point04
			)
		)
		for t in 1 to StretchFrames.count by 1 do
		(
			at time StretchFrames[t]
			(
				Jumper.modifiers[#Stretch].Stretch = StretchValues[t]
			)
		)
		for t in 1 to RotationFrames.count by 1 do
		(
			at time RotationFrames[t]
			(
				rotate Jumper (angleaxis RotationValues[t] [1,0,0])
				
			)
		)
	)
)
--Jumper = undefined

rollout Jumps "Jumps"
(
	pickbutton UI_SelectedObject "select jumper"
	spinner UI_HeightVariation "Height Variation" range:[-100,100,0] type:#integer
	spinner UI_InitialFrame "Initial Frame" range:[0,1000,0] type:#integer
	spinner UI_JumpFrame "Jump Frame" range:[10,1000,24] type:#integer
	spinner UI_Jumps "Number of Jumps" range:[1,1000,2] type:#integer
	button UI_CreateJumps "Create"
	
	on UI_SelectedObject picked obj do
	(
		global Jumper = obj
		UI_SelectedObject.text = obj.name
	)
	
	on UI_CreateJumps pressed do
	(
		if Jumper != undefined do
		(
			deleteKeys globalTracks #allKeys
			
			addModifier Jumper (Stretch())
			if not (validModifier Jumper (Stretch())) then
			(
				print "hola"
				--addModifier Jumper (Stretch())
			)
			
			tot_jumps = UI_Jumps.value
			endTime1 = UI_JumpFrame.value * 1
			initTime2 = endTime1 + 1
			endTime2 = UI_JumpFrame.value * 2
			
			InitialJump Jumper $Circle001.pos $Circle002.pos UI_InitialFrame.value endTime1 UI_HeightVariation.value
			MiddleJump Jumper $Circle002.pos $Circle003.pos initTime2 endTime2 UI_HeightVariation.value
			Jumper.showtrajectory =on
			
			print Jumper
		)			
	)
	
	
)

createdialog Jumps


