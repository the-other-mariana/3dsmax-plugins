plugin simpleObject WineGlass3_Mesh
name: "Wine Glass3"
classID:#(0x244b373a, 0x35da12bb)
category:"Plugins Class"
(
	parameters main rollout:WGlass_Params
	(
		P_Radius type:#worldUnits ui:UI_Radius	default:10
		P_Height type:#worldUnits ui:UI_Height	default:30
		P_Sides type:#integer ui:UI_Sides	default:6
		P_Segments type:#integer ui:UI_Segments	default:4
		
		P_Body type:#float ui: UI_Body default: 0.6
		P_Belly type:#integer ui: UI_Belly default: 1
		P_BellySegs type:#integer ui: UI_BellySegs default: 3
		P_BellyAngle type:#integer ui: UI_BellyAngle default: 45
	)
	
	rollout WGlass_Params "Parameters"
	(
		spinner UI_Radius "Radius" type:#worldUnits range:[0, 1000, 10]
		spinner UI_Height "Height" type:#worldUnits range:[-1000, 1000, 20]
		spinner UI_Sides "Sides" type:#integer range:[3, 30, 6]
		spinner UI_Segments "Segments" type:#integer range:[1,100,2]
		
		spinner UI_Body "Body Scale" type:#float range:[0.1, 0.8, 0.6]
		spinner UI_Belly "Belly Curve On" type:#integer range:[0, 1, 0]
		spinner UI_BellySegs "Belly Segments" type:#integer range:[1, 100, 3]
		spinner UI_BellyAngle "Belly Angle" type:#integer range:[1, 90, 45]
		
	)
	
	on buildMesh do
	(
		vsegs = 5
		tot_segs = 0
		for i in 1 to (vsegs) by 1 do
		(
			if i == 4 then
			(
				tot_segs += P_BellySegs
			) else
			(
				tot_segs += P_Segments
			)
		)
		vertices = #()
		faces = #()
		
		--heights
		h5 = P_Body
		h4 = (1.0 - P_Body)/3.0
		h3 = h4 * 1.5
		h1 = (h3 * 0.5) / 2.0
		h2 = (h3 * 0.5) / 2.0

		
		r1 = 1.0
		r2 = 0.9
		r3 = 0.2
		r4 = 0.2
		r5 = r1
		r6 = 0.8
		
		heights = #(0, P_Height * h1, P_Height * h2, P_Height * h3, P_Height * h4, P_Height * h5)
		-- 0 2 2 6 2 8
		rads = #(P_Radius*r1, P_Radius*r2, P_Radius*r3, P_Radius*r4, P_Radius*r5, P_Radius*r6)
		-- 10 9 2 2 10 8
		
		height = 0
		dh = 0
		top = 0
		last = 0
		
		vStep = 0
		hola = 0
		xy = 0
		x = 0
		y = 0
		z = 0
		radius4 = 0
		
		for j in 1 to (vsegs) by 1 do
		(
			height += heights[j]
			if j == (vsegs) then top = 1
			
			segs = P_Segments
			if j == 4 then segs = P_BellySegs
			for s in 1 to (segs + top) by 1 do
			(
				if s == (segs + top) and top == 1 then last = 1
				dh = (heights[j + 1]) / (segs * 1.0)
				cheight = height + (dh * (s - 1))
				--format "seg: %; h: % \n" s cheight
				
				dr = (rads[j + 1] - rads[j]) / (segs)
				cradius = (rads[j] + dr*(s-1))
				if j == 4 and P_Belly == 1 and s > 1 then cradius += abs(rads[j + 1] - cradius)/2.0
				for i in 1 to (P_Sides) by 1 do
				(
					if j == 4 and P_Belly == 1 and s > 1 then
					(
						radius4 = rads[j + 1] + dr
						hola = -P_BellyAngle - (((segs) - (s)) * ((P_BellyAngle) / segs))
						cool_angle1 = atan(rads[j] / (heights[j+1] * 1.0)) - 90.0
						cool_angle = -cool_angle1 - (((segs) - (s)) * (abs(cool_angle1) / segs))
						
						xy = radius4 * cos( hola )
						--format "rad: %; cool: %; hola: %; \n" radius4 cool_angle1 hola
						
						x = xy * cos(i * 360.0/P_Sides)
						y = xy * sin(i * 360.0/P_Sides)
						
						Append vertices [x, y, cheight]
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