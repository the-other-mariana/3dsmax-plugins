fn RotateSphere ObjToRotate NormDir=
(
	Animate on
	(
		for t in 1 to 400 by 1 do
		(
			at time t
			(
				DirVector =  ObjToRotate.pos - (at time (t - 1)(ObjToRotate.pos))
				$DirVector.dir = DirVector
				$DirVector.pos = ObjToRotate.pos
					
				RotVector = cross DirVector NormDir
				$RotVector.dir = RotVector
				$RotVector.pos = ObjToRotate.pos
				
				RotAngle = (length DirVector/(ObjToRotate.Radius*pi))*180 
				Quaternion = quat RotAngle (normalize RotVector)
				RotEuler = QuatToEuler Quaternion
				rotate ObjToRotate (RotEuler)
			)
		)
	)
)


fn BakeAnimation  OriginalObj CloneObj=
(
	Animate on
	(
		for t in 1 to 400 by 1 do
		(
			at time t
			(
				CloneObj.pos.x = OriginalObj.pos.x
				CloneObj.pos.y = OriginalObj.pos.y
			)
		)
	)
)


fn Reposition ObjToRepos xTerrain=
(
	Animate on
	(
		for t in 1 to 400 by 1 do
		(
			at time t
			(
				NewRay = ray ObjToRepos.pos [0,0,-1]
				NewCol = IntersectRay xTerrain NewRay
				
				ObjToRepos.pos = ((normalize NewCol.dir) * ObjToRepos.Radius)+ NewCol.pos
				$pine.dir = NewCol.dir
				$pine.pos = NewCol.pos
			)
		)
	)
)

RotateSphere $Bolita [0,0,1]
--BakeAnimation $Bolita $Clon
--Reposition $Clon $Piso
--RotateSphere $Clon $Pine.dir