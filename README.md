XDNumberPicker
===================

XDNumberPicker is a number picker component for iOS platform.

Installation
-------------------

1. Clone the repository somewhere on your hard drive
2. Open your project in XCode
3. Drag and drop XDNumberPicker folder into your project

Usage
-------------------

You can instantiate XDNumberPicker either from code or from nib/storyboard. It contains three components, a value Label and two Buttons (plus and minus). The order can be either horizontal or vertical.

![ss](http://imageshack.com/a/img600/2976/8q8z.png) 

![ss](http://imageshack.com/a/img809/4003/zp51.png)

1.Code

This will create a picker with default values and no delegate. 
```
XDNumberPicker* numberPicker= [[XDNumberPicker alloc] initWithFrame:CGRectMake(190, 20, 110, 35)];
[myView addSubview:numberPicker];
```

If you want more control you can use:

```
XDNumberPicker* numberPicker= [[XDNumberPicker alloc] initWithFrame:rect initialValue:1 minValue:0 maxValue:20 step:1 isVertical:NO delegate:self]
```


2.Storyboard/nib

Simply create a UIView, set it's frame and set Custom Class to XDNumberPicker. If you wish to set the delegate, change any of the images or min/max values and step, simply connect the picker as an IBOutlet and handle it in code.

![ss1](https://imagizer.imageshack.us/v2/475x340q90/36/vtdh.jpg )

When instantiating the picker from the nib, component orientation will depend on the frame size.

```
bool vertical= frame.size.height > frame.size.width;
```

Control order
-------------------

Order of components can be customized.

![VMP](http://imageshack.com/a/img707/9464/wnf9.png "VMP")

![PMV](http://imageshack.com/a/img7/5415/55v0.png "PMV")

```
[picker setControlOrder:@"MVP"];
```
- M - Minus
- V - Value
- P - Plus

Component order is left to right(horizontal) and top to bottom(vertical). If the string value doesn't match the regex, the order will stay the same. Default order is MVP for horizontal, PVM for vertical orientation.

