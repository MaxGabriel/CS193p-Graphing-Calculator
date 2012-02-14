//
//  CalculatorBrain.h
//  RPNCalculator
//
//  Created by Maximilian Tagher on 1/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (void)pushVariable:(NSString *)variable;

- (double)performOperation:(NSString *)operation;

- (void)clearCalculator;


@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (NSSet *)variablesUsedInProgram:(id)program;
+ (BOOL)isOperation:(NSString *)argument;

@end
