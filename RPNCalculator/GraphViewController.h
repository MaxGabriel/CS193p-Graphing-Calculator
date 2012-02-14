//
//  GraphViewController.h
//  RPNCalculator
//
//  Created by Maximilian Tagher on 2/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AxesDrawer.h"
#import "CalculatorViewController.h"
#import "GraphView.h"
#import "CalculatorBrain.h"

@interface GraphViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *graphStack;
@property (nonatomic, strong) NSString *description;
@property (strong, nonatomic) IBOutlet UILabel *programLabel;

//@property (nonatomic, weak) CalculatorViewController *controller;

- (void)setLabel:(NSString *)label;



@end
