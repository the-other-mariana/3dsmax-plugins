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

This time I made section 4 (between handle and body) have an option to be curved or simply straight, using spheric coordinates. Separated `segments` parameter to just apply to sections 2,3 and 5 (bigger sections) and sections 1 and 4 (smaller sections) to have their separate amount of custom sections. Current script is [this file](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/19082020/wine-glass-v3.ms) <br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/19082020/images/process03.png?raw=true) <br />


