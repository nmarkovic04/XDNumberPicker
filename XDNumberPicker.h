//
//  XDNumberPickerView.h
//
//  Created by Nikola Markovic on 10/28/13.
//  Copyright (c) 2013 Nikola Markovic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XDNumberPicker;

@protocol XDNumberPickerDelegate <NSObject>
@optional
-(void)didTouchInsidePlusButtonInPickerView:(XDNumberPicker*)counterView;
-(void)didTouchInsideMinusButtonInPickerView:(XDNumberPicker*)counterView;
-(void)pickerView:(XDNumberPicker*)pickerView valueDidChangeFrom:(float)oldValue to:(float)newValue;
@end

/* ******************************************************************************************************************************************************** */

@interface XDNumberPicker: UIView

- (id)initWithFrame:(CGRect)frame initialValue:(float)initialValue minValue:(float)minValue maxValue:(float)maxValue step:(float)step isVertical:(BOOL)isVertical delegate:(id<XDNumberPickerDelegate>)delegate;

/* UI */
@property(nonatomic, strong)           UIButton*                  buttonPlus;
@property(nonatomic, strong)           UIButton*                  buttonMinus;
@property(nonatomic, strong)           UILabel*                   labelValue;
@property(nonatomic, assign, readonly) BOOL                       isVertical;

/* Button images */
@property(nonatomic, strong)           UIImage*                   imagePlus;
@property(nonatomic, strong)           UIImage*                   imagePlusPressed;
@property(nonatomic, strong)           UIImage*                   imageMinus;
@property(nonatomic, strong)           UIImage*                   imageMinusPressed;

// controlOrder represents the order controls are layed out left to right - top to bottom.
// The value should contain three letters P (plus button), M (minus button) and V (value label).
// For example @"MVP" value will lay out controls like: -  5  +
// If an invalid value is passed, controls will be layed out in default order. That is: MVP for horizontal and PVM for vertical layout.
@property(nonatomic, strong)           NSString*                  controlOrder;

@property(nonatomic, weak)             id<XDNumberPickerDelegate> delegate;
@property(nonatomic, assign)           float                      step;
@property(nonatomic, assign)           float                      maxValue;
@property(nonatomic, assign)           float                      minValue;

-(float)getValue;

@end
