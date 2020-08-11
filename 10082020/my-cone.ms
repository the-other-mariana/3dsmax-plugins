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
	)
	
	rollout Cone_Params "Parameters"
	(
		spinner UI_Radius "Radius" type:#worldUnits range:[0, 1000, 10]
		spinner UI_Height "Height" type:#worldUnits range:[-1000, 1000, 15]
		spinner UI_Sides "Sides" type:#integer range:[3, 30, 6]
	)
	
	on buildMesh do
	(
		Vertices = #()
		for i in 1 to P_Sides by 1 do
		(
			Vertices[i] = [P_Radius * cos(i * 360.0/P_Sides), P_Radius * sin(i * 360/P_Sides), 0]
		)
		Vertices[P_Sides + 1] = [0, 0, 0]
		Vertices[P_Sides + 2] = [0, 0, P_Height]
		
		Faces = #([6, 1, P_Sides + 2], [6, P_Sides + 2, 5])
		setMesh mesh verts:Vertices faces:Faces
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
		on mousePoint click do
		(
			case click of
			(
				2: Radius = gridDist.x
				3: Height = gridDist.z
			)
		)
	)
)