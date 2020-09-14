# Class 09.07.2020

## Notes 

Finished a growing-tree animation plugin. The tree is made out of primitive cones. It has a UI window. <br />

For running animation scripts, be sure to be positioned in frame 1. Then run it with the usual `Ctrl + E` and so on and so on. <br />

Boolean IU is called `Checkbox` in 3dsMax. <br />

Use a for loop and then `at time #` to calculate something and set it on a specific frame number (#). <br />

To add frames in the bottom time line go to the button ´Time Configuration´ (a small clock and gear) at the bottom right. <br />

### Animation

If you want to create a keyframe for a selected object (pos, rot, scale): <br />

1. Click on SetKey Button, in the bottom right corner of 3dsMax. <br />
2. Transform the object to your desired position and slide in the bottom time line to the frame you wish. <br />
3. Click on the +(key icon) button called `Set Keys` or press (K) to set the key frame there. <br />

Example of this would be this [scene](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/09072020/animation-keys.max). <br />

## Results

Latest code (run it positioned around frame 100): [ms file](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/09072020/Arbol5.ms) <br />

The code makes a randomized tree animation:

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/09072020/tree-gif.gif)