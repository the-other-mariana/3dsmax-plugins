Fn Jump Jumpers point01 point03 InitialFrame FinalFrame HeightVariation=
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
	spinner UI_FinalFrame "Final Frame" range:[10,1000,10] type:#integer
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
			addModifier Jumper (Stretch())
			InitialJump Jumper $Circle002.pos  $Circle001.pos UI_InitialFrame.value UI_FinalFrame.value UI_HeightVariation.value
			Jumper.showtrajectory =on
			
			print Jumper
		)			
	)
	
	
)

createdialog Jumps


