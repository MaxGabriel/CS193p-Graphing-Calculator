//
//  CalculatorViewController.m
//  RPNCalculator
//
//  Created by Maximilian Tagher on 1/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "GraphView.h"
#import "GraphViewController.h"

@interface CalculatorViewController() 
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringNumber;

@property (nonatomic, strong) NSMutableDictionary *variables;

@end

@implementation CalculatorViewController



@synthesize display;
@synthesize history;
@synthesize xDisplay = _xDisplay;
@synthesize userIsInTheMiddleOfEnteringNumber;
@synthesize brain = _brain;
@synthesize variables = _variables;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"graph"]) {
        
        [segue.destinationViewController setGraphStack:[self.brain program]];
        //Fix next line.
        [segue.destinationViewController setLabel:[CalculatorBrain descriptionOfProgram:[self.brain program]]];
    }
}

- (CalculatorBrain *)brain
{
    if (!_brain)
        _brain = [[CalculatorBrain alloc] init];
    
    return _brain;

}


//- (NSMutableDictionary *)variables
//{
//    if (!_variables) {
//        _variables = [[NSMutableDictionary alloc] init];
//        [_variables setValue:0 forKey:@"x"];
//    }
//    return _variables;
//}

- (IBAction)clear 
{
    [_brain clearCalculator];
    self.display.text = @"0";
    self.userIsInTheMiddleOfEnteringNumber = NO;
    self.history.text = @"";
}

- (IBAction)modifyVariable:(UIButton *)sender 
{
    if ([[sender currentTitle] isEqualToString:@"set x"]) {
        
        _variables = [[NSMutableDictionary alloc] init];
        
        NSLog(@"Modifying x");
        
        double currentValue = [self.display.text doubleValue];
        NSLog(@"%g",currentValue);
        
        id currentValueObj = [NSNumber numberWithDouble:currentValue];
        NSLog(@"%@",currentValueObj);
        
        [_variables setValue:currentValueObj forKey:@"x"];
        _xDisplay.text = self.display.text;
        id test = [_variables valueForKey:@"x"];
        double test2 = [test doubleValue];
        NSLog(@"%g",test2);
        self.userIsInTheMiddleOfEnteringNumber = NO;
        self.display.text = @"0";
    }
}

- (IBAction)useVariable:(UIButton *)sender 
{
    if (!_variables) {
        _variables = [[NSMutableDictionary alloc] init];
        id currentValueObj = [NSNumber numberWithDouble:0];
        [_variables setValue:currentValueObj forKey:@"x"];
        
    }
    [_brain pushVariable:sender.currentTitle];
    self.history.text = [CalculatorBrain descriptionOfProgram:[self.brain program]];

}

- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = [sender currentTitle]; //Digit pressed
    
    if ([digit isEqualToString:@"."])       //If digit is decimal, need to ensure a decimal doesn't already exist. 
    {
        if (userIsInTheMiddleOfEnteringNumber == NO) { //Do not need to check if new number
            self.display.text = digit;
            userIsInTheMiddleOfEnteringNumber = YES; 
        }
        
        NSRange decimalCheck = [self.display.text rangeOfString:@"."]; //If decimal not in range of string, append
        if (decimalCheck.location == NSNotFound) {              
                self.display.text = [self.display.text stringByAppendingString:digit];
        } else {
            NSLog(@"Decimal point already exists");
        }
    } 
    
    //Non-decimal number
    else {
        if (userIsInTheMiddleOfEnteringNumber) {
            self.display.text = [self.display.text stringByAppendingString:digit];
        } else
        {
            self.display.text = digit;
            self.userIsInTheMiddleOfEnteringNumber = YES;
        }
    }
    
    self.history.text = [CalculatorBrain descriptionOfProgram:[self.brain program]];
}

- (IBAction)enterPressed 
{
    NSLog(@"Test enterpressed");
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.history.text = [CalculatorBrain descriptionOfProgram:[self.brain program]];
    self.userIsInTheMiddleOfEnteringNumber = NO;
    
   

    
    
}


- (IBAction)operationPressed:(UIButton *)sender 
{

    if (self.userIsInTheMiddleOfEnteringNumber)
        [self enterPressed];
    NSString *operation = [sender currentTitle];
    [self.brain performOperation:operation];


    double result;
    NSLog(@"Test operationpressed");
    if ([CalculatorBrain variablesUsedInProgram:[self.brain program]] != nil) {
        NSLog(@"Has a variable");
        id xVal = [_variables valueForKey:@"x"];
        NSLog(@"%@",xVal);
        result = [CalculatorBrain runProgram:[self.brain program] usingVariableValues:[self variables]];
    } else {
        NSLog(@"No variable");
        result = [CalculatorBrain runProgram:[self.brain program]];
        //result = [self.brain performOperation:operation];
    }
    
    NSLog(@"Final result is %g",result);
    self.display.text = [NSString stringWithFormat:@"%g",result];
    self.history.text = [CalculatorBrain descriptionOfProgram:[self.brain program]];
}

//- (float)deltaY:(GraphView *)sender
//{
//    NSLog(@"Calling deltaY");
//    float result;
//
//    //result = [CalculatorBrain runProgram:[self.brain program] usingVariableValues: [self variables]];
//    result = 4;
//    return result;
//}


- (void)viewDidUnload {
    [self setHistory:nil];
    [self setXDisplay:nil];
    [super viewDidUnload];
}

//@property CGFloat contentScaleFactor
@end
