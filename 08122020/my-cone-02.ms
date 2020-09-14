plugin simpleObject Cone_Mesh
name: "My Cone"
classID:#(0x7f9731ab, 0x614b501b)
category:"Plugins Class"
(
	parameters main rollout:Cone_Params
	(
		P_Radius type:#worldUnits ui:UI_Radius   default:10
		P_Height type:#worldUnits ui:UI_Height	default:15
		P_Sides type:#integer ui:UI_Sides	default:6
		P_VSegments type:#integer ui:UI_VSegments	default:2
	)

	rollout Cone_Params "Parameters"
	(
		spinner UI_Radius "Radius" type:#worldUnits range:[0,1000,10]
		spinner UI_Height "Height" type:#worldUnits range:[-1000,1000,15]
		spinner UI_Sides "Sides" type:#integer range:[3,30,6]
		spinner UI_VSegments "Vertical Segments" type:#integer range:[2,2,2]
	)


	on buildMesh do
	(
		Vertices =#()
		--genera vertices sin segmentos
		for i in 1 to P_Sides by 1 do
		(
			Vertices[i]=[P_Radius*cos(i*360/P_Sides),P_Radius*sin(i*360/P_Sides),0]
		)
		Vertices[(P_Sides*2)+1] = [0,0,0]
		Vertices[(P_Sides*2)+2] = [0,0,P_Height]

		for i in 1 to P_Sides by 1 do
		(
			Vertices[i+P_Sides]=[(P_Radius*cos(i*360/P_Sides)/P_VSegments),(P_Radius*sin(i*360/P_Sides)/P_VSegments),(P_Height/P_VSegments)]
		)


		Faces = #()
		--caras Arriba
		for i in 1 to P_Sides-1 by 1 do
		(
			Faces[i] = [(((P_Sides*2) - i )+1),((P_Sides*2) +2 ), ((P_Sides*2) - i )]
		)

		Faces[P_Sides] = [(1+P_Sides),(P_Sides*2)+2,(P_Sides*2)]
		--Faces[P_Sides] = [1,2,3]

		--Caras Tapa
		for i in 1 to P_Sides-1 by 1 do
		(
			Faces[i + P_Sides] = [i,(P_Sides*2)+1,i+1]
		)
		Faces[P_Sides * 2] = [P_Sides,(P_Sides*2)+1,1]

		setMesh mesh verts:Vertices faces:Faces

		for i in 1 to P_Sides by 1 do
		(
			setFaceSmoothGroup mesh (i) (1)
			setFaceSmoothGroup mesh (i+P_Sides) (2)
		)
	)

	tool create
	  (
		on mousePoint click do
		  case click of
		  (
			1: nodeTM.translation = gridPoint
			3: #stop
		   )

		on mouseMove click do
		  case click of
		(
			2: P_Radius = gridDist.x
			3: P_Height = gridDist.z
		)
  )


)
