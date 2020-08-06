# Class 05.08.2020 <br />

## Notes 

Select object > Right clic > Wire Parameters > Ex. Height > Drag to Other Object. (Green Object controls the other parameters) <br />

F3: wireframe view<br />

Customize > Unite Setup (cm) > System Unit Setup (1.0 = cm)<br />

Auto Key to move tire (bottom right corner)<br />

### Tire rotation

#### One way

Assign controllers to movement in Y: <br />

1. Motion menu (circles right menu) > choose param (Y rotation) > Expression: 90 (Right click reset)<br />

2. Motion menu (circles right menu) > choose param (Y rotation) > Expression: cos(F)<br />
 
#### Other way

1. Position X controls Y Rotaions (Wire to itself)<br />

Y Rot expresion (receives radians): degtorad(X_Position / (50 * pi))*360.0) <br />

50 - radius <br />

function help (doc): Scripting > Help <br />

Align objects: Button below 'Content' tab. <br />

Tire wires itself to X Rot <br />
Cylinder wires tire X Pos <br />
Volante wires tire Z Rot <br />

(but one same param cannot receive two wires)<br />

### Circle Oscilation

Ctrl Alt + Right Click to add frames <br />

Assign Controller to Sphere001 to its Position <br />

Motion > Position > Controller > Position expression. Shows an array: [cos(F*10)*50, sin(F*10)*50, F] <br />

Path: Right click > Properties > Motion Path <br />

### Homework

In an expression, create a path for a sphere that looks like a torus. Something like bellow.<br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/05082020/hw-pic.png?raw=true) <br />





