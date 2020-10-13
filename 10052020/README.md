# Class 10.05.2020

## Notes 

Second test: make a jumping animation using bezier curve. You must add one more functionality that makes the plugin attractive. In my case, I chose to make the jumper 'stick' to any surface where the user clicks.<br />

Important: In order to work, the selected surface mesh must editable poly, not mesh.<br />

## Plugin Script

[Current Script](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/10052020/surface-jumper.ms)

## Process

### 1st Round

If you click over the selected mesh, you create a small cube in that position. Seems direction is okay. <br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/10052020/images/ray-output-02.png?raw=true) <br />

What I did was call a ray from the mouse position to all objects in the scene whenever the user hit a click. Then, I looped over all the intersections of that ray to find the closest, which would become the surface object where the next control point would be. <br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/10052020/images/ray-output-04.png?raw=true) <br />

### 2nd Round

The next step was to calculate the middle point for each bezier curve jump. For this I did some cross product calculation (awesome!) to get it in the middle of the jump no matter its direction. <br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/10052020/images/jumper-output-01.png?raw=true) <br />

I added quaternion & cross product based (physically jumping) or just cross product (biased jumping) as the interpolation options. <br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/10052020/images/jumper-output-02.png?raw=true) <br />

### 3rd Round

Then, I added some roll angle so that each jump the teapot makes a roll and looks funny. <br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/10052020/images/jumper-output-03.png?raw=true) <br />

### 4th Round

I defined 4 jump height behaviors: constant, distanced, decay and growth. Still of course has the funny roll. <br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/10052020/images/jumper-output-05.png?raw=true) <br />

### 5th Round

I added a simple squash every time the jumper object is approaching the surface. For this I added the parameters for the user: frames for the squash and the maximum amount of squash value. <br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/10052020/images/jumper-output-06.png?raw=true) <br />

## Helpful Info

[important link 01](https://forums.cgsociety.org/t/getting-explicit-normal-of-a-surface-with-a-ray-intersection/1846022) <br />

[important link 02](https://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_D1D7EB56_A370_4B07_99B4_BC779FB87CAF_htm) <br />

[important link 03](https://help.autodesk.com/view/3DSMAX/2019/ENU/?guid=GUID-3CF6FA6C-4CEA-4CC4-BACF-B2E40EF28C53) <br />

[important link 04](https://forums.cgsociety.org/t/script-gives-error-at-first-run-attempt-only/1436432) <br />

## Notes To Self

Check new scene