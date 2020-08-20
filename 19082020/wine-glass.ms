plugin simpleObject WineGlass_Mesh
name: "Wine Glass"
classID:#(0x17c21a1d, 0x581c10eb)
category:"Plugins Class"
(
	parameters main rollout:WGlass_Params
	(
		P_Radius type:#worldUnits ui:UI_Radius	default:10
		P_Height type:#worldUnits ui:UI_Height	default:20
		P_Sides type:#integer ui:UI_Sides	default:6
		P_Segments type:#integer ui:UI_Segments	default:1
	)
	
	rollout WGlass_Params "Parameters"
	(
		spinner UI_Radius "Radius" type:#worldUnits range:[0, 1000, 10]
		spinner UI_Height "Height" type:#worldUnits range:[-1000, 1000, 20]
		spinner UI_Sides "Sides" type:#integer range:[3, 30, 6]
		spinner UI_Segments "Segments" type:#integer range:[1,100,1]
	)
	
	on buildMesh do
	(
		vsegs = 5
		tot_segs = vsegs * P_Segments
		vertices = #()
		faces = #()
		
		dh = (P_Height * 1.0) / tot_segs
		
		for j in 1 to (tot_segs + 1) by 1 do
		(
			for i in 1 to (P_Sides) by 1 do
			(
				vertices[i + P_Sides * (j - 1)] = [(P_Radius) * cos(i * 360.0/P_Sides), (P_Radius) * sin(i * 360/P_Sides), dh * (j - 1)]
			)
		)
		
		vertices[(P_Sides * (tot_segs + 1)) + 1] = [0, 0, 0]
		vertices[(P_Sides * (tot_segs + 1)) + 2] = [0, 0, P_Height]
			
		last = 0
		for j in 1 to (tot_segs) by 1 do
		(
			last = 0
			for i in 1 to (P_Sides) by 1 do
			(
				if i == P_Sides then
				(
					last = P_Sides
				)
				-- first triangle
				faces[i + (P_Sides * 2) * (j - 1)] = [i + 1 + (P_Sides * (j - 1)) - last, i + 1 + (P_Sides * j) - last, i + (P_Sides * j)]
				-- second triangle
				faces[i + P_Sides + ((P_Sides * 2) * (j - 1))] = [i + (P_Sides * (j - 1)), i + 1 + (P_Sides * (j - 1)) - last, i + (P_Sides * j)]
			)
		)
		
		-- top faces
		last = 0
		for i in 1 to P_Sides by 1 do
		(
			if i == P_Sides then
			(
				last = P_Sides
			)
			faces[i + ((P_Sides * 2) * (tot_segs))] = [i + (P_Sides * (tot_segs)), (i + 1 + (P_Sides * (tot_segs))) - last, (P_Sides * (tot_segs + 1)) + 2]
		)
		
		-- bottom
		last = 0
		for i in 1 to P_Sides by 1 do
		(
			if i == P_Sides then
			(
				last = P_Sides
			)
			faces[i + ((P_Sides * 2) * (tot_segs)) + (P_Sides)] = [i, (P_Sides * (tot_segs + 1)) + 1,  i + 1 - last]
		)
		
		setMesh mesh verts:vertices faces:faces
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
				-- change here
				2: Radius = gridDist.x
				3: Height = gridDist.z
			)
		)
	)
)