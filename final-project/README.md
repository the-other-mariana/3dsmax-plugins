# Final Project

My final project for this course will be a plugin that generates snowflakes procedurally. <br />

## Specifications

3dsMax Version: `Autodesk 3dsMax 2020` <br />
Language: `MAXScript` <br />
Plugin: [Current Script](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/final-project/snowflaker.ms)

## Process & Logic

### 1st Round

The first thing is to create a ring of points, which will be the *inner ring* of the snowflake, a ring from which all the spikes will come out of, as extensions of each *even* side. <br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/final-project/media/ring.png?raw=true) <br />

### 2nd Round

I added the main spike points: every 2 sides, there must be one spike. This was using quaternions so that the point is in the direction that the user specifies. <br />

A 4-spiked snowflake: <br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/final-project/media/spikes-01.png?raw=true) <br />

A 6-spiked snowflake: <br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/final-project/media/spikes-02.png?raw=true) <br />

### 3rd Round

I fixed the angle of the main spike point, which was opposite. Now, every p0 points to its main psike point. <br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/final-project/media/spikes-03.png?raw=true) <br />

I created the main spike's points, with respect to how many segments per spike the user wants. For a 5-spike snowflake, it would work as follows: <br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/final-project/media/spikes-06.png?raw=true) <br />

## Helpful Links

[Quat Rotation](https://cathyatseneca.gitbooks.io/3d-modelling-for-programmers/content/mathematical_background/quaternions.html) <br />

