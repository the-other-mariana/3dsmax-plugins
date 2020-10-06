rollout SurfJump "Surface Jumper"
(
	pickbutton UI_SelectedObject "Select Surface"
	button UI_CreateJumps "Get Position"
	
	
	on UI_SelectedObject picked obj do
	(
		global mySurface = obj
		UI_SelectedObject.text = obj.name
	)
	
	on UI_CreateJumps pressed do
	(
		
		print("pressed")
		mouseray = mapScreenToWorldRay mouse.pos
		sectray = intersectRay mySurface mouseray
		--obj = box()
		--obj.pos = sectray.pos; obj.dir = sectray.dir
		--temp = Box length:0.5 width:0.5 height:0.5
		--temp = Cone radius1:1 radius2:0 height:2
		temp = Circle radius:3
		
		temp.pos = sectray.pos
		temp.dir = sectray.dir
		format "pos: % dir: % \n" sectray.pos sectray.dir
	)
	
	
)

createdialog SurfJump