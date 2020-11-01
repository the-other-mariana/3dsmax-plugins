plugin simpleObject Snowflake_Mesh
name: "Snowflake"
classID:#(0x2d067ec, 0x164da1ad)
category:"Snowflaker Plugin"
(
	parameters main rollout:SF_Params
	(
		P_Radius type:#worldUnits ui:UI_Radius	default:10
		P_Height type:#worldUnits ui:UI_Height	default:2
		P_Spikes type:#integer ui:UI_Spikes	default:4
	)
	
	rollout SF_Params "Parameters"
	(
		group "General Parameters"
		(
			spinner UI_Radius "Radius" type:#worldUnits range:[0, 1000, 10]
			spinner UI_Height "Height" type:#worldUnits range:[-1000, 1000, 2]
			spinner UI_Spikes "Sides" type:#integer range:[3, 30, 4]
		)
	)
	
	on buildMesh do
	(
		vertices = #()
		faces = #()
		
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
				2: P_Radius = gridDist.x
				3: P_Height = gridDist.z
			)
		)
	)
)