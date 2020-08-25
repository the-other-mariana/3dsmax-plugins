TrunkHeight = Random 150 200
TrunkRadius = Random 5.0 15.0

Trunk = Cone radius1:TrunkRadius radius2:0 height:TrunkHeight pos:[0,0,0] isSelected:on
Trunk.wirecolor = color 16 11 17

offspring = 4
dr = 0.25
sons = #()

for i in 1 to (offspring) by 1 do
(
	z = Trunk.Height / 2.0

	son = Cone radius1:TrunkRadius radius2:0 height:(TrunkHeight*dr) pos:[0,0,0]
	son.rotation.y = 90.0
	son.rotation.x = (i-1) * 90.0
	son.pos = (Trunk.dir) * (Trunk.Height / 2.0) + Trunk.pos
	
	
	--rotate son [90, 0, (i-1) * 90.0]
	Append sons son
)	
print(sons.count)