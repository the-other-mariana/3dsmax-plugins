
fn CreateBranch BranchParent BranchName=
(
	BranchScalar = random (BranchParent.Height * .30) (BranchParent.Height * .80)
	BranchPos = (BranchParent.dir * BranchScalar) + BranchParent.pos
	BranchRadius = BranchParent.Radius1  - ((BranchScalar*BranchParent.Radius1)/BranchParent.Height)
	BranchHeight = (BranchParent.Height - BranchScalar) * (Random 0.8 1.2)
	Branch = Cone radius1:BranchRadius radius2:0 height:BranchHeight pos:BranchPos isSelected:on name:BranchName
	Branch.wirecolor = Color 0 (Random 45 60)  (Random 5 20)
	Branch.dir = BranchParent.dir
	BranchZAngle = Random 0 359
	BranchAngle = Random 30.0 80.0

	Branch.transform = (RotateZMatrix (BranchZAngle)) * Branch.transform
	Branch.transform = (RotateYMatrix (BranchAngle)) * Branch.transform
	return Branch
)

fn CreateApple AppleParent AppleName=
(
	Fruit = Sphere radius:(AppleParent.Radius1 * 3) isSelected:on name:AppleName
	Fruit.pos = (AppleParent.dir * (AppleParent.height+Fruit.Radius)) + AppleParent.pos
	Fruit.wirecolor = red
)


Delete objects

TrunkHeight = Random 150 200
TrunkRadius = Random 5.0 15.0

Trunk = Cone radius1:TrunkRadius radius2:0 height:TrunkHeight pos:[0,0,0] isSelected:on name:"Trunk"
Trunk.wirecolor = color 16 11 7

BranchNumber = Random 5 20
for i in 1 to BranchNumber do
	(
		CreateBranch Trunk ("Branch" + (i as string))
	)

Branches = $Branch*
print Branches
Leaves = #()
LeavesNumber = Random 1 5
for i in 1 to Branches.count do
(
	for j in 1 to LeavesNumber do
		(
			temp = createBranch Branches[i] ("Branch"+(i as string)+"_Leave" +( j as string))
			Append Leaves temp
		)
	
)
LeaveTwo = #()
print Leaves.count
LeavesTwoNumber = Random 1 5
for i in 1 to Leaves.count do
(
	for j in 1 to LeavesTwoNumber do
		(
			temp = CreateBranch Leaves[i] (Leaves[i].name+"_LeaveTwo" +( j as string))
			Append LeaveTwo temp
		)
	
)


for i in 1 to LeaveTwo.count do
(
	 CreateApple LeaveTwo[i] (leaveTwo[i].name+"Fruit"+ (i as string))
)



