-- example 3
count = 0

objs = #()
for x in $ do 
(
	count += 1
	bb = (x.max - x.min) -- bounding box dimensions
	x.scale.x = count
	x.scale.y = count
	x.scale.z = count
	append objs x
)
format "array size %" objs.count
dist = 0
gap = 5 -- constant space between cubes
for i = 1 to objs.count do
(
	print i
	print objs[i].name
	if i > 1  do
	(
		dist = 0
		for j = 1 to i do
		(
			if j == 1 or j == i then
			(
				bb0 = (objs[j].max - objs[j].min) -- array of dimensions as [x, y, z]
				dist += bb0[1]/2.0 -- x value
			) else
			(
				dist +=(objs[j].max - objs[j].min)[1]
			)
		)
		objs[i].pos.x = objs[1].pos.x + dist + (gap*(i - 1))
	)
)

-- prints from 1 to 10

for x in $ do
(
	print x.name
	print x.scale.x
	print x.scale.y
	print x.scale.z
	
	bb0 = (x.max - x.min)
	format "dimensions: %, %, % \n" bb0[1] bb0[2] bb0[3] -- bounding box
)

-- output --
-- 0
-- #()
-- OK
-- array size 4OK
-- 0
-- 5
-- 1
-- "Box001"
-- 2
-- "Box002"
-- 3
-- "Box003"
-- 4
-- "Box004"
-- OK
-- "Box001"
-- 1.0
-- 1.0
-- 1.0
-- dimensions: 18.0, 18.0, 18.0 
-- "Box002"
-- 2.0
-- 2.0
-- 2.0
-- dimensions: 36.0, 36.0, 36.0 
-- "Box003"
-- 3.0
-- 3.0
-- 3.0
-- dimensions: 54.0, 54.0, 54.0 
-- "Box004"
-- 4.0
-- 4.0
-- 4.0
-- dimensions: 72.0, 72.0, 72.0 
-- OK
-- OK

