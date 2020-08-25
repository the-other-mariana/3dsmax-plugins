plugin simpleObject WineGlass_Mesh
name: "Wine Glass"
classID:#(0x4e2f8318, 0x205fef6d)
category:"Plugins Class"
(
	parameters main rollout:WGlass_Params
	(
		P_Radius type:#worldUnits ui:UI_Radius	default:10
		P_Height type:#worldUnits ui:UI_Height	default:30
		P_Sides type:#integer ui:UI_Sides	default:6
		P_Segments type:#integer ui:UI_Segments	default:4
		
		P_BodyScale type:#float ui: UI_BodyScale default: 0.6
		P_CupRadius type:#float ui: UI_CupRadius default: 0.8
		
		P_Belly type:#integer ui: UI_Belly default: 1
		P_BellySegs type:#integer ui: UI_BellySegs default: 3
		
		P_FootSegs type:#integer ui: UI_FootSegs default: 2
		P_FootRadius type:#float ui: UI_FootRadius default: 0.9
	)
	
	rollout WGlass_Params "Parameters"
	(
		group "General Parameters"
		(
			spinner UI_Radius "Radius" type:#worldUnits range:[0, 1000, 10]
			spinner UI_Height "Height" type:#worldUnits range:[-1000, 1000, 20]
			spinner UI_Sides "Sides" type:#integer range:[3, 30, 6]
			spinner UI_Segments "Segments" type:#integer range:[1,100,2]
			slider UI_BodyScale "Cup Proportion" orient:#horizontal ticks:10 range:[0.2,0.8,0.6]
			slider UI_CupRadius "Cup Closure" orient:#horizontal ticks:10 range:[0.5,2.0, 0.8]
		)
		
		group "Belly Parameters"
		(
			spinner UI_BellySegs "Belly Segments" type:#integer range:[1, 100, 3]
			spinner UI_Belly "Belly Curve On" type:#integer range:[0, 1, 0]
		)
		
		group "Foot Parameters"
		(
			spinner UI_FootSegs "Foot Segments" type:#integer range:[1, 100, 2]
			slider UI_FootRadius "Foot Closure" orient:#horizontal ticks:10 range:[0.2,1.0,0.9]
		)
	)
	
	on buildMesh do
	(
		vsegs = 5
		segs = #(P_FootSegs, P_Segments, P_Segments, P_BellySegs, P_Segments)
		tot_segs = 0
		for i in 1 to (vsegs) by 1 do
		(
			tot_segs += segs[i]
		)
		vertices = #()
		faces = #()
		
		--heights
		h5 = P_BodyScale
		h4 = (1.0 - P_BodyScale)/3.0
		h3 = h4 + (h4/2.0)
		h1 = (h4/2.0) / 2.0
		h2 = (h4/2.0) / 2.0
		
		r1 = 1.0
		r2 = P_FootRadius
		r3 = 0.2
		r4 = 0.2
		r5 = r1
		r6 = P_CupRadius
		
		heights = #(0, P_Height * h1, P_Height * h2, P_Height * h3, P_Height * h4, P_Height * h5)
		-- 0 2 2 6 2 8
		rads = #(P_Radius*r1, P_Radius*r2, P_Radius*r3, P_Radius*r4, P_Radius*r5, P_Radius*r6)
		-- 10 9 2 2 10 8
		
		height = 0
		dh = 0
		top = 0
		last = 0
		cheight = 0
		
		for j in 1 to (vsegs) by 1 do
		(
			height += heights[j]

			if j == (vsegs) then top = 1
			
			for s in 1 to (segs[j] + top) by 1 do
			(
				if s == (segs[j] + top) and top == 1 then last = 1
				dh = (heights[j + 1]) / (segs[j] * 1.0)
				cheight = height + (dh * (s - 1))
				
				dr = (rads[j + 1] - rads[j]) / (segs[j])
				cradius = (rads[j] + dr*(s-1))
				for i in 1 to (P_Sides) by 1 do
				(
					if j == 4 and P_Belly == 1 and s > 1 then
					(
						crad = rads[j + 1] - rads[j]
						start_angle = atan(rads[j] / (heights[j+1] * 1.0))
						
						cangle = (90.0 - abs(start_angle)) - ((s-1) * ((90.0 - abs(start_angle)) / segs[j]))
						
						xy = crad * cos( cangle )
						--format "rad: %; cool: %; hola: %; \n" radius4 cool_angle1 hola
						x = (xy + rads[j]) * cos(i * 360.0/P_Sides)
						y = (xy + rads[j]) * sin(i * 360.0/P_Sides)
						
						Append vertices [x , y, cheight]
						--format "x: %; y: % z: % \n" x y cheight
					) else 
					(
					--vertices[i + P_Sides * (j - 1)] = [(P_Radius) * cos(i * 360.0/P_Sides), (P_Radius) * sin(i * 360/P_Sides), cheight]
					Append vertices [cradius* cos(i * 360.0/P_Sides), cradius * sin(i * 360/P_Sides), cheight]
					--format "j: %; s: %; rad: % \n" j s (rads[j] + dr*(s-1))
					)
				)
			)
		)
		
		Append vertices [0, 0, 0]
		Append vertices [0, 0, cheight]
		
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
		
		-- top cup faces
		last = 0
		for i in 1 to P_Sides by 1 do
		(
			if i == P_Sides then
			(
				last = P_Sides
			)
			Faces[i + ((P_Sides * 2) * (tot_segs))] = [i + (P_Sides * (tot_segs)), (i + 1 + (P_Sides * (tot_segs))) - last, (P_Sides * (tot_segs + 1)) + 2]
		)
		
		-- bottom
		last = 0
		for i in 1 to P_Sides by 1 do
		(
			if i == P_Sides then
			(
				last = P_Sides
			)
			Faces[i + ((P_Sides * 2) * (tot_segs)) + (P_Sides)] = [i, (P_Sides * (tot_segs + 1)) + 1,  i + 1 - last]
		)
		
		setMesh mesh verts:vertices faces:faces
		
		-- body groups
		s_group = 1
		acc_faces = 0
		for j in 1 to (vsegs) by 1 do
		(
			for i in 1 to (segs[j] * (P_Sides * 2)) by 1 do
			(
				f_index = i + acc_faces
				--setFaceSmoothGroup mesh (f_index) (s_group)
				setFaceSmoothGroup mesh (f_index) (1)
				format "g: %; f: % \n" s_group (i + acc_faces)
			)
			acc_faces += (segs[j] * (P_Sides * 2))
			s_group += 1
			
		)
		
		-- top and bottom groups
		exc = tot_segs * (P_Sides * 2)
		for j in 1 to (2) by 1 do
		(
			for i in 1 to (P_Sides) by 1 do
			(
				f_index = i + (exc) + (j - 1)*(P_Sides)
				setFaceSmoothGroup mesh (f_index) (3 - (j - 1))
				format "g: %; f: % \n" s_group (i + (exc) + (j - 1)*(P_Sides))
			)
			s_group += 1
		)
		print(faces.count)
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