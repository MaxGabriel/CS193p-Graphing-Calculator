
//
//  CalculatorBrain.m
//  Calculator
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University.
//  All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (void)clearCalculator 
{
    [self.programStack removeAllObjects];
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program
{
    NSString *description = [[NSString alloc] init];
    if ([program isKindOfClass:[NSArray class]]) {
        for (int i=0; i<[program count]; i++) {
            
            if ([[program objectAtIndex:i] isKindOfClass:[NSNumber class]]) {
                description = [description stringByAppendingString:[[program objectAtIndex:i] stringValue]];
            } else {
                description = [description stringByAppendingFormat:@"%@",[program objectAtIndex:i]];
            }
            description = [description stringByAppendingString:@" "];
        }
    }
    return description;

//    NSString *description = @"";
//    NSMutableArray *stack;
//    if ([program isKindOfClass:[NSArray class]]) {
//        stack = [program mutableCopy];
//    }
//    
//    //NSLog(@"Stack Count %i",[stack count]);
//    for (int i=0; i<[stack count]; i++) {
//        
//        NSString *temp = @"";
//        //NSLog(@"iTH object is %@", [stack objectAtIndex:i]);
//        if ([[stack objectAtIndex:i] isKindOfClass:[NSNumber class]]) {
//            temp = [temp stringByAppendingString:[[stack objectAtIndex:i] stringValue]];
//        } else {
//            temp = [temp stringByAppendingFormat:@"%@",[stack objectAtIndex:i]];
//        }
//        
//        description = [description stringByAppendingString:temp];
//        description = [description stringByAppendingString:@" "];
//        
//    }
//    return description;
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)pushVariable:(NSString *)variable
{
    [self.programStack addObject:variable];
}

//PROBLEM IS OPERATIONS NOT BEING PUSHED TO STACK. 

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    for (int i=0; i<[self.programStack count]; i++) {
        NSLog(@"%@", [self.programStack objectAtIndex:i]);
    }
    return [[self class] runProgram:self.programStack];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] +
            [self popOperandOffProgramStack:stack];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack] *
            [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"pi"]) {
            result = 3.14;
        }
    }
    return result;
}

+ (BOOL)isOperation:(NSString *)argument
{
    NSSet *operations = [NSSet setWithObjects:@"+",@"-",@"/",@"*",@"sin",@"cos",@"sqrt",@"pi",nil];
    if ([operations containsObject:argument])
        return YES;
    else
        return NO;
}

+ (NSMutableSet *)variablesUsedInProgram:(id)program
{
    NSMutableSet *set = [[NSMutableSet alloc] init];
    for (int i=0; i<[program count]; i++) {
        if ([[program objectAtIndex:i] isKindOfClass:[NSString class]]) {
            if ([CalculatorBrain isOperation:[program objectAtIndex:i]] != YES) {
                [set addObject:[program objectAtIndex:i]];
            } 
        }
    }
    if ([set count] == 0)
        return nil;
    else
        return set;
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}

+ (double)runProgram:(id)program 
 usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy]; 
    }
    

//    for (int i=0; i<[stack count]; i++) {
//        NSLog(@"%@",[stack objectAtIndex:i]);
//    }
    
    for (int i=0; i<[stack count]; i++) {
        if ([[stack objectAtIndex:i] isKindOfClass:[NSString class]] && ![CalculatorBrain isOperation:[stack objectAtIndex:i]]) { //if YES then it is a variable. 
            NSString *variable = [stack objectAtIndex:i];
            [stack replaceObjectAtIndex:i withObject:[variableValues objectForKey:variable]];
        }
            
        }

//    for (int i=0; i<[stack count]; i++) {
//
//        NSLog(@"%@",[stack objectAtIndex:i]);
//    }
    return [self popOperandOffProgramStack:stack];
}

//    NSSet *variablesUsed = [CalculatorBrain variablesUsedInProgram:program];
//    for (NSString *variable in variablesUsed) {
//        
//    }

@end


//#import "CalculatorBrain.h"
//
//@interface CalculatorBrain()
//
//@property (nonatomic, strong) NSMutableArray *operandStack;
//
//@end
//
//@implementation CalculatorBrain
//
//@synthesize operandStack = _operandStack;
//
//- (NSMutableArray *)operandStack
//{
//    if (!_operandStack)
//        _operandStack = [[NSMutableArray alloc] init];
//    return _operandStack;
//}
//
//- (void)clearCalculator 
//{
//    [self.operandStack removeAllObjects];
//}
//
//- (void)pushOperand:(double)operand
//{
//    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
//    [self.operandStack addObject:operandObject];
//}
//
//- (double) popOperand
//{
//    NSNumber *operandObject = [self.operandStack lastObject];
//    if (operandObject) {
//        [self.operandStack removeLastObject];
//    }
//    return [operandObject doubleValue];
//}
//
//- (double)performOperation:(NSString *)operation
//{
//    double result = 0;
//    
//    if ([operation isEqualToString:@"+"]) {
//        result = [self popOperand] + [self popOperand];
//    } else if ([operation isEqualToString:@"*"]) {
//        result = [self popOperand] * [self popOperand];
//    } else if ([operation isEqualToString:@"-"]) {
//        double temp = [self popOperand]; //"subtrahend"
//        result = [self popOperand] - temp;
//    } else if ([operation isEqualToString:@"/"]) {
//        double temp = [self popOperand]; //"divisor"
//        if (temp) result = [self popOperand] / temp; //if checks for 0
//    } else if ([operation isEqualToString:@"sin"]) {
//        result = sin([self popOperand]);
//    } else if ([operation isEqualToString:@"cos"]) {
//        result = cos([self popOperand]);
//    } else if ([operation isEqualToString:@"sqrt"]) {
//        result = sqrt([self popOperand]);
//    } else if ([operation isEqualToString:@"pi"]) {
//        result = 3.14;
//    }
//    
//    [self pushOperand:result];
//    
//    return result;
//}
//
//
//
//
//
//@end
