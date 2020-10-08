# Class 10.05.2020

## Notes 

In order to work, the selected mesh must editable poly, not mesh.<br />

## Process

If you click over the selected mesh, you create a small cube in that position. Seems direction is okay. <br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/10052020/ray-output-02.png?raw=true) <br />

What I did was call a ray from the mouse position to all objects in the scene whenever the user hit a click. Then, I looped over all the intersections of that ray to find the closest, which would become the surface object where the next control point would be. <br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/10052020/ray-output-04.png?raw=true) <br />

The next step was to calculate the middle point for each bezier curve jump. For this I did some cross product calculation (awesome!) to get it in the middle of the jump no matter its direction. <br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/10052020/jumper-output-01.png?raw=true) <br />

[Current Script](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/10052020/surface-jumper.ms)


## Helpful Info

[important link 01](https://forums.cgsociety.org/t/getting-explicit-normal-of-a-surface-with-a-ray-intersection/1846022) <br />

[important link 02](https://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_D1D7EB56_A370_4B07_99B4_BC779FB87CAF_htm) <br />

[important link 03](https://help.autodesk.com/view/3DSMAX/2019/ENU/?guid=GUID-3CF6FA6C-4CEA-4CC4-BACF-B2E40EF28C53) <br />

[important link 04](https://forums.cgsociety.org/t/script-gives-error-at-first-run-attempt-only/1436432) <br />