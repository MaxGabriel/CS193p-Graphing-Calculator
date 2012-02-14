//
//  GraphViewController.m
//  RPNCalculator
//
//  Created by Maximilian Tagher on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphViewController.h"

@interface GraphViewController() <GraphViewDataSource>
@property (nonatomic, weak) IBOutlet GraphView *graphView;


@end 



@implementation GraphViewController


@synthesize graphStack = _graphStack;
@synthesize description = _description;
@synthesize programLabel = _programLabel;

@synthesize graphView = _graphView;

- (NSMutableArray *)graphStack
{
    if (_graphStack == nil) _graphStack = [[NSMutableArray alloc] init];
    return _graphStack;
}

- (GraphViewController *)init
{
    return [super init];
}



- (void)setGraphStack:(NSMutableArray *)graphStack
{
    NSLog(@"Setting the Graph Stack");
    _graphStack = graphStack;
    
}

- (void)setLabel:(NSString *)label
{
    if (_programLabel == nil) _programLabel = [[UILabel alloc] init];
    _programLabel.text = label;
}

- (void)setDescription:(NSString *)description
{
    _description = description;
}

- (NSString *)description
{
    if (_description == nil) _description = [[NSString alloc] init];
    return _description;
}

- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector (pinch:)]];
    
    //[self.faceView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.faceView action:@selector(pinch:)]];
    //[self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector (pan:)]];
    self.graphView.dataSource = self;
}


//Change this method to send x-value as argument. 
- (float)deltaY:(GraphView *)sender
{
    float xVar = sender.xValue;
    
    id xVar2 = [NSNumber numberWithFloat:xVar];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];

    [dict setValue:xVar2 forKey: @"x"];
    
    float result = [CalculatorBrain runProgram:self.graphStack usingVariableValues:dict];

    return result;
}

- (void)viewDidUnload {
    [self setProgramLabel:nil];
    [super viewDidUnload];
}
@end
