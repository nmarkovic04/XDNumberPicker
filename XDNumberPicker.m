//
//  XDNumberPickerView.m
//
//  Created by Nikola Markovic on 10/28/13.
//  Copyright (c) 2013 Nikola Markovic. All rights reserved.
//

#import "XDNumberPicker.h"

// Default values just in case parameters aren't supplied in constructor
static float defaultMinValue= 1.0;
static float defaultMaxValue= CGFLOAT_MAX;
static float defaultStep= 1.0;
static BOOL defaultOrientationIsVertical= NO;
@implementation XDNumberPicker{
    float currentValue;
    CGPoint controlRects[3];
}

- (id)initWithFrame:(CGRect)frame{
    self= [self initWithFrame:frame initialValue:defaultMinValue minValue:defaultMinValue maxValue:defaultMaxValue step:defaultStep isVertical:defaultOrientationIsVertical delegate:nil];
    return self;
}

- (id)initWithFrame:(CGRect)frame initialValue:(float)initialValue minValue:(float)minValue maxValue:(float)maxValue step:(float)step isVertical:(BOOL)isVertical delegate:(id<XDNumberPickerDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self) {

        [self setupWithInitialValue:initialValue minValue:minValue maxValue:maxValue step:step isVertical:isVertical delegate:delegate];
    }
    return self;
}

-(void) setupWithInitialValue:(float)initialValue minValue:(float)minValue maxValue:(float)maxValue step:(float)step isVertical:(BOOL)isVertical delegate:(id<XDNumberPickerDelegate>)delegate{
    
    self.isVertical= isVertical;
    self.minValue= minValue;
    self.maxValue= maxValue;
    self.step= step;
    self.delegate= delegate;
    
    if(initialValue<minValue || initialValue > maxValue){
        initialValue= minValue;
    }else{
        currentValue= initialValue;
    }
    
    /* Images */
    self.imageMinus= [UIImage imageNamed:@"minus"];
    self.imageMinusPressed= [UIImage imageNamed:@"minus"];
    self.imagePlus= [UIImage imageNamed:@"plus"];
    self.imagePlusPressed= [UIImage imageNamed:@"plus"];
    
    if(self.isVertical){
        self.controlOrder= @"PVM";
    }else{
        self.controlOrder= @"MVP";
    }
    
    /* UI */
    float dim= self.isVertical ? self.bounds.size.width : self.bounds.size.height;
    CGRect rect= (CGRect){
        .origin= self.isVertical? CGPointMake(0, 0) : CGPointMake(self.bounds.size.width-dim, 0),
        .size= CGSizeMake(dim, dim)
    };
    
    self.buttonPlus= [[UIButton alloc] initWithFrame:rect];
    [self.buttonPlus setImage:self.imagePlus forState:UIControlStateNormal];
    [self.buttonPlus setImage:self.imagePlusPressed forState:UIControlStateHighlighted];
    [self.buttonPlus addTarget:self action:@selector(didTouchInsidePlusButton:) forControlEvents:UIControlEventTouchUpInside];
    
    rect= (CGRect){
        .origin= self.isVertical? CGPointMake(0, self.bounds.size.height-dim) : CGPointMake(0, 0),
        .size= CGSizeMake(dim, dim)
    };

    self.buttonMinus= [[UIButton alloc] initWithFrame:rect];
    [self.buttonMinus setImage:self.imageMinus forState:UIControlStateNormal];
    [self.buttonMinus setImage:self.imageMinusPressed forState:UIControlStateHighlighted];
    [self.buttonMinus addTarget:self action:@selector(didTouchInsideMinusButton:) forControlEvents:UIControlEventTouchUpInside];
    
    rect= (CGRect){
        .origin= self.isVertical? CGPointMake(0, dim) : CGPointMake(dim, 0),
        .size= self.isVertical? CGSizeMake(dim, self.bounds.size.height-2*dim) : CGSizeMake(self.bounds.size.width-2*dim ,dim)
    };
    
    self.labelValue= [[UILabel alloc] initWithFrame:rect];
    self.labelValue.backgroundColor= [UIColor clearColor];
    self.labelValue.textColor= [UIColor blackColor];
    self.labelValue.textAlignment= NSTextAlignmentCenter;
    [self.labelValue setText:[NSString stringWithFormat:@"%g", currentValue]];
    
    [self addSubview:self.buttonPlus];
    [self addSubview:self.buttonMinus];
    [self addSubview:self.labelValue];
    
    /* Layer border */
    self.layer.cornerRadius= 3.0;
    self.layer.borderColor= [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
    self.layer.borderWidth= 0.6;
}

-(void)changeValueByDelta:(float)deltaValue{
    float oldValue= currentValue;
    float newValue= currentValue+deltaValue;
    
    if(newValue > self.maxValue || newValue < self.minValue)
        return;
    
    currentValue= newValue;
    
    [self.labelValue setText:[NSString stringWithFormat:@"%g",currentValue]];
    
    if(self.delegate)
        [self.delegate pickerView:self valueDidChangeFrom:oldValue to:currentValue];
}

#pragma mark - Actions

-(IBAction)didTouchInsidePlusButton:(UIButton*)sender{
    if(self.delegate)
        [self.delegate didTouchInsidePlusButtonInPickerView:self];
    [self changeValueByDelta:self.step];
}

-(IBAction)didTouchInsideMinusButton:(UIButton*)sender{
    if(self.delegate)
        [self.delegate didTouchInsideMinusButtonInPickerView:self];
    [self changeValueByDelta:-self.step];
}

#pragma mark - Custom getters & setters

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setupWithInitialValue:defaultMinValue minValue:defaultMinValue maxValue:defaultMaxValue step:defaultStep isVertical:defaultOrientationIsVertical delegate:nil];
}

