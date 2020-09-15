Bolitas = $Sphere*
nariz = $nariz
for n in 1 to Bolitas.count do
(
	sliderTime = 0f
	deleteKeys Bolitas[n]
	deleteKeys nariz
)


stinky = $Stinky
nariz.parent = stinky
max_dist = 10000000

animate on
(
	for t in 0 to 100 do
	(
		
		at time t
		(
			max_dist = 10000000
			if t == 0 then
			(
				bolita_cerca = Bolitas[1]
			)
			for n in 1 to Bolitas.count do
			(
				VectDir = Bolitas[n].pos - $Stinky.pos
				NVectDir = normalize VectDir
				LVectDir = length VectDir
				Incremento = 50/ LVectDir
				Escalar = LVectDir + Incremento
				
				
				Bolitas[n].pos = (NVectDir * Escalar) + $Stinky.pos
				
				if LVectDir < max_dist then
				(
					max_dist = LVectDir
					bolita_cerca = Bolitas[n]
				)
				
			)
			nariz.height = length (bolita_cerca.pos - $Stinky.pos)
			nariz.dir = bolita_cerca.pos - $Stinky.pos
		)
	)
)


