# Class 08.10.2020

## Notes 

### Creating a custom Cone figure plugin

Link for class: [meet.google.com/swj-niyp-fca]() <br />

Scripting > MAXScript Listener: type `genclassid()` + `Enter` to generate header unique id of our plugin class. <br />

In the code, category:"Plugings Class" will create the title of the plugin.  Select Object > Object menu (circle btn) > First Dropdown, and you will see Plugins Class. Click on it for further paremeters. <br />

A `spinner` is the IU field with two little arrows.<br />

`range: [3, 30, 6]` would be [min, max, default values].<br />

`#worldunits` its just a float number and a unit. 1.0 turns to 1.0 meters inside 3dsMax.<br />

The `parameters` function has parameter variables that connect IU input. Write `ui:UI_NameOfSpinner` so that it connects.<br />

Select Object > Right click > Covert To > EditPoly > Vertex view. Activate `Snap` (button with a 3 and a magnet) to grab vertices easily with mouse. Also, during Vertex View, you can select a vertex and under `Selection` you can see which number of vertex you are selecting.<br />

`on build mesh` is one of the functions of `simpleObject` object inside 3dsMax. Also, `simpleObject` is a centered object in [0, 0, 0].<br />

`point3D` in 3dsMax is a list with [x, y, z] values.<br />

`Ctrl + a` and `Ctrl + e` to run the plugin and check for errors in the Max Listener. Then, go to Circle button on the top right menu > First dropdown, and in the bottom, you will see the name of your `category`.<br />

For clicks, the defined values are: 1 when you click, 2 when you move mouse, 3 when you click out. Useful for switch value.<br />

## Homework

Try to generate the cone's side faces.<br />

## Results

The [file](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/08102020/my-cone.ms) after this class homework generates the following.<br />

![alt text](https://github.com/the-other-mariana/3dsmax-plugins/blob/master/08102020/hw-output.png?raw=true) <br />

