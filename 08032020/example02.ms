count = 0

-- the $ in this case will be all objects selected (4 cubes)
-- select them in order with ctrl

for x in $ do 
(
	count += 1
	x.scale.x = count
	x.scale.y = count
	x.scale.z = count
	move x [0,2* count,0] 
)

-- if run several times, only move gets added and added and added