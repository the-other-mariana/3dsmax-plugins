
fn CreateBranch BranchParent BranchName=
(
	BranchScalar = random (BranchParent.Height * .30) (BranchParent.Height * .80)
	BranchPos = (BranchParent.dir * BranchScalar) + BranchParent.pos
	BranchRadius = BranchParent.Radius1  - ((BranchScalar*BranchParent.Radius1)/BranchParent.Height)
	BranchHeight = (BranchParent.Height - BranchScalar) * (Random 0.8 1.2)
	Branch = Cone radius1:BranchRadius radius2:0 height:BranchHeight pos:BranchPos isSelected:on name:BranchName
	Branch.wirecolor = Color 0 (Random 45 60)  (Random 5 20)
	Branch.dir = BranchParent.dir
	BranchZAngle = Random 0 359 -- around the whole parent angle
	BranchAngle = Random 30.0 80.0

	Branch.transform = (RotateZMatrix (BranchZAngle)) * Branch.transform
	Branch.transform = (RotateYMatrix (BranchAngle)) * Branch.transform
	Branch.parent = BranchParent
	return Branch
)

fn CreateApple AppleParent AppleName=
(
	Fruit = Sphere radius:(AppleParent.Radius1 * 3) isSelected:on name:AppleName
	Fruit.pos = (AppleParent.dir * (AppleParent.height+Fruit.Radius)) + AppleParent.pos
	Fruit.wirecolor = red
	Fruit.parent = AppleParent
	return Fruit
)

fn AnimateBranch BranchToAnimate InitialFrame FinalFrame=
(
	InitialHeight = BranchToAnimate.height
	InitialRadius = BranchToAnimate.Radius1
	
	
	ScalarPercent = (length (BranchToAnimate.pos - BranchToAnimate.parent.pos)) / BranchToAnimate.parent.height
	
	
	
	Animate on
	(
		at time 0
		(
			BranchToAnimate.height = 0
			BranchToAnimate.Radius1 = 0
		)
		at time InitialFrame
		(
			BranchToAnimate.height = 0
			BranchToAnimate.Radius1 = 0
		)
		at time FinalFrame
		(
			BranchToAnimate.height = InitialHeight
			BranchToAnimate.Radius1 = InitialRadius
		)
		
		for t in 0 to 110 by 1 do
		(
			at time t
			(
				TempScalar = (BranchToAnimate.parent.height * ScalarPercent)
				BranchToAnimate.pos = (BranchToAnimate.parent.dir * TempScalar) + BranchToAnimate.parent.pos
				tempRadius = BranchToAnimate.parent.radius1 - ((TempScalar*BranchToAnimate.parent.radius1)/BranchToAnimate.parent.Height)
				BranchToAnimate.radius1 = tempRadius
			)
		)
			
	)
)

fn AnimateTrunk TrunkToAnimate InitialFrame FinalFrame=
(
	InitialHeight = TrunkToAnimate.height
	InitialRadius = TrunkToAnimate.Radius1
	
	Animate on
	(
		at time 0
		(
			TrunkToAnimate.height = 0
			TrunkToAnimate.Radius1 = 0
		)
		at time InitialFrame
		(
			TrunkToAnimate.height = 0
			TrunkToAnimate.Radius1 = 0
		)
		at time FinalFrame
		(
			TrunkToAnimate.height = InitialHeight
			TrunkToAnimate.Radius1 = InitialRadius
		)
	)
	
)

fn AnimateFruit FruitToAnimate InitialFrame FinalFrame=
(
	InitialRadius = FruitToAnimate.radius
	Animate on
		(
			at time 0
			(
				FruitToAnimate.Radius = 0
			)
			at time InitialFrame
			(
				FruitToAnimate.Radius = 0
			)
			at time FinalFrame
			(
				FruitToAnimate.Radius = InitialRadius
			)
			
			for t in InitialFrame to FinalFrame by 1 do
			(
				at time t
				(
					FruitToAnimate.pos = (FruitToAnimate.parent.dir * (FruitToAnimate.parent.height + FruitToAnimate.radius)) + FruitToAnimate.parent.pos
				)
			)
		)
)

rollout BranchRollout "Tree Properties"
(
	Label UI_Label_Trunk "Trunk"
	spinner UI_Trunk "Size" range:[10,300,100] type:#float scale:0.1
	colorpicker UI_TrunkColor "Trunk Color" color:[16,11,7]
	Label UI_Label_Branch "Branches"
	spinner UI_Branches "Branches" range:[1,100,5] type:#integer
	button UI_Create "Create Tree"
	
	on UI_Create pressed do
	(
		
		Delete objects
		TrunkRadius = Random 5.0 15.0

		Trunk = Cone radius1:TrunkRadius radius2:0 height:UI_Trunk.value pos:[0,0,0] isSelected:on name:"Trunk"
		Trunk.wirecolor = UI_TrunkColor.color

		BranchNumber = UI_Branches.value--Random 5 10
		for i in 1 to BranchNumber do
			(
				CreateBranch Trunk ("Branch" + (i as string))
			)

		Branches = $Branch*
		print Branches
		Leaves = #()
		LeavesNumber = Random 1 3
		for i in 1 to Branches.count do
		(
			for j in 1 to LeavesNumber do
				(
					temp = createBranch Branches[i] ("Leave" +( j as string))
					Append Leaves temp
				)
			
		)
		LeaveTwo = #()
		print Leaves.count
		LeavesTwoNumber = Random 1 3
		for i in 1 to Leaves.count do
		(
			for j in 1 to LeavesTwoNumber do
				(
					temp = CreateBranch Leaves[i] (Leaves[i].name+"_LeaveTwo" +( j as string))
					Append LeaveTwo temp
				)
			
		)

		Fruits = #()
		for i in 1 to LeaveTwo.count do
		(
			temp = CreateApple LeaveTwo[i] ("Fruit"+ (i as string))
			Append Fruits temp
		)

		AnimateTrunk $Trunk 0 30

		for i in 1 to Branches.count do
		(
			AnimateBranch Branches[i] 15 40
		)
		for i in 1 to Leaves.count do
		(
			AnimateBranch Leaves[i] 25 55
		)
		for i in 1 to LeaveTwo.count do
		(
			AnimateBranch LeaveTwo[i] 35 70
		)
		for i in 1 to Fruits.count do
		(
			AnimateFruit Fruits[i]  55 80
		)
			)
			
)
createDialog BranchRollout







 
