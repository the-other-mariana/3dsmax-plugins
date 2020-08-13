plugin simpleObject Cone_Mesh
name: "My Cone"
classID:#(0x1147bb62, 0x19edf635)
category:"Plugins Class"
(
	parameters main rollout:Cone_Params
	(
		P_Radius type:#worldUnits ui:UI_Radius	default:10
		P_Height type:#worldUnits ui:UI_Height	default:15
		P_Sides type:#integer ui:UI_Sides	default:6
		P_VSegments type:#integer ui:UI_VSegments	default:3
	)
	
	rollout Cone_Params "Parameters"
	(
		spinner UI_Radius "Radius" type:#worldUnits range:[0, 1000, 10]
		spinner UI_Height "Height" type:#worldUnits range:[-1000, 1000, 15]
		spinner UI_Sides "Sides" type:#integer range:[3, 30, 6]
		spinner UI_VSegments "V Segments" type:#integer range:[2,100,3]
	)
	

	
	on buildMesh do
	(
		Vertices = #()
		
		dh = (P_Height * 1.0) / P_VSegments
		dr = (P_Radius * 1.0) / P_VSegments
		
		for j in 1 to (P_VSegments) by 1 do
		(
			for i in 1 to (P_Sides) by 1 do
			(
				Vertices[i + P_Sides * (j - 1)] = [(P_Radius - dr * (j - 1)) * cos(i * 360.0/P_Sides), (P_Radius - dr * (j - 1)) * sin(i * 360/P_Sides), dh * (j - 1)]
			)
		)
		
		Vertices[(P_Sides * P_VSegments) + 1] = [0, 0, 0]
		Vertices[(P_Sides * P_VSegments) + 2] = [0, 0, P_Height]
		
		Faces = #()
		Last = 0
		for j in 1 to P_VSegments - 1 by 1 do
		(
			Last = 0
			for i in 1 to (P_Sides) by 1 do
			(
				if i == P_Sides then
				(
					Last = P_Sides
				)
				-- (Quad) Faces[i + P_Sides * (j - 1)] = [i + 1 + (P_Sides * (j - 1)), i + 1 + (P_Sides * j), i + (P_Sides * j), i + (P_Sides * (j - 1))]
				-- first triangle
				Faces[i + (P_Sides * 2) * (j - 1)] = [i + 1 + (P_Sides * (j - 1)) - Last, i + 1 + (P_Sides * j) - Last, i + (P_Sides * j)]
				-- second triangle
				Faces[i + P_Sides + ((P_Sides * 2) * (j - 1))] = [i + (P_Sides * (j - 1)), i + 1 + (P_Sides * (j - 1)) - Last, i + (P_Sides * j)]
			)
		)
		
		-- top cone faces
		Last = 0
		for i in 1 to P_Sides by 1 do
		(
			if i == P_Sides then
			(
				Last = P_Sides
			)
			Faces[i + ((P_Sides * 2) * (P_VSegments - 1))] = [i + (P_Sides * (P_VSegments - 1)), (i + 1 + (P_Sides * (P_VSegments - 1))) - Last, (P_Sides * P_VSegments) + 2]
		)
		
		-- bottom
		Last = 0
		for i in 1 to P_Sides by 1 do
		(
			if i == P_Sides then
			(
				Last = P_Sides
			)
			Faces[i + (P_Sides * P_VSegments) + (P_Sides * 2)] = [i, (P_Sides * P_VSegments) + 1,  i + 1 - Last]
		)
		
	
		setMesh mesh verts:Vertices faces:Faces
		
		for i in 1 to ((P_Sides * 2) * (P_VSegments)) by 1 do
		(
			if i > ((P_Sides * P_VSegments) + (P_Sides * 2)) then
			(
				setFaceSmoothGroup mesh (i) (2)
			) else
			(
				setFaceSmoothGroup mesh (i) (1)
			)
			
		)
	)
	
	tool create
	(
		on mousePoint click do
		(
			case click of
			(
				1: nodeTM.translation = gridPoint
				3: #stop
			)
		)
		on mouseMove click do
		(
			case click of
			(
				2: P_Radius = gridDist.x
				3: P_Height = gridDist.z
			)
		)
	)
)