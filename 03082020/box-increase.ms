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
				bb0 = (objs[j].max - objs[j].min) 
				dist += bb0[1]/2.0
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
)

-- output --
-- 0
-- #()
-- OK
-- array size 4OK
-- 1
-- "Box001"
-- 2
-- "Box002"
-- 18.0;18.0;18.0
-- 38.2704
-- 3
-- "Box003"
-- 36.0;36.0;36.0
-- 94.4133
-- 4
-- "Box004"
-- 54.0;54.0;54.0
-- 168.609
-- OK
-- "Box001"
-- 1.0
-- 1.0
-- 1.0
-- "Box002"
-- 2.0
-- 2.0
-- 2.0
-- "Box003"
-- 3.0
-- 3.0
-- 3.0
-- "Box004"
-- 4.0
-- 4.0
-- 4.0
-- OK
-- OK

