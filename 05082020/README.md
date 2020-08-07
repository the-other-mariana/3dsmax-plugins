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

## Homework

In an expression, create a path for a sphere that looks like a torus. Something like bellow.<br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/05082020/hw-pic.png?raw=true) <br />

## Results

### A) Theoretical Torus

Expression: [(50 + 15*cos(30*F)) * cos(0.5*F), (50 + 15*cos(30*F)) * sin(0.5*F), 15*sin(30*F)] <br />

Frames: 750 or more <br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/05082020/hw-output-01.png?raw=true) <br />

Download [3dsMax Scene](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/05082020/hw-scene01_v02.max) or load as Position Expression for a 5m sphere [the expression file](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/05082020/hw-expression01_v02.xpr). <br />

### B) Horizontal Torus

Expression: [abs(100*cos(0.25*F) )* cos(10*F), abs(100*cos(0.25*F))  * sin(10*F), 30 * sin(0.5*F)] <br />

Frames: 750 or more <br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/05082020/hw-output-02.png?raw=true) <br />






