plugin simpleObject Snowflake_Mesh
name: "Snowflake"
classID:#(0x2d067ec, 0x164da1ad)
category:"Snowflaker Plugin"
(
	parameters main rollout:SF_Params
	(
		P_Radius type:#worldUnits ui:UI_Radius	default:10
		P_Height type:#worldUnits ui:UI_Height	default:4
		P_Spikes type:#integer ui:UI_Spikes	default:4
		P_Thick type:#float ui: UI_Thick default: 2.0
	)
	
	rollout SF_Params "Parameters"
	(
		group "General Parameters"
		(
			spinner UI_Radius "Radius" type:#worldUnits range:[0, 1000, 10]
			spinner UI_Height "Height" type:#worldUnits range:[-1000, 1000, 4]
			spinner UI_Spikes "Spikes" type:#integer range:[3, 30, 4]
			spinner UI_Thick "Thickness" type:#integer range:[0.1, 30.0, 2.0]
		)
	)
	
	on buildMesh do
	(
		vertices = #()
		faces = #()
		
		P_Sides = P_Spikes * 2
		step_angle = 360.0 / P_Sides
		xPos = 0.0
		yPos = 0.0
		zPos = 0.0
		
		-- inner ring
		for j in 1 to (2) by 1 do
		(
			for k in 1 to (2) by 1 do
			(
				
				for i in 1 to (P_Sides) by 1 do
				(
					radius = P_Radius - (k - 1) * P_Thick
					xPos = radius * cos(((i - 1) * step_angle) + (step_angle/2.0)) 
					yPos = radius * sin(((i - 1) * step_angle) + (step_angle/2.0)) 
					
					zPos = (j - 1) * P_Height
					vert = [xPos, yPos, zPos]
					Append vertices vert
					
					print("vertices")
					print(vert)
				)
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
				-- put P_Radius when ready
				2: Radius = gridDist.x
				3: Height = gridDist.z
			)
		)
	)
)