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
		P_SpSize type: #integer ui: UI_SpSize default: 30
	)
	
	rollout SF_Params "Parameters"
	(
		group "General Parameters"
		(
			spinner UI_Radius "Radius" type:#worldUnits range:[0, 1000, 10]
			spinner UI_Height "Height" type:#worldUnits range:[-1000, 1000, 4]
			spinner UI_Spikes "Spikes" type:#integer range:[3, 30, 4]
			spinner UI_Thick "Thickness" type:#float range:[0.1, 30.0, 2.0]
		)
		group "Spikes"
		(
			spinner UI_SpSize "Spike Size" type:#integer range:[0, 1000, 30]
		)
	)
	
	fn greetings msg=
	(
		print(msg)
	)
	
	fn createSpike p0 p1 size deg=
	(
		midpoint = [p0.x + p1.x, p0.y + p1.y, p0.z + p1.z]
		midpoint = midpoint * 0.5
		axis = [0, 0, 1]
		axis = normalize axis
		
		vect1 = p0 - midpoint
		q = quat deg axis
		vect2 = vect1 * q
		vect2 = normalize vect2
		
		spikePos = (vect2 * size) + midpoint
		return spikePos
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
		for k in 1 to (2) by 1 do
		(
			for j in 1 to (2) by 1 do
			(
				
				for i in 1 to (P_Sides) by 1 do
				(
					radius = P_Radius - (k - 1) * P_Thick
					xPos = radius * cos(((i - 1) * step_angle) + (step_angle/2.0)) 
					yPos = radius * sin(((i - 1) * step_angle) + (step_angle/2.0)) 
					
					zPos = (j - 1) * P_Height
					vert = [xPos, yPos, zPos]
					Append vertices vert
					
					
				)
			)
		)
		
		-- main spike points (2)
		for i in 1 to (P_Sides) by 1 do
		(
			if (mod i 2) == 1 then
			(
				p0 = vertices[i]
				p1 = vertices[i + 1]
				--format "% and % \n" (i) (i + 1)
				
				newSpike1 = createSpike p0 p1 P_SpSize 90.0
				newSpike2 = [newSpike1.x, newSpike1.y, P_Height]
				
				print(newSpike1)
				Append vertices newSpike1
				Append vertices newSpike2
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

