//
//  GraphView.h
//  RPNCalculator
//
//  Created by Maximilian Tagher on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AxesDrawer.h"
#import "CalculatorBrain.h"

@class GraphView;

@protocol GraphViewDataSource
- (float)deltaY:(GraphView *)sender;
@end

@interface GraphView : UIView

@property (nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;
@property (nonatomic) CGFloat scale;
@property (nonatomic) CGFloat xValue;


- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end