-(float)getValue{
    return currentValue;
}

-(void)setImageMinus:(UIImage *)imageMinus{
    _imageMinus= imageMinus;
    [self setImage:imageMinus forButton:self.buttonMinus state:UIControlStateNormal];
}

-(void)setImageMinusPressed:(UIImage *)imageMinusPressed{
    _imageMinusPressed= imageMinusPressed;
    [self setImage:imageMinusPressed forButton:self.buttonMinus state:UIControlStateHighlighted];
}

-(void)setImagePlus:(UIImage *)imagePlus{
    _imagePlus= imagePlus;
    [self setImage:imagePlus forButton:self.buttonPlus state:UIControlStateNormal];
}

-(void)setImagePlusPressed:(UIImage *)imagePlusPressed{
    _imagePlusPressed= imagePlusPressed;
    [self setImage:imagePlusPressed forButton:self.buttonPlus state:UIControlStateHighlighted];
}

-(void)setImage:(UIImage*)img forButton:(UIButton*)btn state:(UIControlState)state{
    [btn setImage:img forState:state];
}

#pragma mark - control order

-(void)layoutControls{
    CGPoint offset= CGPointMake(0, 0);
    for(int i=0; i<self.controlOrder.length; i++){
        UIView* view= [self viewForSign:[self.controlOrder characterAtIndex:i]];
        CGRect frm= view.frame;
        frm.origin= offset;
        view.frame= frm;
        [self addOffset:&offset view:view];
    }
}

-(void)setControlOrder:(NSString *)co_{
    NSString* controlOrder= [co_ uppercaseString];
    NSString* regexString= @"^(?=[MVP]{3}$)(?!.*(.).*\\1).*$";

    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:controlOrder
                                                    options:0
                                                      range:NSMakeRange(0, [controlOrder length])];
   
    if(!match)
        return;
    
    _controlOrder= controlOrder;
    [self layoutControls];

}

-(void)addOffset:(CGPoint*)point view:(UIView*)view{
    if(self.isVertical){
        point->y+= view.frame.size.height;
    }else{
        point->x+= view.frame.size.width;
    }
}

-(UIView*)viewForSign:(char)ch{
    NSString* sign= [NSString stringWithFormat:@"%c",ch];
    if([[sign lowercaseString] isEqualToString:@"m"])
        return self.buttonMinus;
    else if([[sign lowercaseString] isEqualToString:@"v"])
        return self.labelValue;
    else if([[sign lowercaseString] isEqualToString:@"p"])
        return self.buttonPlus;
    else
        return nil;
}
@end
