fn createTree Pos Rad=
(
	cono =Cone radius1:Rad radius2:0 height:(Rad*3) pos:[Pos.x,Pos.y,Pos.z +(Rad/2)]
	Tronco = Cylinder radius:(Rad/4) height:(Rad/2) pos:Pos
	Tronco.parent = cono
)

NumTrees = 20


for i in 1 to numTrees do
(
	rand = random 0.0 1.0
	posi = lengthInterp $Camino 1 rand
	tang = lengthTangent $Camino 1 rand

	offset = random 10 20  * (if i < numTrees / 2 then 1 else -1)
	offsetVector = cross tang [0,0,1] * offset
	offsetPos = offsetVector + posi
	treeRay = ray [offsetPos.x,offsetPos.y,1000] [0,0,-1]
	
	ChoqueRay = intersectRay  $Piso  treeRay
	treePos = ChoqueRay.pos
	treeRad = random 1.0 10.0
	
	createTree treePos treeRad
)



