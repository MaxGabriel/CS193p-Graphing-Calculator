//
//  GraphView.m
//  RPNCalculator
//
//  Created by Maximilian Tagher on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"


@implementation GraphView

@synthesize scale = _scale;
@synthesize dataSource = _dataSource;
@synthesize xValue;

#define DEFAULT_SCALE 0.90

- (CGFloat)scale
{
    if (!_scale) {
        return DEFAULT_SCALE; // don't allow zero scale
    } else {
        return _scale;
    }
}

- (void)setScale:(CGFloat)scale
{
    if (scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay]; // any time our scale changes, call for redraw
    }
}

//- (void)pinch:(UIPinchGestureRecognizer *)gesture
//{
//    if ((gesture.state == UIGestureRecognizerStateChanged) ||
//        (gesture.state == UIGestureRecognizerStateEnded)) {
//        self.scale *= gesture.scale; // adjust our scale
//        gesture.scale = 1;           // reset gestures scale to 1 (so future changes are incremental, not cumulative)
//    }
//}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    NSLog(@"Started Pinch");
    NSLog(@"%f",[self scale]);
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale; //adjust scale
        gesture.scale = 1;
        NSLog(@"Adjusted Scale");
        NSLog(@"%f",[self scale]);
        
    }
}


- (void)setup
{
    self.contentMode = UIViewContentModeRedraw; // if our bounds changes, redraw ourselves
}


- (void)awakeFromNib
{
    [self setup]; // get initialized when we come out of a storyboard
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup]; // get initialized if someone uses alloc/initWithFrame: to create us
    }
    return self;
}



//Draws a Cartesian Coordinate system and graphs an equation on it. 
//Equation comes from GraphViewController (data source)
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint midPoint; //center in coordinate system
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    //Draw Axes
    CGRect rect1 = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [AxesDrawer drawAxesInRect:rect1 originAtPoint:midPoint scale:[self scale]];
    
    
	UIGraphicsPushContext(context);
        
    //Set Drawing Options
    CGContextSetLineWidth(context, 2);
    [[UIColor redColor] setStroke];
    
    
    //Draw Graph
    
    BOOL haveMovedToPoint = NO; 
    
    for (CGFloat pixel = 0; pixel < midPoint.x*2; pixel++) { //Iterate over each pixel left to right, iOS coordinat system
        
        //Change frame of reference to Cartesian coordinate system
        
        
        CGFloat xPixelsFromCartesianOrigin = pixel-midPoint.x; //Distance from center to edge of screen
        xValue = xPixelsFromCartesianOrigin / [self scale];     //xValue in Units
        
        CGFloat yChange = [self.dataSource deltaY:self];  //Delegate calculates y-Value in units given x-Value in units
        CGFloat yPixelsFromCartesianOrigin = yChange * [self scale]; 

        //If this is the first iteration through the loop, move to point to begin drawing.
        if (haveMovedToPoint == NO)
        {
            CGContextMoveToPoint(context, 0, (self.bounds.size.height/2)-yPixelsFromCartesianOrigin);
            haveMovedToPoint = YES;
        }
        CGContextAddLineToPoint(context, pixel, (self.bounds.size.height/2)-yPixelsFromCartesianOrigin);
    }
    
    CGContextStrokePath(context);
	UIGraphicsPopContext();
}




@end
