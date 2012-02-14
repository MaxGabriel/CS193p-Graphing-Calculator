//
//  CalculatorViewController.h
//  RPNCalculator
//
//  Created by Maximilian Tagher on 1/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalculatorBrain.h"

@interface CalculatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *history;
@property (weak, nonatomic) IBOutlet UILabel *xDisplay;
@property (nonatomic, strong) CalculatorBrain *brain;

@end


//NOTE: Breaks when trying to use x value that hasn't been defined yet. 