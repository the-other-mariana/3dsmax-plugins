# Class 19.08.2020

## Notes

Append array_name value. <br />

Select Object > Modifiers > EditPoly. If you scroll down on modifiers list you can see which face of selected object is in what smoothing group. <br />

## Homework

First test: do a plugin for custom wine glass cups (copas). 2 Parameters minimum. <br />

Deadline: 31.08.2020 <br />

## Progress & Logic


### 1st Round

First defined 5 essential sections, just as the teapot. Then created a cylinder where each section has N number of `segments`. This is so that if the user inputs `segments = 1` it can still look like the minimum form of a wine glass.<br />

Then just defined each section's radius and interpolated the current radius with the next.<br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/19082020/images/process01.png?raw=true) <br />

### 2nd Round

What I did was simply clean a bit the parameters of heights: I added a spinner for the wine glass body scale and determined all the other section's height with respect to it. Next thing to do is round section 4 (below the body). <br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/19082020/images/process02.png?raw=true) <br />

### 3rd Round

This time I made section 4 (between handle and body) have an option to be curved or simply straight, using spheric coordinates. Separated `Segments` parameter to just apply to sections 2,3 and 5 (bigger sections) and sections 1(foot) and 4(belly) (smaller sections) to have their separate amount of custom sections. <br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/19082020/images/cup03.png?raw=true) <br />

### 4th Round

I made section 4's curve to be calculated automatically (inverse tangent!) and the curve can have a better look even if there are a lot of sections. I also closed the model in top and bottom. Added closure factor slider for the cup's mouth, but erased the angle parameter in the belly curve which didnt really improved the model and now is calculated. <br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/19082020/images/process04.png?raw=true) <br />

### 5th Round

This time I found that smoothing groups in 3dsMax are set according to powers of two: if you want a face in smoothing group 4 (N), you need to write 2^(N-1), that is, an 8. So I set every section to its own sg, except when Belly is on (1), because then it section 5 must have the same sg as section 4 (belly) so that it looks nice.<br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/19082020/images/smoothgroups.png?raw=true) <br />

A picture of probably all final parameters is shown bellow. Current script is [this file](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/19082020/wine-glass-v3.ms).<br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/19082020/images/process05.png?raw=true) <br />

