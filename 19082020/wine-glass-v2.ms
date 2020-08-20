plugin simpleObject WineGlass2_Mesh
name: "Wine Glass2"
classID:#(0x3c1de37d, 0x3594949b)
category:"Plugins Class"
(
	parameters main rollout:WGlass_Params
	(
		P_Radius type:#worldUnits ui:UI_Radius	default:10
		P_Height type:#worldUnits ui:UI_Height	default:30
		P_Sides type:#integer ui:UI_Sides	default:6
		P_Segments type:#integer ui:UI_Segments	default:2
	)
	
	rollout WGlass_Params "Parameters"
	(
		spinner UI_Radius "Radius" type:#worldUnits range:[0, 1000, 10]
		spinner UI_Height "Height" type:#worldUnits range:[-1000, 1000, 20]
		spinner UI_Sides "Sides" type:#integer range:[3, 30, 6]
		spinner UI_Segments "Segments" type:#integer range:[1,100,2]
	)
	
	on buildMesh do
	(
		vsegs = 5
		tot_segs = vsegs * P_Segments
		vertices = #()
		faces = #()
		
		--heights
		h1 = 0.05
		h2 = 0.05
		h3 = 0.15
		h4 = 0.15
		h5 = 0.6
		
		r1 = 1.0
		r2 = 0.9
		r3 = 0.2
		r4 = 0.2
		r5 = 1.0
		r6 = 0.8
		
		heights = #(0, P_Height * h1, P_Height * h2, P_Height * h3, P_Height * h4, P_Height * h5)
		-- 0 2 2 6 2 8
		rads = #(P_Radius*r1, P_Radius*r2, P_Radius*r3, P_Radius*r4, P_Radius*r5, P_Radius*r6)
		-- 10 9 2 2 10 8
		
		height = 0
		dh = 0
		top = 0
		last = 0
		for j in 1 to (vsegs) by 1 do
		(
			height += heights[j]
			if j == (vsegs) then top = 1
			for s in 1 to (P_Segments + top) by 1 do
			(
				if s == (P_Segments + top) and top == 1 then last = 1
				dh = (heights[j + 1]) / (P_Segments * 1.0)
				cheight = height + (dh * (s - 1))
				--format "seg: %; h: % \n" s cheight
				
				dr = (rads[j + 1] - rads[j]) / (P_Segments)
				for i in 1 to (P_Sides) by 1 do
				(
					--vertices[i + P_Sides * (j - 1)] = [(P_Radius) * cos(i * 360.0/P_Sides), (P_Radius) * sin(i * 360/P_Sides), cheight]
					Append vertices [(rads[j] + dr*(s-1)) * cos(i * 360.0/P_Sides), (rads[j] + dr*(s-1)) * sin(i * 360/P_Sides), cheight]
					--format "j: %; s: %; rad: % \n" j s (rads[j] + dr*(s-1))
				)
			)
		)
		
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
				2: Radius = gridDist.x
				3: Height = gridDist.z
			)
		)
	)
)