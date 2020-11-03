Bolita = $Sphere001

convertToMesh Bolita

num = 32

for i in 1 to ((getNumVerts Bolita) - 2) by 1 do
(
	
	if (i > 33) then 
	(
		v1 = getVert Bolita i
		n1 = getNormal Bolita i
		
		v2 = getVert Bolita (i + 1)
		n2 = getNormal Bolita (i + 1)
		
		v3 = getVert Bolita (i - 32)
		n3 = getNormal Bolita (i - 32)
		
		v4 = getVert Bolita ((i + 1) - 32)
		n4 = getNormal Bolita ((i + 1) - 32)
		
		mid1 = (v1 + v3) * (0.5)
		mid2 = (v2 + v4) * (0.5)
		
		x = (v1.x + v2.x + v3.x + v4.x) / 4.0
		y = (v1.y + v2.y + v3.y + v4.y) / 4.0
		z = (v1.z + v2.z + v3.z + v4.z) / 4.0
		posc = [x, y, z]
		
		nx = (n1.x + n2.x + n3.x + n4.x) / 4.0
		ny = (n1.y + n2.y + n3.y + n4.y) / 4.0
		nz = (n1.z + n2.z + n3.z + n4.z) / 4.0
		dirc = [nx, ny, nz]

		dirc = normalize dirc
		
		--rad = distance v1 v2
		rad = distance mid1 mid2
		temp = Cone radius1:(rad/2.0) radius2:0 height:(rad * 1.5) pos:posc
		temp.dir = dirc
	)
)