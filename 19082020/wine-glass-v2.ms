plugin simpleObject WineGlass2_Mesh
name: "Wine Glass2"
classID:#(0x3c1de37d, 0x3594949b)
category:"Plugins Class"
(
	parameters main rollout:WGlass_Params
	(
		P_Radius type:#worldUnits ui:UI_Radius	default:10
		P_Height type:#worldUnits ui:UI_Height	default:20
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
		h1 = 0.1
		h2 = 0.1
		h3 = 0.3
		h4 = 0.1
		h5 = 0.4
		
		heights = #(0, P_Height * h1, P_Height * h2, P_Height * h3, P_Height * h4, P_Height * h5)
		-- 0 2 2 6 2 8
		height = 0
		dh = 0
		for j in 1 to (vsegs) by 1 do
		(
			height += heights[j]
			for s in 1 to (P_Segments) by 1 do
			(
				
				dh = (heights[j + 1] + height - height) / (P_Segments * 1.0)
				cheight = height + (dh * (s - 1))
				format "seg: %; h: % \n" s cheight
				for i in 1 to (P_Sides) by 1 do
				(
					--vertices[i + P_Sides * (j - 1)] = [(P_Radius) * cos(i * 360.0/P_Sides), (P_Radius) * sin(i * 360/P_Sides), cheight]
					Append vertices [(P_Radius) * cos(i * 360.0/P_Sides), (P_Radius) * sin(i * 360/P_Sides), cheight]
				)
			)
		)
		
-- 		last = 0
-- 		for j in 1 to (tot_segs) by 1 do
-- 		(
-- 			last = 0
-- 			for i in 1 to (P_Sides-1) by 1 do
-- 			(
-- 				if i == P_Sides then
-- 				(
-- 					last = P_Sides
-- 				)
-- 				-- first triangle
-- 				faces[i + (P_Sides * 2) * (j - 1)] = [i + 1 + (P_Sides * (j - 1)) - last, i + 1 + (P_Sides * j) - last, i + (P_Sides * j)]
-- 				-- second triangle
-- 				faces[i + P_Sides + ((P_Sides * 2) * (j - 1))] = [i + (P_Sides * (j - 1)), i + 1 + (P_Sides * (j - 1)) - last, i + (P_Sides * j)]
-- 			)
-- 		)
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