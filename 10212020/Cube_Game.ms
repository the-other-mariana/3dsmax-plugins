-- Vertex 1 4 6 7

Fn Roll Roller Direction iFrame eFrame=
(
	--Declaracion de la posicion final del pivote
	Vpos = [0,0,0]
	Axis = [0,0,0]
	RotAngle = -90
	
	--Determina vectes maximos y minmos de las cara inferior
	Rm = Roller.max
	Rmin = Roller.min
	Rmax = [Rm.x, Rm.y, Rmin.z]
	
	-- "Select Case" de la direccion del movimiento
	--Front
	if Direction == 1  do
	(	
		Axis = [1,0,0]
		Vpos = Rmax
	)
	--Left
	if Direction == 2 do
	(
		Axis = [0,1,0]
		Vpos = Rmin
	)
	--Right
	if Direction == 3 do
	(
		RotAngle = 90
		Axis = [0,1,0]
		Vpos = Rmax
	)
	--Back
	if Direction == 4 do
	(
		RotAngle = 90
		Axis = [1,0,0]
		Vpos = Rmin
	)
	Animate on
	(
		at time iFrame
		(
			Roller.pivot = Vpos
			rotate Roller (angleaxis 0 Axis)
		)
		at time eFrame
		(
			Roller.pivot = Vpos
			rotate Roller (angleaxis RotAngle Axis)
		)
	)
)

rollout CubeGame "Cube Game"
(
	pickbutton UI_SelectedObject "Select P1"
	
	button UI_Front "Front"
	button UI_Left "Left"
	button UI_Right "Right"
	button UI_Back "Back"
	
	on UI_SelectedObject picked obj do
	( 
		global T = 0
		global P1 = obj
		UI_SelectedObject.text = obj.name
		
		deletekeys P1
		try(deleteModifier P1 1) catch()
		addModifier P1 (Edit_Mesh())
	)
	
	on UI_Front pressed do
	(
		if P1 != undefined do
		(
			Roll P1 1 T (T+4)
			T += 5
		)			
	)
	
	on UI_Left pressed do
	(
		if P1 != undefined do
		(
			Roll P1 2 T (T+4)
			T += 5
		)			
	)
	
	on UI_Right pressed do
	(
		if P1 != undefined do
		(
			Roll P1 3 T (T+4)
			T += 5
		)			
	)
	
	on UI_Back pressed do
	(
		if P1 != undefined do
		(
			Roll P1 4 T (T+4)
			T += 5
		)			
	)
)

createdialog CubeGame